DECLARE @SettingName VARCHAR(100)
SET @SettingName = 'AccessDeniedPage'

IF NOT EXISTS
(
	SELECT 1 FROM DBO.MS_SurveySettings 
	WHERE LTRIM(RTRIM(SettingName)) = LTRIM(RTRIM(@SettingName))
)
BEGIN
	DECLARE @SettingId INT
	SET @SettingId = 0
	
	INSERT INTO DBO.MS_SurveySettings
	(SettingType,SettingName,DisplayText)
	SELECT '',LTRIM(RTRIM(@SettingName)), LTRIM(RTRIM(@SettingName))
	
	SET @SettingId = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveySettings
	(SurveyId, SettingId, CustomerId, Value)
	SELECT 
		DISTINCT SurveyId,@SettingId,CustomerId,'surveyEngine1_AccessDenied.html' 
	FROM DBO.TR_SurveySettings
END

