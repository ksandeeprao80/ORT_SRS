ALTER TABLE DBO.MS_PlayList ADD CustomerId INT,CreatedBy INT, CreatedOn DATETIME, ModifiedBy INT, ModifiedOn DATETIME
GO
ALTER TABLE DBO.TR_Library ADD CreatedBy INT, CreatedOn DATETIME, ModifiedBy INT, ModifiedOn DATETIME
GO
ALTER TABLE DBO.TR_LibraryCategory ADD CreatedBy INT, CreatedOn DATETIME, ModifiedBy INT, ModifiedOn DATETIME
GO
ALTER TABLE DBO.TR_FileLibrary ADD CreatedBy INT, CreatedOn DATETIME, ModifiedBy INT, ModifiedOn DATETIME
GO
ALTER TABLE DBO.TR_MessageLibrary ADD CreatedBy INT, CreatedOn DATETIME, ModifiedBy INT, ModifiedOn DATETIME
GO
ALTER TABLE DBO.TR_QuestionLibrary ADD CreatedBy INT, CreatedOn DATETIME, ModifiedBy INT, ModifiedOn DATETIME
GO
ALTER TABLE DBO.TR_SurveyLibrary ADD CreatedBy INT, CreatedOn DATETIME, ModifiedBy INT, ModifiedOn DATETIME

