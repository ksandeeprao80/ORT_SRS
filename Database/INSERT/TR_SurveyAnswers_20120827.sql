INSERT INTO DBO.TR_SurveyAnswers
(QuestionId,Answer,AnswerText)
SELECT 
	TSQ.QuestionId, TSA.Answer,TSA.AnswerText 
FROM TR_SurveyAnswers TSA,TR_SurveyQuestions TSQ
WHERE TSQ.QuestionId <> 1
ORDER BY TSQ.QuestionId

