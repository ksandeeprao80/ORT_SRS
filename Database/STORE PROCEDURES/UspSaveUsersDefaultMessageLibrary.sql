IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveUsersDefaultMessageLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveUsersDefaultMessageLibrary
GO
/*
EXEC UspSaveUsersDefaultMessageLibrary 2,@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>2</UserId>
  <UserName>Johnny Dias</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>True</IsActive>
    </Customer>
    <UserRole>
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>2</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/

CREATE PROCEDURE DBO.UspSaveUsersDefaultMessageLibrary
	@UserId INT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	DECLARE @LibId1 INT,@LibId2 INT, @LibId3 INT, @LibId4 INT, @LibId5 INT, @LibId6 INT
	 
	DECLARE @LoginId VARCHAR(30), @CustomerId INT

	--SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
	SELECT @LoginId = LoginId, @CustomerId = CustomerId FROM MS_Users WHERE UserId = @UserId

	---Start Of Library Insert---------------------------------------------------------------------
	-- General Messages
	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, @LoginId+''''+'s General Messages', @CustomerId, 1, @UserId, GETDATE(), @UserId, GETDATE()  
	FROM MS_LibraryType WHERE TypeName = 'MESSAGE'

	SET @LibId1 = @@IDENTITY
	
	-- Invite Messages
	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, @LoginId+''''+'s Invite Messages', @CustomerId, 1, @UserId, GETDATE(), @UserId, GETDATE()  
	FROM MS_LibraryType WHERE TypeName = 'MESSAGE'

	SET @LibId2 = @@IDENTITY

	-- Reminder Messages
	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, @LoginId+''''+'s Reminder Messages', @CustomerId, 1, @UserId, GETDATE(), @UserId, GETDATE()  
	FROM MS_LibraryType WHERE TypeName = 'MESSAGE'

	SET @LibId3 = @@IDENTITY
	
	-- End of Survey Messages
	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, @LoginId+''''+'s End of Survey Messages', @CustomerId, 1, @UserId, GETDATE(), @UserId, GETDATE()  
	FROM MS_LibraryType WHERE TypeName = 'MESSAGE'

	SET @LibId4 = @@IDENTITY	
	
	-- Quota Full Message
	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, @LoginId+''''+'s Quota Full Message', @CustomerId, 1, @UserId, GETDATE(), @UserId, GETDATE()  
	FROM MS_LibraryType WHERE TypeName = 'MESSAGE'

	SET @LibId5 = @@IDENTITY	
	
	-- Disqualified Message
	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, @LoginId+''''+'s Disqualified Message', @CustomerId, 1, @UserId, GETDATE(), @UserId, GETDATE()  
	FROM MS_LibraryType WHERE TypeName = 'MESSAGE'

	SET @LibId6 = @@IDENTITY	
	
	---End Of Library Insert---------------------------------------------------------------------

	DECLARE @RowId INT
	
	INSERT INTO DBO.TR_LibraryCategory
	(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 'ALL', @LibId1, 'ALL', @UserId, GETDATE(), @UserId, GETDATE() UNION
	SELECT 'ALL', @LibId2, 'ALL', @UserId, GETDATE(), @UserId, GETDATE() UNION
	SELECT 'ALL', @LibId3, 'ALL', @UserId, GETDATE(), @UserId, GETDATE() UNION
	SELECT 'ALL', @LibId4, 'ALL', @UserId, GETDATE(), @UserId, GETDATE() UNION
	SELECT 'ALL', @LibId5, 'ALL', @UserId, GETDATE(), @UserId, GETDATE() UNION
	SELECT 'ALL', @LibId6, 'ALL', @UserId, GETDATE(), @UserId, GETDATE() 

	SET @RowId = @@ROWCOUNT
	
	SELECT CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		  CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

