UPDATE TR_SurveySettings SET Value = 'BACK BUTTON'
GO
INSERT INTO DBO.TR_SurveySettings
SELECT 1,SettingId,2,DisplayText FROM MS_SurveySettings WHERE SettingId IN (2,3,4)


 
