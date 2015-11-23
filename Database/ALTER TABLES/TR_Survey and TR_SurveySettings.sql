ALTER TABLE DBO.TR_Survey ADD CategoryId INT, LanguageId INT
GO
ALTER TABLE TR_SurveySettings DROP FK_TR_Survey_Settings_MS_APP_Settings