DECLARE @SettingName VARCHAR(150)
SET @SettingName = 'InvitePassword'
IF NOT EXISTS(SELECT 1 FROM MS_SurveySettings WHERE SettingName = @SettingName)
BEGIN
	INSERT INTO dbo.MS_SurveySettings
	(SettingType, SettingName, DisplayText)
	SELECT '','InvitePassword','InvitePassword'
END