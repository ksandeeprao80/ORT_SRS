DELETE FROM TR_SurveySettings WHERE SettingId IN(SELECT SettingId FROM MS_SurveySettings WHERE SettingName IN('VerificationQuestion','2ndValidation'))
DELETE FROM MS_SurveySettings WHERE SettingName IN('VerificationQuestion','2ndValidation')

GO

DECLARE @VerifyRespondentInfo VARCHAR(150)
DECLARE @VerfiyDefaultAnswer VARCHAR(150)
DECLARE @DefaultAnswerToVerify VARCHAR(150)
SET @VerifyRespondentInfo = 'VerifyRespondentInfo'
SET @VerfiyDefaultAnswer = 'VerfiyDefaultAnswer'
SET @DefaultAnswerToVerify = 'DefaultAnswerToVerify'


IF NOT EXISTS(SELECT 1 FROM DBO.MS_QuestionSettings WHERE LTRIM(RTRIM(SettingName)) = @VerifyRespondentInfo)
BEGIN
	INSERT INTO DBO.MS_QuestionSettings
	(SettingName)
	VALUES(@VerifyRespondentInfo)
END


IF NOT EXISTS(SELECT 1 FROM DBO.MS_QuestionSettings WHERE LTRIM(RTRIM(SettingName)) = @VerfiyDefaultAnswer)
BEGIN
	INSERT INTO DBO.MS_QuestionSettings
	(SettingName)
	VALUES(@VerfiyDefaultAnswer)
END

IF NOT EXISTS(SELECT 1 FROM DBO.MS_QuestionSettings WHERE LTRIM(RTRIM(SettingName)) = @DefaultAnswerToVerify)
BEGIN
	INSERT INTO DBO.MS_QuestionSettings
	(SettingName)
	VALUES(@DefaultAnswerToVerify)
END


 