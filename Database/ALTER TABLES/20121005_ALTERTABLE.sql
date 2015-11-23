ALTER TABLE DBO.TR_GraphicFiles DROP CONSTRAINT FK_TR_GraphicFiles_TR_GraphicLibrary
GO
sp_RENAME 'TR_GraphicFiles.[GraphicLibId]' , 'LibId', 'COLUMN'
GO
ALTER TABLE DBO.TR_GraphicFiles ADD CONSTRAINT FK_TR_GraphicFiles_TR_Library FOREIGN KEY (LibId) REFERENCES DBO.TR_Library(LibId)
GO
ALTER TABLE DBO.TR_LibraryCategory ADD CategoryDescription VARCHAR(500)