CREATE TABLE #MS_SurveySettings
(SettingId int, SettingType varchar(50), SettingName varchar(50), DisplayText varchar(100))
INSERT INTO #MS_SurveySettings VALUES(1,'','BTN_BACK','BACK BUTTON')
INSERT INTO #MS_SurveySettings VALUES(2,'','BTN_SAVECONTIUNE','SAVE AND CONTINUE LATER')
INSERT INTO #MS_SurveySettings VALUES(3,'','CB_DEFAULTEOS','Default End of Survey')
INSERT INTO #MS_SurveySettings VALUES(4,'','CB_OPENACCESS','OPEN ACCESS')
INSERT INTO #MS_SurveySettings VALUES(5,'','ALLOW_ANONYMOUS','Anyone can take survey')
INSERT INTO #MS_SurveySettings VALUES(6,'','ALLOW_REPEAT','Allow respondent to take survey only once')
INSERT INTO #MS_SurveySettings VALUES(7,'','ALLOW_SAVE_CONTINUE','Allow respondent to incomplete survey and contiune later')
INSERT INTO #MS_SurveySettings VALUES(8,'','ANSWER_FONT','Answer font')
INSERT INTO #MS_SurveySettings VALUES(9,'','ANSWER_FONT_COLOR','Answer font color')
INSERT INTO #MS_SurveySettings VALUES(10,'','ANSWER_FONT_SIZE','Answer font size')
INSERT INTO #MS_SurveySettings VALUES(11,'','BTN_BACK','Allow back button')
INSERT INTO #MS_SurveySettings VALUES(12,'','BY_INVITE','Invites only')
INSERT INTO #MS_SurveySettings VALUES(13,'','E_O_S_EMAIL','Send additional message as Email')
INSERT INTO #MS_SurveySettings VALUES(14,'','E_O_S_MESSAGE','End of survey message from library')
INSERT INTO #MS_SurveySettings VALUES(15,'','E_O_S_EMAIL_ID','End of survey E-Mail, id from library')
INSERT INTO #MS_SurveySettings VALUES(16,'','E_O_S_MESSAGE_ID','End of survey message id from library')
INSERT INTO #MS_SurveySettings VALUES(17,'','E_O_S_REDIRECT_URL','Redirect to URL')
INSERT INTO #MS_SurveySettings VALUES(18,'','HEADER_FONT','Header font')
INSERT INTO #MS_SurveySettings VALUES(19,'','HEADER_FONT_SIZE','Header font size')
INSERT INTO #MS_SurveySettings VALUES(20,'','HEADER_SHOW_DATE_TIME','Display date time')
INSERT INTO #MS_SurveySettings VALUES(21,'','HEADER_TEXT_COLOR','Header Text color')
INSERT INTO #MS_SurveySettings VALUES(22,'','INVITE_HAS_PSW','Password protected invites')
INSERT INTO #MS_SurveySettings VALUES(23,'','QUESTION_FONT','Question font')
INSERT INTO #MS_SurveySettings VALUES(24,'','QUESTION_FONT_COLOR','Question font color')
INSERT INTO #MS_SurveySettings VALUES(25,'','QUESTION_FONT_SIZE','Question font size')
INSERT INTO #MS_SurveySettings VALUES(26,'','AutoAdvance','Auto Advance')
INSERT INTO #MS_SurveySettings VALUES(27,'','BackGroundColor','Background Color')
INSERT INTO #MS_SurveySettings VALUES(28,'','E_O_S_REDIRECT','Redirection')
INSERT INTO #MS_SurveySettings VALUES(29,'','LogoFile','Logo File Name')



SET IDENTITY_INSERT MS_SurveySettings ON

INSERT INTO MS_SurveySettings
(SettingId, SettingType, SettingName, DisplayText)
SELECT 
	SettingId, SettingType, SettingName, DisplayText
FROM #MS_SurveySettings
WHERE SettingId NOT IN(SELECT SettingId FROM MS_SurveySettings)

SET IDENTITY_INSERT MS_SurveySettings OFF



