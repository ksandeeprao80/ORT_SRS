ALTER TABLE DBO.TR_SurveyQuestions ADD PlayListId INT
GO
ALTER TABLE DBO.TR_Responses ADD SongId INT
GO
ALTER TABLE DBO.TR_SurveyAnswers ALTER COLUMN Answer VARCHAR(1000)