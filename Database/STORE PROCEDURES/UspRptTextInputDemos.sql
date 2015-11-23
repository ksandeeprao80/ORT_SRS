IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptTextInputDemos]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptTextInputDemos]

GO

-- EXEC UspRptTextInputDemos 15423
CREATE PROCEDURE DBO.UspRptTextInputDemos
	@QuestionId INT  
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY
 
	SELECT  
		DISTINCT TSQ.QuestionId, LTRIM(RTRIM(ISNULL(TR.AnswerText,''))) AS AnswerText, TSQ.SurveyId,
		LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TR.AnswerText AS Demo
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.TR_SurveyQuestions TSQ
		ON TR.QuestionId= TSQ.QuestionId	
		AND TSQ.QuestionId = @QuestionId AND TR.Status = 'C'
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END