DECLARE @SettingName VARCHAR(20)
SET @SettingName = 'CheckQuota'

IF NOT EXISTS(SELECT 1 FROM MS_SurveySettings WHERE SettingName= @SettingName)
BEGIN
	SET IDENTITY_INSERT MS_SurveySettings ON
	INSERT INTO DBO.MS_SurveySettings
	(SettingId,SettingType,SettingName,DisplayText)
	SELECT 55,'',@SettingName,@SettingName
	
	INSERT INTO DBO.MS_SurveySettings
	(SettingId,SettingType,SettingName,DisplayText)
	SELECT 56,'','QuotaCount','QuotaCount'
	
	INSERT INTO DBO.MS_SurveySettings
	(SettingId,SettingType,SettingName,DisplayText)
	SELECT 57,'','QuotaExpirePage','QuotaExpirePage'
	
	INSERT INTO DBO.MS_SurveySettings
	(SettingId,SettingType,SettingName,DisplayText)
	SELECT 58,'','SendQuotaFullEmail','SendQuotaFullEmail'
	
	INSERT INTO DBO.MS_SurveySettings
	(SettingId,SettingType,SettingName,DisplayText)
	SELECT 59,'','QuotaFullToEmailId','QuotaFullToEmailId'
	
	INSERT INTO DBO.MS_SurveySettings
	(SettingId,SettingType,SettingName,DisplayText)
	SELECT 60,'','QuotaFullMessageId','QuotaFullMessageId'
	
	SET IDENTITY_INSERT MS_SurveySettings OFF
END


IF NOT EXISTS(SELECT 1 FROM MS_QuestionSettings WHERE SettingName= @SettingName)
BEGIN
	SET IDENTITY_INSERT MS_QuestionSettings ON
	INSERT INTO DBO.MS_QuestionSettings
	(SettingId,SettingName)
	SELECT 16,@SettingName
	SET IDENTITY_INSERT MS_QuestionSettings OFF
END
