IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuestionLibraryAnswers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetQuestionLibraryAnswers]

GO

--EXEC UspGetQuestionLibraryAnswers 1

CREATE PROCEDURE DBO.UspGetQuestionLibraryAnswers
	@QuestionLibId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TQLA.QuestionLibId, TQLA.AnswerId, TQLA.Answer, TQLA.AnswerText
	FROM DBO.TR_QuestionLibraryAnswers TQLA 
	WHERE TQLA.QuestionLibId = @QuestionLibId
	ORDER BY TQLA.AnswerId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 