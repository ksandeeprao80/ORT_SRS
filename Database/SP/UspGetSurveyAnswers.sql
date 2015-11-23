IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyAnswers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyAnswers]

GO

-- EXEC UspGetSurveyAnswers 
CREATE PROCEDURE DBO.UspGetSurveyAnswers
	@QuestionId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TSA.AnswerId, TSA.QuestionId, LTRIM(RTRIM(ISNULL(TSA.Answer,''))) AS Answer, 
		LTRIM(RTRIM(ISNULL(TSA.AnswerText,''))) AS AnswerText, TSQ.SurveyId, TR.ResponseId
	FROM DBO.TR_SurveyAnswers TSA
	INNER JOIN TR_SurveyQuestions TSQ
		ON TSA.QuestionId= TSQ.QuestionId	
	INNER JOIN TR_Responses TR
		 ON TSA.AnswerId = TR.AnswerId
	WHERE TSA.QuestionId = ISNULL(@QuestionId,TSA.QuestionId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END