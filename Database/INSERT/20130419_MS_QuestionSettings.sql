
--SELECT * FROM MS_QuestionSettings WHERE SettingName = 'MtbQuestionId'

SET IDENTITY_INSERT MS_QuestionSettings ON

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 32,'MtbQuestionId'

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 32,'' FROM TR_QuestionSettings

SET IDENTITY_INSERT MS_QuestionSettings OFF
