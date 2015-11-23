--SELECT TTOM.TOMId,TTOM.BaseOptionName, TT.BaseSurveyId,  TTOM.BaseQuestionId, B.QuestionId
UPDATE TTOM
SET TTOM.BaseQuestionId= B.QuestionId
FROM TR_TrendOptionMapping TTOM
INNER JOIN TR_Trends TT ON TTOM.TrendId = TT.TrendId 
INNER JOIN 
(	SELECT DISTINCT A.Answer, B.SurveyId, B.QuestionId FROM TR_SurveyAnswers A
	INNER JOIN TR_SurveyQuestions B ON A.QuestionId = B.QuestionId  
) B ON TT.BaseSurveyId =  B.SurveyId AND TTOM.BaseOptionName = B.Answer
WHERE TTOM.BaseQuestionId IS NULL

GO
--SELECT TTOM.TOMId,TTOM.OptionName, TT.BaseSurveyId,  TTOM.OptionQuestionId, B.QuestionId
UPDATE TTOM
SET TTOM.OptionQuestionId = B.QuestionId
FROM TR_TrendOptionMapping TTOM
INNER JOIN TR_Trends TT ON TTOM.TrendId = TT.TrendId 
INNER JOIN 
(	SELECT DISTINCT A.Answer, B.SurveyId, B.QuestionId FROM TR_SurveyAnswers A
	INNER JOIN TR_SurveyQuestions B ON A.QuestionId = B.QuestionId  
) B ON TT.BaseSurveyId =  B.SurveyId AND TTOM.OptionName = B.Answer
WHERE TTOM.OptionQuestionId IS NULL