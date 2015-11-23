INSERT INTO TR_SurveySettings
(SurveyId,SettingId,CustomerId,Value)
SELECT 1158,SettingId,1,'dd-mm-yyyy' FROM MS_SurveySettings WHERE SettingName = 'DateTimeFormat'
UNION
SELECT 1158,SettingId,1,'1'  FROM MS_SurveySettings WHERE SettingName = 'TemplateId'



INSERT INTO TR_SurveySettings
(SurveyId,SettingId,CustomerId,Value)
SELECT 1159,SettingId,1,'mm-dd-yyyy' FROM MS_SurveySettings WHERE SettingName = 'DateTimeFormat'
UNION
SELECT 1159,SettingId,1,'2'  FROM MS_SurveySettings WHERE SettingName = 'TemplateId'