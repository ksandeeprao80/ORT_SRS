ALTER TABLE TR_SurveyLibrary DROP CONSTRAINT FK_TR_Survey_Library_TR_Survey
GO
ALTER TABLE TR_SurveyLibrary ALTER COLUMN SurveyId INT NULL
GO
ALTER TABLE TR_MessageLibrary ALTER COLUMN TemplateName VARCHAR(1000)
GO
ALTER TABLE TR_FileLibrary ALTER COLUMN Category VARCHAR(150) NULL



