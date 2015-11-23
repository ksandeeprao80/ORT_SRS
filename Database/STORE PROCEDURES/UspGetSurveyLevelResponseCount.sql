IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyLevelResponseCount]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetSurveyLevelResponseCount

GO
-- EXEC USPGetSurveyLevelResponseCount 1136
CREATE PROCEDURE DBO.UspGetSurveyLevelResponseCount
	@SurveyId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @SurveyCount TABLE 
	(SurveyId INT, SessionId VARCHAR(100), RespondentId INT)
	INSERT INTO @SurveyCount
	(SurveyId, SessionId, RespondentId)
	SELECT 
		DISTINCT TSQ.SurveyId, TR.SessionId, TR.RespondentId
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId
		AND TSQ.SurveyId = @SurveyId
		AND TR.[Status] = 'C'
		
	SELECT ISNULL(COUNT(1),0) ResponseCount FROM @SurveyCount
 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
 