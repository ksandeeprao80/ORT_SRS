IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSurveyCategory]
GO
/*
EXEC UspSaveSurveyCategory '<?xml version="1.0" encoding="utf-16"?>
<SurveyLibrary>
	<LibraryId>1</LibraryId>
	<LibType>Survey</LibType>
	<LibraryName>SURVEY</LibraryName>
	<Customer>
		<CustomerId>1</CustomerId>
		<IsActive>false</IsActive>
	</Customer>
	<SurveyLibraryId>20</SurveyLibraryId>
	<SurveyInLibrary />
	<SurveyLibraryName>Attention Filter</SurveyLibraryName>
	<Category>
		<CategoryId>undefine</CategoryId>
		<CategoryName>Test Survey Category</CategoryName>
	</Category>
</SurveyLibrary>'
*/
CREATE PROCEDURE DBO.UspSaveSurveyCategory
	@XmlData AS NTEXT,
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
	
	DECLARE @CreatedBy INT
	SELECT @CreatedBy = CONVERT(INT,UserId) FROM @UserInfo

	DECLARE @input XML = @XmlData
	-------------------------------------------------------------------------------------
	CREATE TABLE #SurveyLibrary
	(
		LibraryId VARCHAR(20), LibType VARCHAR(30), LibraryName VARCHAR(100), SurveyLibraryId VARCHAR(20), SurveyInLibrary VARCHAR(150), 
		SurveyLibraryName VARCHAR(150), CustomerId VARCHAR(20), IsActive VARCHAR(20), CategoryId VARCHAR(20), CategoryName  VARCHAR(150)
	)
	INSERT INTO #SurveyLibrary
	(
		LibraryId, LibType, LibraryName, SurveyLibraryId, SurveyInLibrary, SurveyLibraryName, 
		CustomerId, IsActive, CategoryId, CategoryName 
	)
	SELECT
		-- SurveyLibrary
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibraryId,
		Parent.Elm.value('(LibType)[1]','VARCHAR(30)') AS LibType,
		Parent.Elm.value('(LibraryName)[1]','VARCHAR(100)') AS LibraryName,
		Parent.Elm.value('(SurveyLibraryId)[1]','VARCHAR(20)') AS SurveyLibraryId,
		Parent.Elm.value('(SurveyInLibrary)[1]','VARCHAR(150)') AS SurveyInLibrary,
		Parent.Elm.value('(SurveyLibraryName)[1]','VARCHAR(150)') AS SurveyLibraryName,
		-- Customers 
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive,
		-- Category
		Child1.Elm.value('(CategoryId)[1]','VARCHAR(20)') AS CategoryId,
		Child1.Elm.value('(CategoryName)[1]','VARCHAR(150)') AS CategoryName
	--INTO #SurveyLibrary
	FROM @input.nodes('/SurveyLibrary') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Category') AS Child1(Elm)

	DECLARE @CategoryId INT
	SET @CategoryId = 0
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_LibraryCategory TLC
		INNER JOIN #SurveyLibrary SL 
			ON TLC.LibId = CONVERT(INT,SL.SurveyLibraryId) 
			AND LTRIM(RTRIM(TLC.CategoryName)) = LTRIM(RTRIM(SL.CategoryName))
	)
	BEGIN
		SELECT 0 AS RetValue, 'Category Already Exist For the Library' AS Remark
	END
	ELSE
	BEGIN	
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END
	
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SA','GU'))
		BEGIN		
			INSERT INTO DBO.TR_LibraryCategory 
			(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			SELECT 
				LTRIM(RTRIM(CategoryName)), CONVERT(INT,SurveyLibraryId), '', @CreatedBy, GETDATE(), @CreatedBy, GETDATE() 
			FROM #SurveyLibrary  
			WHERE CategoryId = 'undefined' 

			SET @CategoryId = @@IDENTITY

			SELECT CASE WHEN @CategoryId = 0 THEN 0 ELSE 1 END AS RetValue, 
				CASE WHEN @CategoryId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
				 @CategoryId AS CategoryId
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
		BEGIN	
			IF EXISTS
			(
				SELECT 1 FROM dbo.TR_Library TL 
				INNER JOIN #SurveyLibrary SL
					ON TL.LibId = CONVERT(INT,SL.SurveyLibraryId)
				WHERE TL.CreatedBy = @CreatedBy 		
			)
			BEGIN
				INSERT INTO DBO.TR_LibraryCategory 
				(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				SELECT 
					LTRIM(RTRIM(CategoryName)), CONVERT(INT,SurveyLibraryId), '', @CreatedBy, GETDATE(), @CreatedBy, GETDATE() 
				FROM #SurveyLibrary 
				WHERE CategoryId = 'undefined' 

				SET @CategoryId = @@IDENTITY

				SELECT CASE WHEN @CategoryId = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN @CategoryId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
					@CategoryId AS CategoryId
			END
			ELSE
			BEGIN
				SELECT 0 AS RetValue, 'Access Denied' AS Remark
			END
		END
	END

	DROP TABLE #SurveyLibrary	

	COMMIT TRAN

END TRY

BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END


