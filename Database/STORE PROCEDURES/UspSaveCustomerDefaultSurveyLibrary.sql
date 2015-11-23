IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveCustomerDefaultSurveyLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveCustomerDefaultSurveyLibrary
GO

-- EXEC UspSaveCustomerDefaultSurveyLibrary 52
 
CREATE PROCEDURE DBO.UspSaveCustomerDefaultSurveyLibrary
	@CustomerId INT
	--,@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	--DECLARE @UserInfo TABLE
	--(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	--INSERT INTO @UserInfo
	--(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	--EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	DECLARE @LibId INT
	SET @LibId = 0

	INSERT INTO DBO.TR_Library
	(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 
		LibTypeId, 'Default', @CustomerId, 1, NULL, GETDATE(), NULL, GETDATE()
	FROM MS_LibraryType WHERE TypeName = 'SURVEY'

	SET @LibId = @@IDENTITY

	INSERT INTO DBO.TR_LibraryCategory
	(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	SELECT 'Weekly Chart Music Test', @LibId, 'Weekly Chart Music Test', NULL, GETDATE(), NULL, GETDATE() UNION
	SELECT 'Library Music Test', @LibId, 'Library Music Test', NULL, GETDATE(), NULL, GETDATE()  UNION
	SELECT 'Perceptual Study', @LibId, 'Perceptual Study', NULL, GETDATE(), NULL, GETDATE()

	SELECT CASE WHEN ISNULL(@LibId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@LibId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
			@LibId AS LibraryId
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

 