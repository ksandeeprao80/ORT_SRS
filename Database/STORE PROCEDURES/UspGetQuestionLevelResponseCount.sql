IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuestionLevelResponseCount]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetQuestionLevelResponseCount

GO

-- EXEC UspGetQuestionLevelResponseCount 11095,109821,NULL -- AnswerId
-- EXEC UspGetQuestionLevelResponseCount 11093,NULL,'35' -- AnswerText
CREATE PROCEDURE DBO.UspGetQuestionLevelResponseCount
	@QuestionId INT,
	@AnswerId INT = NULL,
	@AnswerText VARCHAR(250) = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @AnswerCount TABLE 
	(QuestionId INT, AnswerId INT, AnswerText VARCHAR(100))

	IF @AnswerId IS NULL OR @AnswerId = ''
	BEGIN
		INSERT INTO @AnswerCount
		(QuestionId, AnswerId, AnswerText)
		SELECT 
			TR.QuestionId, TR.AnswerId, TR.AnswerText
		FROM DBO.TR_Responses TR
		WHERE TR.QuestionId = @QuestionId
			AND LTRIM(RTRIM(TR.AnswerText)) = LTRIM(RTRIM(@AnswerText))
			AND TR.[Status] = 'C'
		
		SELECT ISNULL(COUNT(1),0) ResponseCount FROM @AnswerCount
	END
	ELSE
	BEGIN
		INSERT INTO @AnswerCount
		(QuestionId, AnswerId, AnswerText)
		SELECT 
			TR.QuestionId, TR.AnswerId, TR.AnswerText
		FROM DBO.TR_Responses TR
		WHERE TR.QuestionId = @QuestionId
			AND TR.AnswerId = @AnswerId
			AND TR.[Status] = 'C'
		
		SELECT ISNULL(COUNT(1),0) ResponseCount FROM @AnswerCount
	END
 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
 