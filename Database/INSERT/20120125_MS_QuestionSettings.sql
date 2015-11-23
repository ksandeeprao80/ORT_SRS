SET IDENTITY_INSERT MS_QuestionSettings ON

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 21,'IsMediaFollowup'

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 22,'FollowupOption'

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 23,'FollowupQuestion'

SET IDENTITY_INSERT MS_QuestionSettings OFF

GO

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 21, 'False'  FROM TR_QuestionSettings

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 22, ''  FROM TR_QuestionSettings

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 23, ''  FROM TR_QuestionSettings
 