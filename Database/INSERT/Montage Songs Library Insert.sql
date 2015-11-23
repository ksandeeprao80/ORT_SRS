	DECLARE @UserId INT
	DECLARE @LibId INT
	DECLARE @CategoryId INT

	SELECT @UserId = CreatedBy FROM MS_Customers WHERE CustomerId = 1

	-- TR_Library
	INSERT INTO DBO.TR_Library
	(LibTypeId,LibName,CustomerId,IsActive,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES(3,'Montage Of Song Clips',1,1,@UserId,GETDATE(),@UserId,GETDATE())
	SET @LibId = @@IDENTITY

	-- TR_LibraryCategory
	INSERT INTO DBO.TR_LibraryCategory
	(CategoryName, LibId,CategoryDescription,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	VALUES('Seattle KLCK – Survey December',@LibId,'Montage',@UserId,GETDATE(),@UserId,GETDATE())
	SET @CategoryId = @@IDENTITY

	-- TR_FileLibrary
	INSERT INTO DBO.TR_FileLibrary
	(LIBID,FileLibName,Category,[FileName],FileType,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
	SELECT @LibId,'Montage Of Song Clips',@CategoryId,'0312 POP CHR -1 montage.mp3',1,@UserId,GETDATE(),@UserId,GETDATE() UNION
	SELECT @LibId,'Montage Of Song Clips',@CategoryId,'0312 QM Montage Version #1.mp3',1,@UserId,GETDATE(),@UserId,GETDATE() UNION
	SELECT @LibId,'Montage Of Song Clips',@CategoryId,'0312 RHYTHM CHR -2 montage.mp3',1,@UserId,GETDATE(),@UserId,GETDATE() UNION
	SELECT @LibId,'Montage Of Song Clips',@CategoryId,'0812 KLCK Pod.mp3',1,@UserId,GETDATE(),@UserId,GETDATE() 
 
	-- TR_SoundClipInfo
	INSERT INTO DBO.TR_SoundClipInfo
	(FileLibId,Title,Artist,FileLibYear,FilePath)
	SELECT Filelibid,'Pop CHR','MJ','2012','' FROM DBO.TR_FileLibrary WHERE LibId = @LibId AND Category = @CategoryId
	AND [FileName] = '0312 POP CHR -1 montage.mp3'
	
	INSERT INTO DBO.TR_SoundClipInfo
	(FileLibId,Title,Artist,FileLibYear,FilePath)
	SELECT Filelibid,'QM Montage','MJ','2012','' 
	FROM DBO.TR_FileLibrary WHERE LibId = @LibId AND Category = @CategoryId
	AND [FileName] = '0312 QM Montage Version #1.mp3'
	
	INSERT INTO DBO.TR_SoundClipInfo
	(FileLibId,Title,Artist,FileLibYear,FilePath)
	SELECT Filelibid,'Rhytham','MJ','2012','' 
	FROM DBO.TR_FileLibrary WHERE LibId = @LibId AND Category = @CategoryId
	AND [FileName] = '0312 RHYTHM CHR -2 montage.mp3'
	
	INSERT INTO DBO.TR_SoundClipInfo
	(FileLibId,Title,Artist,FileLibYear,FilePath)
	SELECT Filelibid,'KLCK POD','MJ','2012','' 
	FROM DBO.TR_FileLibrary WHERE LibId = @LibId AND Category = @CategoryId
	AND [FileName] = '0812 KLCK Pod.mp3'
	
	 

 

