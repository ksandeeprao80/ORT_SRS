IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptResponsesByQuestion]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptResponsesByQuestion]

GO
-- EXEC UspRptResponsesByQuestion 11139,6

CREATE PROCEDURE DBO.UspRptResponsesByQuestion
	@QuestionId INT,
	@ReportId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	EXEC UspRptFilterSessionIds @QuestionId,@ReportId

	DECLARE @TotalCount DECIMAL
	DECLARE @TextCount DECIMAL	
	
	SET @TotalCount = 0
	SET @TextCount = 0 
	
	IF EXISTS
	(	
		SELECT 1 FROM TR_ReportFilter TRF INNER JOIN dbo.TR_ReportFilterMapping TRFM
		ON TRF.FilterId = TRFM.FilterId AND TRFM.ReportId = @ReportId
	)
	BEGIN
		SELECT @TotalCount = ISNULL(COUNT(TR.AnswerId),0)
		FROM	
		(
			SELECT * FROM DBO.TR_SurveyAnswers WHERE QuestionId = @QuestionId
		) TSA
		LEFT OUTER JOIN 
		(
			SELECT TR.* FROM TR_Responses TR 
			INNER JOIN DBO.TempFilterSessionIds TFSI
				ON TR.SessionId = TFSI.SessionId
			WHERE TR.[Status] = 'C'
		) TR 
			ON TR.AnswerId = TSA.AnswerId
		
		SELECT @TextCount = ISNULL(COUNT(TR.AnswerText),0)
		FROM TR_Responses TR
		INNER JOIN DBO.TempFilterSessionIds TFSI
			ON TR.SessionId = TFSI.SessionId
		WHERE TR.[Status] = 'C' AND TR.QuestionId = @QuestionId 
	END
	ELSE
	BEGIN
		SELECT @TotalCount = ISNULL(COUNT(TR.AnswerId),0)
		FROM	
		(
			SELECT * FROM DBO.TR_SurveyAnswers WHERE QuestionId = @QuestionId
		) TSA
		LEFT OUTER JOIN 
		(
			SELECT TR.* FROM TR_Responses TR 
			WHERE TR.[Status] = 'C'
		) TR 
			ON TR.AnswerId = TSA.AnswerId
		
		SELECT @TextCount = ISNULL(COUNT(TR.AnswerText),0)
		FROM TR_Responses TR
		WHERE TR.[Status] = 'C' AND TR.QuestionId = @QuestionId
	END
	
	IF @TotalCount = 0
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM TR_ReportFilter TRF INNER JOIN dbo.TR_ReportFilterMapping TRFM
			ON TRF.FilterId = TRFM.FilterId AND TRFM.ReportId = @ReportId
		)
		BEGIN
			SELECT 	
				TR.QuestionId, 0 AS AnswerId, TR.AnswerText AS Answer, COUNT(TR.AnswerText) AS AnswerCount,
				STR(ROUND(((COUNT(TR.AnswerText) / @TextCount) * 100),2),12,2) AS Percentage 
			FROM TR_Responses TR
			INNER JOIN DBO.TempFilterSessionIds TFSI
				ON TR.SessionId = TFSI.SessionId
			WHERE TR.[Status] = 'C' AND TR.QuestionId = @QuestionId 
			GROUP BY TR.AnswerText, TR.QuestionId
		END
		ELSE
		BEGIN
			SELECT 	
				TR.QuestionId, 0 AS AnswerId, TR.AnswerText AS Answer, COUNT(TR.AnswerText) AS AnswerCount,
				STR(ROUND(((COUNT(TR.AnswerText) / @TextCount) * 100),2),12,2) AS Percentage 
			FROM TR_Responses TR
			WHERE TR.[Status] = 'C' AND TR.QuestionId = @QuestionId 
			GROUP BY TR.AnswerText, TR.QuestionId
		END
	END
	ELSE
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM TR_ReportFilter TRF INNER JOIN dbo.TR_ReportFilterMapping TRFM
			ON TRF.FilterId = TRFM.FilterId AND TRFM.ReportId = @ReportId
		)
		BEGIN
			SELECT 	
				TSA.QuestionId, TSA.AnswerId, TSA.Answer, COUNT(TR.AnswerId) AS AnswerCount,
				STR(ROUND(((COUNT(TR.AnswerId) / @TotalCount) * 100),2),12,2) AS Percentage 
			FROM 
			(
				SELECT * FROM DBO.TR_SurveyAnswers WHERE QuestionId = @QuestionId
			) TSA
			LEFT OUTER JOIN 
			(
				SELECT TR.* FROM TR_Responses TR
				INNER JOIN DBO.TempFilterSessionIds TFSI
					ON TR.SessionId = TFSI.SessionId
				WHERE TR.[Status] = 'C'
			) TR 
				ON TR.AnswerId = TSA.AnswerId
			GROUP BY TSA.AnswerId, TSA.QuestionId, TSA.Answer
		END
		ELSE
		BEGIN
			SELECT 	
				TSA.QuestionId, TSA.AnswerId, TSA.Answer, COUNT(TR.AnswerId) AS AnswerCount,
				STR(ROUND(((COUNT(TR.AnswerId) / @TotalCount) * 100),2),12,2) AS Percentage 
			FROM 
			(
				SELECT * FROM DBO.TR_SurveyAnswers WHERE QuestionId = @QuestionId
			) TSA
			LEFT OUTER JOIN 
			(
				SELECT TR.* FROM TR_Responses TR
				WHERE TR.[Status] = 'C'
			) TR 
				ON TR.AnswerId = TSA.AnswerId
			GROUP BY TSA.AnswerId, TSA.QuestionId, TSA.Answer
		END
	END
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


