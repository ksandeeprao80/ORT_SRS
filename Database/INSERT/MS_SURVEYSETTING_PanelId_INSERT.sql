SET IDENTITY_INSERT MS_SurveySettings ON
INSERT INTO MS_SurveySettings 
(SettingId, SettingType, SettingName, DisplayText)
SELECT 67, '', 'PanelId', 'PanelId'
SET IDENTITY_INSERT MS_SurveySettings OFF

GO

INSERT INTO TR_SurveySettings
SELECT DISTINCT SurveyId, 67,CustomerId,'' FROM TR_SurveySettings
