--SELECT * FROM TR_ReportQuestionMapped

INSERT INTO DBO.TR_ReportQuestionMapped
(ReportId, QuestionId)
SELECT 
	DISTINCT TT.ReportId,TSQ.QuestionId 
FROM DBO.TR_SurveyQuestions TSQ
INNER JOIN
(
	SELECT DISTINCT ReportId, BaseSurveyId FROM TR_Trends
) TT
	ON TSQ.SurveyId = TT.BaseSurveyId
WHERE TSQ.QuestionTypeId IN(1,2,3,5,6,9,16)



 
