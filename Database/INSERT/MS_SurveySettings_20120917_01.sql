BEGIN 
	DECLARE @SettingId INT,
	 	@SettingId1 INT,
		@SettingId2 INT,
		@SettingId3 INT

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

	INSERT INTO MS_SurveySettings
	(SettingType,SettingName,DisplayText) 
	VALUES('','HEADER_FONT_COLOR','Header font color')
-
	SET @SettingId3 = @@IDENTITY


	INSERT INTO TR_SurveySettings
	(SurveyId,SettingId,CustomerId,Value)
	SELECT DISTINCT SurveyId,@SettingId,CustomerId,'surveyEngine1.html' FROM TR_SurveySettings UNION
	SELECT DISTINCT SurveyId,@SettingId1,CustomerId,'surveyEngine1_ThankYou.html' FROM TR_SurveySettings UNION
	SELECT DISTINCT SurveyId,@SettingId2,CustomerId,'surveyEngine1_welcome.html' FROM TR_SurveySettings UNION
	SELECT DISTINCT SurveyId,@SettingId3,CustomerId,'#000000' FROM TR_SurveySettings UNION

	INSERT INTO TR_SurveySettings
	(SurveyId,SettingId,CustomerId,Value)
	SELECT DISTINCT SurveyId,25,CustomerId,'14px' FROM TR_SurveySettings UNION -- Que-- Size
	SELECT DISTINCT SurveyId,10,CustomerId,'12px' FROM TR_SurveySettings UNION 
	SELECT DISTINCT SurveyId,19,CustomerId,'20px' FROM TR_SurveySettings UNION 
	SELECT DISTINCT SurveyId,8,CustomerId,'Verdana' FROM TR_SurveySettings UNION -- Ans --Font
	SELECT DISTINCT SurveyId,18,CustomerId,'Verdana' FROM TR_SurveySettings UNION -- Header
	SELECT DISTINCT SurveyId,23,CustomerId,'Verdana' FROM TR_SurveySettings UNION -- Que
	SELECT DISTINCT SurveyId,24,CustomerId,'#fff' FROM TR_SurveySettings UNION -- Que -- Colour
	SELECT DISTINCT SurveyId,9,CustomerId,'#000000' FROM TR_SurveySettings  -- Ans

END

