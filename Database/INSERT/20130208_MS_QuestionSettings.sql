--SELECT * FROM MS_QuestionSettings WHERE SettingName = 'HideNextButton'

SET IDENTITY_INSERT MS_QuestionSettings ON

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 25,'HideNextButton'

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 26,'ShowTitleOrArtist'

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 27,'ReplicateQuestion'

SET IDENTITY_INSERT MS_QuestionSettings OFF

GO

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 25,'False'FROM TR_QuestionSettings

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 26,'False'FROM TR_QuestionSettings

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 27,'False'FROM TR_QuestionSettings

 