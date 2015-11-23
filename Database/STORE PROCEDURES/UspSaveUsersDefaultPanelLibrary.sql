IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveUsersDefaultPanelLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveUsersDefaultPanelLibrary
GO
/*
--select * from ms_uSERS
EXEC UspSaveUsersDefaultPanelLibrary 2,@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
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

CREATE PROCEDURE DBO.UspSaveUsersDefaultPanelLibrary
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

	DECLARE @LibId INT, @LoginId VARCHAR(30), @CustomerId INT

	--SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
	SELECT @LoginId = LoginId, @CustomerId = CustomerId FROM MS_Users WHERE UserId = @UserId

	SET @LibId = 0
	
	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, @LoginId+''''+'s Panel Library', @CustomerId, 1, @UserId, GETDATE(), @UserId, GETDATE()  
	FROM MS_LibraryType WHERE TypeName = 'PANEL'

	SET @LibId = @@IDENTITY
	
	DECLARE @CategoryId INT
	SET @CategoryId = 0
		
	INSERT INTO DBO.TR_PanelCategory
	(CategoryName, LibId)
	SELECT 'ALL', @LibId

	SET @CategoryId = @@IDENTITY
	
	SELECT CASE WHEN ISNULL(@CategoryId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@CategoryId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

 