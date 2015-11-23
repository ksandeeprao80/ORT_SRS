IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveWinner]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveWinner 

GO  
-- UspSaveWinner 1158
-- SELECT * FROM DBO.TR_Winner
CREATE PROCEDURE DBO.UspSaveWinner
	@SurveyId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @SQL NVARCHAR(MAX)	
	DECLARE @TotalRewards INT
	DECLARE @CurrentDate DATETIME
	SET @CurrentDate = GETDATE()
	SET @TotalRewards = 0

	SELECT @TotalRewards = CONVERT(INT,TotalRewards) FROM TR_Reward WHERE SurveyId = @SurveyId

	CREATE TABLE #Winner 
	(SessionId VARCHAR(100), RespondentId INT, IpAddress VARCHAR(30), RespondentName VARCHAR(100), Email VARCHAR(50))

	SELECT @SQL ='
	SELECT TOP ' +CONVERT(VARCHAR(12),@TotalRewards)+ '   
		TR.SessionId, TR.RespondentId, TR.IpAddress, ISNULL(MR.FirstName,'''')+'' ''+ISNULL(MR.LastName,'''') AS RespondentName,
		ISNULL(MR.EmailId,'''') AS Email 
	FROM DBO.TR_Responses TR
	INNER JOIN dbo.TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId
		AND TR.[Status] = ''C''
		AND TSQ.SurveyId = '+CONVERT(VARCHAR(12),@SurveyId)+'
	LEFT OUTER JOIN dbo.MS_Respondent MR
		ON TR.RespondentId = MR.RespondentId
	GROUP BY TR.SessionId, TR.RespondentId, TR.IpAddress, ISNULL(MR.FirstName,''''),ISNULL(MR.LastName,''''),ISNULL(MR.EmailId,'''') 	
	ORDER BY NEWID()'
 
	INSERT INTO #Winner
	(SessionId,RespondentId,IpAddress,RespondentName,Email)
	EXEC SP_Executesql @SQL  
	
	INSERT INTO DBO.TR_Winner
	(SurveyId, RespondentIdentity, RespondentRef, RespondentType, CreatedDate, RespondentId)
	SELECT 
		@SurveyId AS SurveyId, 
		CASE WHEN RespondentId = 0 THEN SessionId ELSE RespondentName END AS RespondentIdentity,
		CASE WHEN RespondentId = 0 THEN ISNULL(IpAddress,'') ELSE Email END AS RespondentRef,
		CASE WHEN RespondentId = 0 THEN 'A' ELSE 'P' END AS RespondentType,
		@CurrentDate AS CreatedDate, RespondentId
	FROM #Winner
		
	IF EXISTS(SELECT 1 FROM #Winner)
	BEGIN
		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark 
	END
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'Insert Failed' AS Remark 
	END
	
	DROP TABLE #Winner
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
	