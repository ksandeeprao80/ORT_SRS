INSERT INTO DBO.MS_QuestionSettings
SELECT 'ForceResponse'
INSERT INTO DBO.MS_QuestionSettings 
SELECT 'HasSkipLogic' 
INSERT INTO DBO.MS_QuestionSettings
SELECT 'HasEmailTrigger' 
INSERT INTO DBO.MS_QuestionSettings
SELECT 'IsMTBQuestion' 
INSERT INTO DBO.MS_QuestionSettings
SELECT 'HasMedia' 
INSERT INTO DBO.MS_QuestionSettings
SELECT 'HasImage' 
INSERT INTO DBO.MS_QuestionSettings
SELECT 'PlayListId' 
INSERT INTO DBO.MS_QuestionSettings
SELECT 'GraphicLibId' 
INSERT INTO DBO.MS_QuestionSettings
SELECT 'SongFileLibId' 

GO

INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,1, CASE WHEN ForceResponse = 1 THEN 'True' ELSE 'False' END FROM TR_SurveyQuestions
INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,2, CASE WHEN HasSkipLogic = 1 THEN 'True' ELSE 'False'  END FROM TR_SurveyQuestions
INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,3, CASE WHEN HasEmailTrigger = 1 THEN 'True' ELSE 'False' END  FROM TR_SurveyQuestions
INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,4, CASE WHEN HasMedia = 1 THEN 'True' ELSE 'False' END FROM TR_SurveyQuestions
INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,5, CASE WHEN HasMedia = 1 THEN 'True' ELSE 'False'  END FROM TR_SurveyQuestions
INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,6, 'False' FROM TR_SurveyQuestions
INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,7, ISNULL(PlayListId,'') FROM TR_SurveyQuestions
INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,8, '' FROM TR_SurveyQuestions
INSERT INTO DBO.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT QuestionId,9, '' FROM TR_SurveyQuestions

GO

ALTER TABLE DBO.TR_SurveyQuestions DROP COLUMN ForceResponse
ALTER TABLE DBO.TR_SurveyQuestions DROP COLUMN HasSkipLogic
ALTER TABLE DBO.TR_SurveyQuestions DROP COLUMN HasEmailTrigger
ALTER TABLE DBO.TR_SurveyQuestions DROP COLUMN HasMedia
ALTER TABLE DBO.TR_SurveyQuestions DROP COLUMN PlayListId

GO

UPDATE TML
SET TML.CategoryId = TLC.CategoryId
FROM TR_MessageLibrary TML
INNER JOIN TR_LibraryCategory TLC
ON TML.LibId = TLC.LibId
WHERE TML.CategoryId IS NULL