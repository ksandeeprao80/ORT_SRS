--SELECT * FROM MS_QuestionSettings WHERE SettingName = 'HideNextButtonFor'

SET IDENTITY_INSERT MS_QuestionSettings ON

INSERT INTO MS_QuestionSettings
(SettingId, SettingName)
SELECT 24,'HideNextButtonFor'

SET IDENTITY_INSERT MS_QuestionSettings OFF

GO

INSERT INTO TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, 24,''FROM TR_QuestionSettings
 
 