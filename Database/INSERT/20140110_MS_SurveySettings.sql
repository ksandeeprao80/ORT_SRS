SET IDENTITY_INSERT MS_SurveySettings ON

INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)
SELECT 78,'','AssociatedPanel','AssociatedPanel'

INSERT INTO DBO.TR_SurveySettings
(SurveyId,SettingId,CustomerId,Value)
SELECT DISTINCT SurveyId,78 AS SettingId,CustomerId,'' AS Value FROM TR_SurveySettings 

SET IDENTITY_INSERT MS_SurveySettings OFF


SET IDENTITY_INSERT MS_SurveySettings ON

INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)
SELECT 79,'','ReferFriendMessageId','ReferFriendMessageId'

INSERT INTO DBO.TR_SurveySettings
(SurveyId,SettingId,CustomerId,Value)
SELECT DISTINCT SurveyId,79 AS SettingId,CustomerId,'' AS Value FROM TR_SurveySettings 

SET IDENTITY_INSERT MS_SurveySettings OFF
 

