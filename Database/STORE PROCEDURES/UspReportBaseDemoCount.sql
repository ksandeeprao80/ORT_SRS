IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspReportBaseDemoCount]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspReportBaseDemoCount 

GO  
-- EXEC DBO.UspReportBaseDemoCount 2007
CREATE PROCEDURE DBO.UspReportBaseDemoCount
	@SurveyId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY 	

	SELECT 
		Answer, ResCount 
	FROM
	(
		SELECT 
			TR.RespondentId, TSA.Answer, COUNT(1) AS ResCount 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C'
			AND TSQ.SurveyId = @SurveyId
		INNER JOIN DBO.TR_SurveyAnswers TSA WITH(NOLOCK)
			ON TR.AnswerId = TSA.AnswerId	
		GROUP BY TR.RespondentId, TSA.Answer
	) TR1
	--GROUP BY Answer
	UNION
	SELECT 
		Answer, ResCount 
	FROM
	(
		SELECT 
			TR.RespondentId, 
			(LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TR.AnswerText) AS Answer, 
			COUNT(1) AS ResCount 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C'
			AND TR.SongId = 0 AND TR.AnswerId = 0
			AND TSQ.SurveyId = @SurveyId	 
		GROUP BY TR.RespondentId, TR.AnswerText, TSQ.QuestionText
	) TR1
	--GROUP BY Answer	
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

