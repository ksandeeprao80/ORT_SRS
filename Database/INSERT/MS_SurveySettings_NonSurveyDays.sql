
IF NOT EXISTS(SELECT 1 FROM MS_SurveySettings WHERE SettingName = 'NonSurveyDays')
BEGIN
	SET IDENTITY_INSERT MS_SurveySettings ON

	INSERT INTO MS_SurveySettings 
	(SettingId, SettingType, SettingName, DisplayText)
	SELECT 68, '', 'NonSurveyDays', 'NonSurveyDays'

	INSERT INTO TR_SurveySettings
	SELECT DISTINCT SurveyId, 68,CustomerId,'' FROM TR_SurveySettings

	SET IDENTITY_INSERT MS_SurveySettings OFF
END

