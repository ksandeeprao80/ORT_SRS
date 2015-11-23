UPDATE TR_FileLibrary SET Category = NULL
GO
ALTER TABLE DBO.TR_FileLibrary ALTER COLUMN Category INT
GO
ALTER TABLE DBO.TR_MessageLibrary ADD CategoryId INT
