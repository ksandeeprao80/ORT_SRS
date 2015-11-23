UPDATE TR_Library SET IsActive = 0 where LibTypeId = 6
GO

IF NOT EXISTS(SELECT 1 FROM TR_Library WHERE LibName = 'Default' AND LibTypeId = 6)
BEGIN
	INSERT INTO TR_Library(LibTypeId,LibName,CustomerId,IsActive,CreatedBy,CreatedOn)
	VALUES (6,'Default',1,1,1,GETDATE())
	
	DECLARE @LIBID INT
	
	SET @LIBID = @@IDENTITY
	
	INSERT INTO TR_LibraryCategory(CategoryName,LibId,CategoryDescription,CreatedBy,CreatedOn)
	VALUES('Weekly Chart Music Test',@LIBID,'Weekly Chart Music Test',1,GETDATE())
	
	DECLARE @CATID INT
	
	SET @CATID = @@IDENTITY
	
	UPDATE TR_Survey SET CategoryId = @CATID

	INSERT INTO TR_LibraryCategory(CategoryName,LibId,CategoryDescription,CreatedBy,CreatedOn)
	VALUES('Library Music Test',@LIBID,'Library Music Test',1,GETDATE())

	INSERT INTO TR_LibraryCategory(CategoryName,LibId,CategoryDescription,CreatedBy,CreatedOn)
	VALUES('Perceptual Study',@LIBID,'Perceptual Study',1,GETDATE())
	
	

END