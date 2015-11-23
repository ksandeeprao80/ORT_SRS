INSERT INTO DBO.MS_QuestionTypes
(QuestionCode,QuestionName,SampleTemplate,BlankTemplate)
SELECT 'EndOfBlock','EndOfBlock','EndOfBlock.HTML','EndOfBlock.HTML'

GO

INSERT INTO MS_SurveySettings
(SettingType,SettingName,DisplayText)
SELECT '','SurveyEndofBlockPage','surveyEngine1_EndOfBlock'


