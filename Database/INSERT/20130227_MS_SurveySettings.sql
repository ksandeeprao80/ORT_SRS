IF NOT EXISTS(SELECT 1 FROM MS_SurveySettings WHERE SettingName IN('SEND_DEFAULT_MESSAGE_ID','SEND_REMINDER_MESSAGE_ID'))
BEGIN
	SET IDENTITY_INSERT MS_SurveySettings ON

	INSERT INTO MS_SurveySettings 
	(SettingId, SettingType, SettingName, DisplayText)
	SELECT 69, '', 'SEND_DEFAULT_MESSAGE_ID', 'SEND_DEFAULT_MESSAGE_ID'

	INSERT INTO TR_SurveySettings
	SELECT DISTINCT SurveyId, 69,CustomerId,'' FROM TR_SurveySettings
	
	INSERT INTO MS_SurveySettings 
	(SettingId, SettingType, SettingName, DisplayText)
	SELECT 70, '', 'SEND_REMINDER_MESSAGE_ID', 'SEND_REMINDER_MESSAGE_ID'

	INSERT INTO TR_SurveySettings
	SELECT DISTINCT SurveyId, 70,CustomerId,'' FROM TR_SurveySettings
	
	SET IDENTITY_INSERT MS_SurveySettings OFF
END
 