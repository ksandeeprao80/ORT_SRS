INSERT INTO TR_SurveySettings
(SurveyId,SettingId,CustomerId,Value)
SELECT 
	1087,SettingId,2,
	CASE WHEN SettingName IN('AutoAdvance','BTN_BACK','ALLOW_SAVE_CONTINUE','ALLOW_ANONYMOUS',
		'INVITE_HAS_PSW','ALLOW_REPEAT','E_O_S_MESSAGE','E_O_S_REDIRECT','') 
		THEN 1 ELSE '' END
FROM MS_SurveySettings