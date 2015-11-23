IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetBaseOptions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetBaseOptions]

GO

-- EXEC UspGetBaseOptions 8846,'Market Research Company'

CREATE PROCEDURE DBO.UspGetBaseOptions
	@QuestionId INT,
	@AnswerText VARCHAR(1000)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		QuestionId, AnswerText	 
	FROM DBO.TR_SurveyAnswers
	WHERE QuestionId = @QuestionId
		AND LTRIM(RTRIM(AnswerText)) <> LTRIM(RTRIM(@AnswerText))
 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

