IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveMessageLibraryWithCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveMessageLibraryWithCategory
GO
/*
EXEC UspSaveMessageLibraryWithCategory '<?xml version="1.0" encoding="utf-16"?>
<Library>
  <LibraryId>undefined</LibraryId>
  <LibType></LibType>
  <LibraryName>Insert Default Category1</LibraryName>
  <Customer>
    <CustomerId>1</CustomerId>
    <IsActive>false</IsActive>
  </Customer>
</Library>',
@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
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

CREATE PROCEDURE DBO.UspSaveMessageLibraryWithCategory
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
	
	DECLARE @CreatedBy INT, @CustomerId INT, @CreatedDate DATETIME
	SELECT @CreatedBy = CONVERT(INT,UserId) FROM @UserInfo
	SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
	SELECT @CreatedDate = GETDATE()
	
	DECLARE @input XML = @XmlData
	-----------------------------------------------------------------------------------

	CREATE TABLE #MessageLibrary
	(
		LibraryId VARCHAR(20), LibType VARCHAR(30), LibraryName VARCHAR(150),
		CustomerId VARCHAR(20), IsActive VARCHAR(20)
	)
	INSERT INTO #MessageLibrary
	(
		LibraryId, LibType, LibraryName, CustomerId, IsActive
	)
	SELECT
		-- MessageLibrary
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibraryId,
		Parent.Elm.value('(LibType)[1]','VARCHAR(30)') AS LibType,
		Parent.Elm.value('(LibraryName)[1]','VARCHAR(150)') AS LibraryName,
		-- Customer
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive
	--INTO #MessageLibrary
	FROM @input.nodes('/Library') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_Library TL 
		INNER JOIN #MessageLibrary ML
			ON LTRIM(RTRIM(TL.LibName)) = LTRIM(RTRIM(ML.LibraryName))
			AND TL.CustomerId = CONVERT(INT,ML.CustomerId)
		WHERE TL.LibTypeId = 2 -- 'Message Type'
	)
	BEGIN
		SELECT 0 AS RetValue, 'Library Already Exist In The System'
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SA','GU','SU'))
		BEGIN
			DECLARE @LibraryId INT
			SET @LibraryId = 0

			-- New Library insert query
			INSERT INTO DBO.TR_Library
			(
				LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
			)
			SELECT 
				2 AS LibTypeId, LTRIM(RTRIM(ML.LibraryName)), CONVERT(INT,ML.CustomerId), 1 AS IsActive,
				@CreatedBy, @CreatedDate, @CreatedBy, @CreatedDate
			FROM #MessageLibrary ML
			WHERE LTRIM(RTRIM(ML.LibraryId)) = 'undefined'

			SET @LibraryId = @@IDENTITY

			INSERT INTO DBO.TR_LibraryCategory
			(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn)
			SELECT 'Invite Messages', @LibraryId, 'Invite Messages', @CreatedBy, @CreatedDate UNION
			SELECT 'Reminder Messages', @LibraryId, 'Reminder Messages', @CreatedBy, @CreatedDate UNION
			SELECT 'General Messages', @LibraryId, 'General Messages', @CreatedBy, @CreatedDate UNION
			SELECT 'End of Survey Messages', @LibraryId, 'End of Survey Messages', @CreatedBy, @CreatedDate 
			
			SELECT CASE WHEN ISNULL(@LibraryId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
				CASE WHEN ISNULL(@LibraryId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
				ISNULL(@LibraryId,0) AS LibraryId
		END
		ELSE
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END
	END
	
	DROP TABLE #MessageLibrary

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
