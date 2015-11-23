--SELECT * FROM MS_QuestionSettings WHERE SettingName IN('DateInputStyle','DateInputformat')

SET IDENTITY_INSERT MS_QuestionSettings ON

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 28,'DateInputStyle'

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 29,'DateInputformat'

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 28,'' FROM TR_QuestionSettings

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 29,'' FROM TR_QuestionSettings

SET IDENTITY_INSERT MS_QuestionSettings OFF
-----2013/02/18----------------------------------------------------------------------
--SELECT * FROM MS_QuestionSettings WHERE SettingName IN('HasUrl','AssociatedUrl')
SET IDENTITY_INSERT MS_QuestionSettings ON

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 30,'HasUrl'

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 31,'AssociatedUrl'

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 30,'False' FROM TR_QuestionSettings

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 31,'' FROM TR_QuestionSettings

SET IDENTITY_INSERT MS_QuestionSettings OFF

