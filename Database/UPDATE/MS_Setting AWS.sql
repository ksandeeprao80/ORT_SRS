BEGIN TRAN

SELECT * INTO DBO.TR_SurveySettings_Backup_20121130 FROM TR_SurveySettings

UPDATE DBO.TR_SurveySettings_Backup_20121130 SET SettingId = 54 WHERE SettingId = 55

TRUNCATE TABLE DBO.TR_SurveySettings

UPDATE MS_SurveySettings SET SettingName = 'CheckQuota',DisplayText = 'CheckQuota' WHERE SettingId = 55

DELETE FROM MS_SurveySettings WHERE SettingId >= 56


SET IDENTITY_INSERT MS_SurveySettings ON 
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText) 
SELECT 54,'','InvitePassword','InvitePassword' 	
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)
SELECT 56,'','QuotaCount','QuotaCount'	
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)
SELECT 58,'','SendQuotaFullEmail','SendQuotaFullEmail'
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)	
SELECT 59,'','QuotaFullToEmailId','QuotaFullToEmailId'
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)	
SELECT 60,'','QuotaFullMessageId','QuotaFullMessageId'
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)	
SELECT 61,'','E_O_S_MESSAGE_TEXT','E_O_S_MESSAGE_TEXT'
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)	
SELECT 62,'','E_O_S_EMAIL_TEXT','E_O_S_EMAIL_TEXT'
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)	
SELECT 63,'','DateTimeFormat','DateTimeFormat'	
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)
SELECT 64,'','RewardApplicable','RewardApplicable'
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)	
SELECT 65,'','VerifySkipLogic','VerifySkipLogic	'
INSERT INTO MS_SurveySettings
(SettingId,SettingType,SettingName,DisplayText)
SELECT 66,'','TemplateId','TemplateId'	

SET IDENTITY_INSERT MS_SurveySettings OFF 

INSERT INTO TR_SurveySettings
(SurveyId,SettingId,CustomerId,Value)
SELECT SurveyId,SettingId,CustomerId,Value FROM DBO.TR_SurveySettings_Backup_20121130


COMMIT TRAN