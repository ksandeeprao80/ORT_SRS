SELECT * INTO TR_Survey_Backup_20130325 FROM TR_Survey

UPDATE TR_Survey
SET IsActive = 0, StatusId = 0


UPDATE TS
SET	TS.IsActive = 1, 
	TS.StatusId = 1
FROM TR_Survey TS	
INNER JOIN
(
	SELECT TSQ.SurveyId FROM TR_Responses TR
	INNER JOIN TR_SurveyQuestions TSQ
	ON TR.QuestionId = TSQ.QuestionId
) TR
	ON TS.SurveyId = TR.SurveyId