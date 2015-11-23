IF NOT EXISTS(SELECT 1 FROM MS_SurveySettings WHERE SettingName = 'InclueOnlyCompletedResponses')
BEGIN 
	SET IDENTITY_INSERT MS_SurveySettings ON

	INSERT INTO MS_SurveySettings
	(SettingId, SettingType,SettingName,DisplayText)
	VALUES(75, '','InclueOnlyCompletedResponses','InclueOnlyCompletedResponses')

	INSERT INTO TR_SurveySettings
	(SurveyId,SettingId,CustomerId,Value)
	SELECT DISTINCT SurveyId,75,CustomerId,'False' FROM TR_SurveySettings  

	SET IDENTITY_INSERT MS_SurveySettings OFF
END

 