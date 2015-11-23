IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetResponseTextByQuestionNo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetResponseTextByQuestionNo

GO
--select * from TR_SurveyQuestions where questionid = 11947
--EXEC UspGetResponseTextByQuestionNo 1173,15,'tflauzqztgztfk453cbg3o3k' 
CREATE PROCEDURE DBO.UspGetResponseTextByQuestionNo
	@SurveyId INT,
	@QuestionNo INT,
	@SessionId VARCHAR(100)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @QuestionId INT
	SET @QuestionId = 0

	SELECT @QuestionId = QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId AND QuestionNo = @QuestionNo
	
	SELECT 
		TR.ResponseId, TR.QuestionId, TR.AnswerId, TR.RespondentId, LTRIM(RTRIM(TR.SessionId)) AS SessionId,
		ISNULL(TR.[Status],'I') AS [Status], 
		CASE WHEN ISNULL(TR.AnswerId,0) = 0 THEN TR.AnswerText ELSE TSA.AnswerText END AnswerText, 
		ISNULL(TR.ResponseDate,'') AS ResponseDate, ISNULL(TR.SongId,0) AS SongId 
	FROM TR_Responses TR
	LEFT OUTER JOIN dbo.TR_SurveyAnswers TSA
		ON TR.AnswerId = TSA.AnswerId
	WHERE TR.QuestionId = @QuestionId
		AND LTRIM(RTRIM(TR.SessionId)) = LTRIM(RTRIM(@SessionId))
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 