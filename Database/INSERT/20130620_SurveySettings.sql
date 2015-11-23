IF NOT EXISTS(SELECT 1 FROM MS_SurveySettings WHERE SettingName = 'ReferFriend')
BEGIN 
	SET IDENTITY_INSERT MS_SurveySettings ON

	INSERT INTO MS_SurveySettings
	(SettingId, SettingType,SettingName,DisplayText)
	VALUES(76, '','ReferFriend','ReferFriend')

	INSERT INTO TR_SurveySettings
	(SurveyId,SettingId,CustomerId,Value)
	SELECT DISTINCT SurveyId,76,CustomerId,'False' FROM TR_SurveySettings 
	
	INSERT INTO MS_SurveySettings
	(SettingId, SettingType,SettingName,DisplayText)
	VALUES(77, '','ReferMessageLibId','ReferMessageLibId')

	INSERT INTO TR_SurveySettings
	(SurveyId,SettingId,CustomerId,Value)
	SELECT DISTINCT SurveyId,77,CustomerId,'' FROM TR_SurveySettings  

	SET IDENTITY_INSERT MS_SurveySettings OFF
END

 
 
 