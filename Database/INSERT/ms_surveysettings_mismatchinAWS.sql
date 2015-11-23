DELETE FROM MS_SurveySettings WHERE SettingId = 46
GO
UPDATE MS_SurveySettings SET SettingType = 'E_O_S_EMAIL_ID', DisplayText = 'End of survey E-Mail, id from library'  WHERE SettingId = 15	 
UPDATE MS_SurveySettings SET SettingType = 'SurveyExpiredPage', DisplayText ='Survey Expired Page' WHERE SettingId = 47		
UPDATE MS_SurveySettings SET SettingType = 'SurveyRewardPage', DisplayText ='Survey Reward Page' WHERE SettingId = 48		
UPDATE MS_SurveySettings SET SettingType = 'RandomizeTestList', DisplayText ='RandomizeTestList' WHERE SettingId = 49		
UPDATE MS_SurveySettings SET SettingType = 'TestListRandomNo', DisplayText ='TestListRandomNo' WHERE SettingId = 50		
UPDATE MS_SurveySettings SET SettingType = 'AutoPlay', DisplayText ='AutoPlay' WHERE SettingId = 51

GO

SET IDENTITY_INSERT MS_SurveySettings ON
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)
SELECT 52,'','SurveyEndofBlockPage','surveyEngine1_EndOfBlock'
SET IDENTITY_INSERT MS_SurveySettings OFF
