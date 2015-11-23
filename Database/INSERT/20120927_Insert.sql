DECLARE @SettingId INT
SET @SettingId = 0

INSERT INTO DBO.MS_SurveySettings
(SettingType,SettingName,DisplayText)
VALUES('','SurveyExpiredPage','Survey Expired Page')

SET @SettingId = @@IDENTITY

INSERT INTO DBO.TR_SurveySettings
SELECT DISTINCT SurveyId,@SettingId,CustomerId,'SurveyEngine1_Expired.html' FROM TR_SurveySettings

GO

INSERT INTO MS_QuestionTypes
(QuestionCode,QuestionName,SampleTemplate,BlankTemplate)
VALUES('NumberInput','Number Input','NumberInput.HTML','NumberInput.HTML')

GO

DECLARE @SettingId1 INT
SET @SettingId1 = 0

INSERT INTO DBO.MS_SurveySettings
(SettingType,SettingName,DisplayText)
VALUES('','SurveyRewardPage','Survey Reward Page')

SET @SettingId1 = @@IDENTITY

INSERT INTO DBO.TR_SurveySettings
SELECT DISTINCT SurveyId,@SettingId1,CustomerId,'surveyEngine1_Rewards.html' FROM TR_SurveySettings