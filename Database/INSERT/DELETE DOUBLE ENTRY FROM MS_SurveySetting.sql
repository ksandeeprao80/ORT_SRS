DELETE FROM TR_SurveySettings WHERE SettingId  IN (SELECT SettingId FROM MS_SurveySettings WHERE SettingName ='BTN_BACK' AND DisplayText = 'Allow back button')
DELETE FROM MS_SurveySettings WHERE SettingName ='BTN_BACK' AND DisplayText = 'Allow back button'

