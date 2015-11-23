BEGIN TRAN

	DECLARE @MaxLibId INT
	SELECT @MaxLibId = MAX(LibId)+1 FROM DBO.TR_Library
	
	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, 
		REPLACE(LibName,''''+'s End of Survey Messages','')+''''+'s Quota Full Message' AS LibName, 
		CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
	FROM TR_Library WHERE LibTypeId = 2
	AND LibName LIKE '%End of Survey Messages%'

	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, 
		REPLACE(LibName,''''+'s End of Survey Messages','')+''''+'s Disqualified Message' AS LibName, 
		CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
	FROM TR_Library WHERE LibTypeId = 2
	AND LibName LIKE '%End of Survey Messages%'
	 
	INSERT INTO DBO.TR_LibraryCategory
	(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		'ALL', LibId, 'ALL', CreatedBy, GETDATE(), CreatedBy, GETDATE()  
	FROM DBO.TR_Library	WHERE LibId >= @MaxLibId

COMMIT TRAN