IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetAnswerById]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetAnswerById

GO
-- UspGetAnswerById 1
CREATE PROCEDURE DBO.UspGetAnswerById 
	@AnswerId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		AnswerId, QuestionId, Answer, AnswerText 
	FROM DBO.PB_TR_SurveyAnswers 
	WHERE AnswerId = @AnswerId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
