IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetResponsesForExport]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetResponsesForExport]

GO
-- EXEC UspGetResponsesForExport 1518,'C'--Local
-- EXEC UspGetResponsesForExport 1098,'C'--Prod
-- EXEC UspGetResponsesForExport 1317,'C'

CREATE PROCEDURE DBO.UspGetResponsesForExport
	@SurveyId INT,
	@Status CHAR(1)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @xmlResult XML
	DECLARE @MtbSongs SurveySongs
	
	INSERT INTO @MtbSongs
	(SongSrNo, SongId, QuestionId)
	SELECT ROW_NUMBER() OVER(ORDER BY T.SongId),T.SongId,T.QuestionId FROM DBO.UdfRespondentSongs(@SurveyId) T
   
	DECLARE @ExportData TABLE
	(
		RespondentId INT, V1 VARCHAR(1000), V2 VARCHAR(30), V3 VARCHAR(150), V4 VARCHAR(1), 
		V5 VARCHAR(100), V6 VARCHAR(1000), V7 DATETIME, V8 DATETIME, Answers NVARCHAR(MAX), 
		MultipleSession VARCHAR(1000), MultipleIP VARCHAR(1000)
	)
	INSERT INTO @ExportData
	(
		RespondentId, V1, V2, V3, V4, V5, V6, V7, V8, Answers
	)
	SELECT 
		MR.RespondentId, TR.SessionId AS V1, 'Default Response Set' AS V2,
		CASE WHEN ISNULL(MR.FirstName,'') = '' THEN 'Anonymous' ELSE '"'+ISNULL(MR.LastName,'')+','+MR.FirstName+'"' END AS V3,
		'' AS V4, ISNULL(MR.EmailId,'') AS V5, 
		DBO.FN_IpaddresOfSessionId(@SurveyId,TR.SessionId,TR.RespondentId,@Status) AS V6,
		--ISNULL(TR.IpAddress,'') AS V6,
		CONVERT(VARCHAR(10),MIN(TR.ResponseDate),101)+' '+CONVERT(VARCHAR(8),MIN(TR.ResponseDate),108)
			+ CASE WHEN CONVERT(VARCHAR(2),MIN(TR.ResponseDate),108)>=12 THEN ' PM' ELSE 'AM' END AS V7,
		CONVERT(VARCHAR(10),MAX(TR.ResponseDate),101)+' '+CONVERT(VARCHAR(8),MAX(TR.ResponseDate),108)
			+ CASE WHEN CONVERT(VARCHAR(2),MAX(TR.ResponseDate),108)>=12 THEN ' PM' ELSE 'AM' END AS V8,
		DBO.UdfGetCommaSepResponse(TR.SessionId,@SurveyId,@Status,TR.RespondentId,@MtbSongs) AS Answers
	FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	INNER JOIN DBO.MS_QuestionTypes MQT WITH(NOLOCK)
		ON TSQ.QuestionTypeId = MQT.QuestionTypeId
		AND TSQ.SurveyId = @SurveyId
		AND MQT.QuestionCode NOT IN('PageBreak','EndOfBlock')
		AND TSQ.QuestionNo <> 0
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
		ON TSQ.QuestionId = TR.QuestionId
	LEFT OUTER JOIN DBO.MS_Respondent MR WITH(NOLOCK)
		  ON TR.RespondentId = MR.RespondentId
	WHERE TR.[Status] = CASE WHEN @Status = 'A' THEN TR.[Status] ELSE @Status END	
	GROUP BY MR.RespondentId,TR.SessionId,MR.FirstName,MR.LastName,MR.EmailId,TR.RespondentId

	DECLARE @LoopForColasec TABLE 
	(RowId INT IDENTITY(1,1), RespondentId INT, DoubleIPorSession INT)
	INSERT INTO @LoopForColasec
	(RespondentId, DoubleIPorSession) 
	SELECT RespondentId, COUNT(1) AS DoubleIPorSession 
	FROM @ExportData GROUP BY RespondentId HAVING COUNT(1) > 1

	IF EXISTS(SELECT 1 FROM @LoopForColasec) 
	BEGIN
		DECLARE @MinRow INT
		DECLARE @MaxRow INT
		DECLARE @MultipleSession VARCHAR(1000)
		DECLARE @MultipleIP VARCHAR(1000)
		
		SELECT @MinRow = MIN(RowId), @MaxRow = MAX(RowId) FROM @LoopForColasec
		
		WHILE @MinRow <= @MaxRow
		BEGIN
			SELECT 
				@MultipleSession = COALESCE(@MultipleSession+'|','')+B.V1
			FROM @LoopForColasec A
			INNER JOIN @ExportData B ON A.RespondentId = B.RespondentId 
			WHERE A.RowId = @MinRow GROUP BY B.V1
			
			SELECT 
				@MultipleIP = COALESCE(@MultipleIP+'|','')+B.V6  
			FROM @LoopForColasec A
			INNER JOIN @ExportData B ON A.RespondentId = B.RespondentId 
			WHERE A.RowId = @MinRow GROUP BY B.V6
			
			UPDATE A
			SET A.MultipleSession = @MultipleSession,
				A.MultipleIP  = @MultipleIP,
				A.V7 = B.V7,
				A.V8 = B.V8
			FROM @ExportData A
			INNER JOIN 
			(
				SELECT A.RespondentId, MIN(V7) AS V7,MIN(V8) AS V8 
				FROM @ExportData A
				INNER JOIN @LoopForColasec B	
					ON A.RespondentId = B.RespondentId
				WHERE B.RowId = @MinRow
				GROUP BY A.RespondentId
			) B
				ON A.RespondentId = B.RespondentId
			
			SET @MultipleSession = NULL
			SET @MultipleIP = NULL
								
			SET @MinRow = @MinRow+1
		END	
		
		UPDATE @ExportData 
		SET MultipleSession = V1
		WHERE ISNULL(MultipleSession,'') = '' 
		
		UPDATE @ExportData 
		SET MultipleIP = V6
		WHERE ISNULL(MultipleIP,'') = ''
		
		SET @XmlResult =
		(
			SELECT 
			(
				SELECT 
					MultipleSession AS V1, V2, V3, V4, V5, MultipleIP AS V6, 
					V7, V8, Answers
				FOR XML PATH('ResponeExportViewModel'), TYPE 
			) 	 
			FROM @ExportData
			GROUP BY MultipleSession, V2, V3, V4, V5, MultipleIP, V7, V8, Answers
			FOR XML PATH(''), ROOT('ArrayOfResponeExportViewModel')
		)
		
		SELECT @XmlResult AS XmlResult	
	END
	ELSE
	BEGIN
		SET @XmlResult =
		(
			SELECT 
			(
				SELECT
					V1, V2, V3, V4, V5, V6, V7, V8, Answers
				FOR XML PATH('ResponeExportViewModel'), TYPE 
			) 	 
			FROM @ExportData
			FOR XML PATH(''), ROOT('ArrayOfResponeExportViewModel')
		)
		
		SELECT @XmlResult AS XmlResult
	END
	 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END 
