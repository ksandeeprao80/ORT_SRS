IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetPlayList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetPlayList]

GO
/*
EXEC UspGetPlayList @PlayListId='',@PlayListName='',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>5</UserId>
  <UserName>Nilesh More</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <UserRole>
      <RoleId>2</RoleId>
      <RoleDesc>SRS Admin</RoleDesc>
      <Hierarchy>1</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/
CREATE PROCEDURE DBO.UspGetPlayList
	@PlayListId INT = NULL,
	@PlayListName VARCHAR(150) = NULL,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	IF @PlayListId = ''
	SET @PlayListId = NULL

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
	
	SELECT  
		MPL.PlayListId, MPL.PlayListName, MPL.IsActive, MPL.CustomerId, MPL.CreatedBy,
		MPL.CreatedOn, MPL.ModifiedBy, MPL.ModifiedOn
	FROM DBO.MS_PlayList MPL
	--LEFT OUTER JOIN @UserInfo UI
	INNER JOIN @UserInfo UI
		ON MPL.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN MPL.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
	WHERE MPL.PlayListId = ISNULL(@PlayListId,MPL.PlayListId)
		AND MPL.PlayListName LIKE '%'+ISNULL(@PlayListName,MPL.PlayListName)+'%'
		AND MPL.IsActive = 1

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END