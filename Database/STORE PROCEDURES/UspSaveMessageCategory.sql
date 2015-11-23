IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveMessageCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveMessageCategory
GO 
/*
EXEC UspSaveMessageCategory '<?xml version="1.0" encoding="utf-16"?>
<MessageLibrary>
	<LibraryId>6</LibraryId>
	<LibType>Message</LibType>
	<LibraryName>MESSAGE</LibraryName>
	<Customer>
		<CustomerId>1</CustomerId>
		<IsActive>false</IsActive>
	</Customer>
	<MessageLibraryId>undefined</MessageLibraryId>
	<MailType>Invite</MailType>
	<MessageDescription>Sending Test Message Details.</MessageDescription>
	<MessageText>TestMessage</MessageText>
	<Category>
		<CategoryId>undefined</CategoryId>
		<CategoryName>Test Category</CategoryName>
	</Category>
</MessageLibrary>'
*/
CREATE PROCEDURE DBO.UspSaveMessageCategory
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

	CREATE TABLE #MessageCategory
	(
		LibraryId VARCHAR(20), LibType VARCHAR(30), LibraryName VARCHAR(150), MessageLibraryId VARCHAR(20),
		MailType VARCHAR(100), MessageDescription VARCHAR(150), MessageText VARCHAR(1000), CustomerId VARCHAR(20),
		IsActive VARCHAR(20), CategoryId VARCHAR(20), CategoryName VARCHAR(100)
	)
	INSERT INTO #MessageCategory
	(
		LibraryId, LibType, LibraryName, MessageLibraryId, MailType, MessageDescription, 
		MessageText, CustomerId, IsActive, CategoryId, CategoryName
	)	
	SELECT
		-- MessageLibrary
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibraryId,
		Parent.Elm.value('(LibType)[1]','VARCHAR(30)') AS LibType,
		Parent.Elm.value('(LibraryName)[1]','VARCHAR(150)') AS LibraryName,
		Parent.Elm.value('(MessageLibraryId)[1]','VARCHAR(20)') AS MessageLibraryId,
		Parent.Elm.value('(MailType)[1]','VARCHAR(100)') AS MailType,
		Parent.Elm.value('(MessageDescription)[1]','VARCHAR(150)') AS MessageDescription,
		Parent.Elm.value('(MessageText)[1]','VARCHAR(1000)') AS MessageText,
		-- Customer
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive,
		-- Category
		Child1.Elm.value('(Category)[1]','VARCHAR(20)') AS CategoryId,
		Child1.Elm.value('(CategoryName)[1]','VARCHAR(100)') AS CategoryName
	--INTO #MessageCategory
	FROM @input.nodes('/MessageLibrary') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Category') AS Child1(Elm)

	DECLARE @CategoryId INT
	SET @CategoryId = 0
		
	IF EXISTS
	(
		SELECT 1 FROM #MessageCategory MC INNER JOIN DBO.TR_LibraryCategory TLC
		ON MC.MessageLibraryId = TLC.LibId AND LTRIM(RTRIM(MC.CategoryName)) = LTRIM(RTRIM(TLC.CategoryName))
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
				LTRIM(RTRIM(MC.CategoryName)), CONVERT(INT,MC.MessageLibraryId), '', @CreatedBy, GETDATE(), @CreatedBy, GETDATE() 
			FROM #MessageCategory MC
			WHERE MC.CategoryId = 'undefined' 

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
				INNER JOIN #MessageCategory MC
					ON TL.LibId = CONVERT(INT,MC.MessageLibraryId)
				WHERE TL.CreatedBy = @CreatedBy 		
			)
			BEGIN
				INSERT INTO DBO.TR_LibraryCategory 
				(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				SELECT 
					LTRIM(RTRIM(MC.CategoryName)), CONVERT(INT,MC.MessageLibraryId), '', @CreatedBy, GETDATE(), @CreatedBy, GETDATE() 
				FROM #MessageCategory MC
				WHERE MC.CategoryId = 'undefined' 

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
	 
	DROP TABLE #MessageCategory
				
	COMMIT TRAN

END TRY

BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



