ALTER TABLE DBO.TR_FileLibrary ADD IsDeleted VARCHAR(1) DEFAULT('N') 
GO
UPDATE DBO.TR_FileLibrary SET IsDeleted = 'N'