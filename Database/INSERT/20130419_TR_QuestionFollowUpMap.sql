--UPDATE TS
--SET TS.StatusId = 1	
--FROM MS_QuestionSettings MSS
--INNER JOIN TR_QuestionSettings TSS
--	ON MSS.SettingId = TSS.SettingId
--	AND MSS.SettingName = 'IsMediaFollowup'
--	AND TSS.Value = 'True'
--INNER JOIN TR_SurveyQuestions TSQ	
--	ON TSS.QuestionId = TSQ.QuestionId
--INNER JOIN TR_Survey TS
--	ON TSQ.SurveyId = TS.SurveyId
--	AND TS.PublishStatus <> 'P' AND TS.StatusId = 0	
--WHERE TSQ.QuestionNo = 1	
		

--INSERT INTO DBO.TR_QuestionFollowUpMap
--(QuestionId, FollowUpQuestionId)
SELECT A.QuestionId, B.QuestionId AS FollowupQuestionId 
FROM
(
	SELECT 
		MSS.SettingId, MSS.SettingName, TSS.QuestionId, TSS.Value, TSQ.SurveyId, TSQ.QuestionTypeId,
		TSQ.QuestionNo, TSQ.QuestionNo-1 AS NxtQuestionNo 
	FROM MS_QuestionSettings MSS
	INNER JOIN TR_QuestionSettings TSS
		ON MSS.SettingId = TSS.SettingId
		AND MSS.SettingName = 'IsMediaFollowup'
		AND TSS.Value = 'True'
	INNER JOIN TR_SurveyQuestions TSQ	
		ON TSS.QuestionId = TSQ.QuestionId
	INNER JOIN TR_Survey TS
		ON TSQ.SurveyId = TS.SurveyId
		AND TS.PublishStatus <> 'P' 
		AND TS.StatusId = 0	
) A
LEFT JOIN
(
	SELECT SurveyId, QuestionId, QuestionNo
	FROM TR_SurveyQuestions
	
) B
	ON A.SurveyId = B.SurveyId
	AND A.NxtQuestionNo = B.QuestionNo
WHERE A.QuestionTypeId <> 4