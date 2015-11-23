SELECT * INTO DBO.MS_SurveySettings_Backup_20121126 FROM MS_SurveySettings
SELECT * INTO DBO.TR_SurveySettings_Backup_20121126 FROM TR_SurveySettings

CREATE TABLE #Settings (SettingName VARCHAR(100))
------------------------------------
INSERT INTO #Settings SELECT ('LogoFile')
INSERT INTO #Settings SELECT ('BackGroundColor')
INSERT INTO #Settings SELECT ('AutoAdvance')
INSERT INTO #Settings SELECT ('BTN_BACK')
INSERT INTO #Settings SELECT ('ALLOW_SAVE_CONTINUE')
INSERT INTO #Settings SELECT ('NextBackTextLink')
INSERT INTO #Settings SELECT ('ALLOW_ANONYMOUS')
INSERT INTO #Settings SELECT ('BY_INVITE')
INSERT INTO #Settings SELECT ('INVITE_HAS_PSW')
INSERT INTO #Settings SELECT ('ALLOW_REPEAT')
INSERT INTO #Settings SELECT ('E_O_S_MESSAGE')
INSERT INTO #Settings SELECT ('E_O_S_MESSAGE_ID')
INSERT INTO #Settings SELECT ('E_O_S_MESSAGE_TEXT')
INSERT INTO #Settings SELECT ('E_O_S_REDIRECT')
INSERT INTO #Settings SELECT ('E_O_S_REDIRECT_URL')
INSERT INTO #Settings SELECT ('E_O_S_EMAIL')
INSERT INTO #Settings SELECT ('E_O_S_EMAIL_ID')
INSERT INTO #Settings SELECT ('E_O_S_EMAIL_TEXT')
INSERT INTO #Settings SELECT ('ANSWER_FONT')
INSERT INTO #Settings SELECT ('ANSWER_FONT_COLOR')
INSERT INTO #Settings SELECT ('ANSWER_FONT_SIZE')
INSERT INTO #Settings SELECT ('HEADER_FONT')
INSERT INTO #Settings SELECT ('HEADER_FONT_SIZE')
INSERT INTO #Settings SELECT ('HEADER_FONT_COLOR')
INSERT INTO #Settings SELECT ('QUESTION_FONT')
INSERT INTO #Settings SELECT ('QUESTION_FONT_COLOR')
INSERT INTO #Settings SELECT ('QUESTION_FONT_SIZE')
INSERT INTO #Settings SELECT ('HEADER_SHOW_DATE_TIME')
INSERT INTO #Settings SELECT ('DateTimeFormat')
INSERT INTO #Settings SELECT ('ValidationAnswerValues')
INSERT INTO #Settings SELECT ('CheckSurveyEnd')
INSERT INTO #Settings SELECT ('RewardApplicable')
INSERT INTO #Settings SELECT ('VerifySkipLogic')
INSERT INTO #Settings SELECT ('RandomizeTestList')
INSERT INTO #Settings SELECT ('TestListRandomNo')
INSERT INTO #Settings SELECT ('AutoPlay')
INSERT INTO #Settings SELECT ('InvitePassword')
INSERT INTO #Settings SELECT ('CheckQuota')
INSERT INTO #Settings SELECT ('QuotaCount')
INSERT INTO #Settings SELECT ('SendQuotaFullEmail')
INSERT INTO #Settings SELECT ('QuotaFullToEmailId')
INSERT INTO #Settings SELECT ('QuotaFullMessageId')
INSERT INTO #Settings SELECT ('TemplateId')
------------------------------------------------


DELETE TSS
FROM DBO.TR_SurveySettings TSS
INNER JOIN MS_SurveySettings MSS
	ON TSS.SettingId = MSS.SettingId
LEFT OUTER JOIN #Settings S
	ON MSS.SettingName = S.settingname
WHERE S.SettingName IS NULL
-- 2,3,4,21,30,31,32,34,35,37,40,41,44,45,47,48,52,53,57

DELETE MSS
FROM DBO.MS_SurveySettings MSS
LEFT OUTER JOIN #Settings S
	ON MSS.SettingName = S.settingname
WHERE S.SettingName IS NULL


INSERT INTO dbo.MS_SurveySettings
(SettingType,SettingName,DisplayText)
SELECT '',S.SettingName,S.SettingName FROM #Settings S
LEFT OUTER JOIN MS_SurveySettings MSS
	ON S.SettingName = MSS.SettingName
WHERE MSS.SettingName IS NULL

