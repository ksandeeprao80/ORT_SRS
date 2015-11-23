BEGIN 
	DECLARE @SettingId INT,
	DECLARE @SettingId1 INT,
	DECLARE @SettingId2 INT

	SET @SettingId = 0
	SET @SettingId1 = 0
	SET @SettingId2 = 0

	INSERT INTO MS_SurveySettings
	(SettingType,SettingName,DisplayText)
	VALUES('','SurveyTemplateName','SurveyTemplateName')

	SET @SettingId = @@IDENTITY
	
	INSERT INTO MS_SurveySettings
	(SettingType,SettingName,DisplayText)
	VALUES('','SurveyThankuPage','SurveyThankuPage')  

	SET @SettingId1 = @@IDENTITY

	INSERT INTO MS_SurveySettings
	(SettingType,SettingName,DisplayText) 
	VALUES('','SurveyWelcomePage','SurveyWelcomePage')

	SET @SettingId2 = @@IDENTITY


	INSERT INTO TR_SurveySettings
	(SurveyId,SettingId,CustomerId,Value)
	SELECT DISTINCT SurveyId,@SettingId,CustomerId,'surveyEngine1.html' FROM TR_SurveySettings UNION
	SELECT DISTINCT SurveyId,@SettingId1,CustomerId,'surveyEngine1_ThankYou.html' FROM TR_SurveySettings UNION
	SELECT DISTINCT SurveyId,@SettingId2,CustomerId,'surveyEngine1_welcome.html' FROM TR_SurveySettings 

END