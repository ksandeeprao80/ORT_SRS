IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetDeactivatedQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetDeactivatedQuestions
GO
--   EXEC UspGetDeactivatedQuestions NULL,8921
--   EXEC UspGetDeactivatedQuestions 1101,NULL

CREATE PROCEDURE DBO.UspGetDeactivatedQuestions
	@SurveyId INT = NULL,
	@QuestionId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY 
	
	SELECT * FROM DBO.TR_SurveyQuestions 
	WHERE IsDeleted = 0
		AND SurveyId = ISNULL(@SurveyId,SurveyId) 
		AND QuestionId = ISNULL(@QuestionId,QuestionId) 
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


