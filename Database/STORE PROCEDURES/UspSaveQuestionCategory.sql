IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveQuestionCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveQuestionCategory
GO 
/*
EXEC UspSaveQuestionCategory '<?xml version="1.0" encoding="utf-16"?>
<QuestionLibrary>
	<LibraryId>5</LibraryId>
	<LibType>Question</LibType>
	<LibraryName>QUESTION</LibraryName>
	<QuestionLibraryId>37</QuestionLibraryId>
	<QuestionInLibrary />
	<QuestionLibraryName>Golden Era Songs</QuestionLibraryName>
	<Category>
		<CategoryId>UNDEFINE</CategoryId>
		<CategoryName>1960 Test Category</CategoryName>
	</Category>
</QuestionLibrary>'
*/

CREATE PROCEDURE DBO.UspSaveQuestionCategory
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

	CREATE TABLE #QuestionCategory
	(
		LibraryId VARCHAR(20), LibType VARCHAR(30), LibraryName VARCHAR(150), QuestionLibraryId VARCHAR(20),
		QuestionLibraryName VARCHAR(150), CustomerId VARCHAR(20), IsActive VARCHAR(20), CategoryId VARCHAR(20),
		CategoryName VARCHAR(100)
	)
	INSERT INTO #QuestionCategory
	(
		LibraryId, LibType, LibraryName, QuestionLibraryId, QuestionLibraryName, 
		CustomerId, IsActive, CategoryId, CategoryName
	)
	SELECT
		-- MessageLibrary
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibraryId,
		Parent.Elm.value('(LibType)[1]','VARCHAR(30)') AS LibType,
		Parent.Elm.value('(LibraryName)[1]','VARCHAR(150)') AS LibraryName,
		Parent.Elm.value('(QuestionLibraryId)[1]','VARCHAR(20)') AS QuestionLibraryId,
		Parent.Elm.value('(QuestionLibraryName)[1]','VARCHAR(150)') AS QuestionLibraryName,
		-- Customer
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive,
		-- Category
		Child1.Elm.value('(Category)[1]','VARCHAR(20)') AS CategoryId,
		Child1.Elm.value('(CategoryName)[1]','VARCHAR(100)') AS CategoryName
	--INTO #QuestionCategory
	FROM @input.nodes('/QuestionLibrary') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Category') AS Child1(Elm)

	DECLARE @CategoryId INT
	SET @CategoryId = 0
	
	IF EXISTS
	(
		SELECT 1 FROM #QuestionCategory QC INNER JOIN DBO.TR_LibraryCategory TLC
		ON QC.QuestionLibraryId = TLC.LibId AND LTRIM(RTRIM(QC.CategoryName)) = LTRIM(RTRIM(TLC.CategoryName))
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
				LTRIM(RTRIM(CategoryName)), CONVERT(INT,QuestionLibraryId), '', @CreatedBy, GETDATE(), @CreatedBy, GETDATE() 
			FROM #QuestionCategory  
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
				INNER JOIN #QuestionCategory QC
					ON TL.LibId = CONVERT(INT,QC.QuestionLibraryId)
				WHERE TL.CreatedBy = @CreatedBy 		
			)
			BEGIN
				INSERT INTO DBO.TR_LibraryCategory 
				(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				SELECT 
					LTRIM(RTRIM(CategoryName)), CONVERT(INT,QuestionLibraryId), '', @CreatedBy, GETDATE(), @CreatedBy, GETDATE() 
				FROM #QuestionCategory 
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
	
	DROP TABLE #QuestionCategory

	COMMIT TRAN

END TRY

BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



