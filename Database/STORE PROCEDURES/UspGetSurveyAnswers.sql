IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyAnswers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyAnswers]

GO

-- EXEC UspGetSurveyAnswers 11146
CREATE PROCEDURE DBO.UspGetSurveyAnswers
	@QuestionId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TSA.AnswerId, TSA.QuestionId, LTRIM(RTRIM(ISNULL(TSA.Answer,''))) AS Answer, 
		LTRIM(RTRIM(ISNULL(TSA.AnswerText,''))) AS AnswerText, TSQ.SurveyId
	FROM DBO.PB_TR_SurveyAnswers TSA
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ
		ON TSA.QuestionId= TSQ.QuestionId	
		AND TSA.QuestionId = ISNULL(@QuestionId,TSA.QuestionId)
		AND TSQ.IsDeleted = 1
	ORDER BY TSA.AnswerId ASC
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END