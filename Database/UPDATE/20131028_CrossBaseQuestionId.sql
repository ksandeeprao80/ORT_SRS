UPDATE A
SET A.BaseQuestionId = B.QuestionId
--SELECT A.*,B.QuestionId 
FROM TR_TrendCrossTabs A
INNER JOIN 
(
	SELECT DISTINCT A.Answer, B.SurveyId, B.QuestionId FROM TR_SurveyAnswers A
	INNER JOIN TR_SurveyQuestions B ON A.QuestionId = B.QuestionId  
) B
ON A.BaseSurveyId = B.SurveyId
AND A.BaseOptionName = B.Answer