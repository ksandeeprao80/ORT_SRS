IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyLibraryCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyLibraryCategory]

GO
/*
--EXEC UspGetSurveyLibraryCategory NULL, 'survey',1,'<?xml version="1.0" encoding="utf-16"?>
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
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>1</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/
CREATE PROCEDURE DBO.UspGetSurveyLibraryCategory
	@LibId INT = NULL,
	@TypeName VARCHAR(100),
	@CustomerId INT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
	
	SELECT 
		TLC.CategoryId, TLC.CategoryName, TLC.LibId, TLC.CategoryDescription, 
		TLC.CreatedBy, TLC.CreatedOn, TLC.ModifiedBy, TLC.ModifiedOn
	FROM DBO.TR_LibraryCategory TLC 
	INNER JOIN DBO.TR_Library TL
		ON TLC.LibId = TL.LibId 
		AND TLC.LibId = ISNULL(@LibId,TLC.LibId) 
		AND TL.IsActive = 1
	INNER JOIN @UserInfo UI
		ON TL.CustomerId = CONVERT(INT,UI.CustomerId) 
	INNER JOIN DBO.MS_LibraryType MLT
		ON TL.LibTypeId = MLT.LibTypeId
		AND LTRIM(RTRIM(MLT.TypeName)) = LTRIM(RTRIM(@TypeName))

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


