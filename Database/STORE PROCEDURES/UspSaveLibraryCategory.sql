IF EXISTS
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveLibraryCategory]')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1
)
DROP PROCEDURE DBO.UspSaveLibraryCategory

GO
/*
EXEC UspSaveLibraryCategory '<?xml version="1.0" encoding="utf-16"?>
<LibraryCategory>
	<CategoryId>undefined</CategoryId>
	<CategoryName>New Cat testing</CategoryName>
	<CategoryDescription />
	<LibraryId>6</LibraryId>
</LibraryCategory>'
*/

CREATE PROCEDURE DBO.UspSaveLibraryCategory
	@XmlData NTEXT,
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
	--------------------------------------------------------------------------------

	CREATE TABLE #LibraryCategory
	(
		CategoryId VARCHAR(20), CategoryName VARCHAR(100), CategoryDescription VARCHAR(500), 
		LibId VARCHAR(20) 
	)
	INSERT INTO #LibraryCategory
	(
		CategoryId, CategoryName, CategoryDescription, LibId 
	)	
	SELECT
		-- LibraryCategory
		Parent.Elm.value('(CategoryId)[1]','VARCHAR(20)') AS CategoryId,
		Parent.Elm.value('(CategoryName)[1]','VARCHAR(100)') AS CategoryName,
		Parent.Elm.value('(CategoryDescription)[1]','VARCHAR(500)') AS CategoryDescription,
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibId
	--INTO #LibraryCategory
	FROM @input.nodes('/LibraryCategory') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('CreatedBy') AS Child(Elm)
		
	DECLARE @CategoryId INT
	SET @CategoryId = 0
			
	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_LibraryCategory TLC
		INNER JOIN #LibraryCategory LC
			ON TLC.LibId = CONVERT(INT,LC.LibId) 
			AND LTRIM(RTRIM(TLC.CategoryName)) = LTRIM(RTRIM(LC.CategoryName))
		WHERE LC.CategoryId = 'undefined'
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

		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
		BEGIN	
			INSERT INTO DBO.TR_LibraryCategory 
			(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			SELECT 
				LTRIM(RTRIM(CategoryName)), CONVERT(INT,LibId), LTRIM(RTRIM(CategoryDescription)),
				@CreatedBy, GETDATE(), @CreatedBy, GETDATE()  
			FROM #LibraryCategory
			WHERE CategoryId = 'undefined' 

			SET @CategoryId = @@IDENTITY

			SELECT CASE WHEN @CategoryId = 0 THEN 0 ELSE 1 END AS RetValue, 
				CASE WHEN @CategoryId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
				@CategoryId AS NewCategoryId 	
		END		
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','GU'))
		BEGIN	
			IF EXISTS
			(
				SELECT 1 FROM dbo.TR_Library TL 
				INNER JOIN #LibraryCategory LC
					ON TL.LibId = CONVERT(INT,LC.LibId)
				WHERE TL.CreatedBy = @CreatedBy 		
			)
			BEGIN
				INSERT INTO DBO.TR_LibraryCategory 
				(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				SELECT 
					LTRIM(RTRIM(LC.CategoryName)), CONVERT(INT,LC.LibId), LTRIM(RTRIM(LC.CategoryDescription)),
					@CreatedBy, GETDATE(), @CreatedBy, GETDATE()  
				FROM #LibraryCategory LC
				WHERE LC.CategoryId = 'undefined' 

				SET @CategoryId = @@IDENTITY

				SELECT CASE WHEN @CategoryId = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN @CategoryId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
					@CategoryId AS NewCategoryId 
			END
			ELSE
			BEGIN
				SELECT 0 AS RetValue, 'Access Denied' AS Remark
			END	
		END		
	END
	
	DROP TABLE #LibraryCategory
	
	COMMIT TRAN

END TRY

BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
