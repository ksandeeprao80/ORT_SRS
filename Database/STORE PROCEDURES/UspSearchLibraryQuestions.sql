IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchLibraryQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchLibraryQuestions]

GO
/*
--EXEC UspSearchLibraryQuestions @LibId='160',@CategoryId='202',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
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
CREATE PROCEDURE DBO.UspSearchLibraryQuestions
	@LibId INT,
	@CategoryId INT = NULL,
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
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SA','GU','SU'))
	BEGIN
		SELECT   
			TL.LibId, MLT.LibTypeId, MLT.TypeName, TL.CustomerId, TL.LibName, TQL.QuestionLibId, 
			TQL.QuestionId, TLC.CategoryName, TQL.QuestionLibName, TQL.IsActive, TQL.CreatedBy, 
			TQL.CreatedOn, TQL.ModifiedBy, TQL.ModifiedOn, TQL.CategoryId, TQL.QuestionTypeId, 
			TQL.QuestionText, 1 AS RetValue  
		FROM DBO.TR_QuestionLibrary TQL 
		INNER JOIN DBO.TR_Library TL 
			ON TQL.LibId = TL.LibId AND TQL.LibId = @LibId
			AND TL.IsActive = 1 AND TQL.IsActive = 1
			AND TQL.CategoryId = ISNULL(@CategoryId,TQL.CategoryId)
		INNER JOIN DBO.TR_LibraryCategory TLC
 			ON TL.LibId = TLC.LibId
 			AND TQL.CategoryId = TLC.CategoryId
		INNER JOIN @UserInfo UI
			ON TL.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TL.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
		INNER JOIN DBO.MS_LibraryType MLT 
			ON MLT.LibTypeId = TL.LibTypeId 
 	END
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END		

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END