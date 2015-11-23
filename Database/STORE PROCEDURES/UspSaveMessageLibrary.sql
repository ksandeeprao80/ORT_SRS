IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveMessageLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveMessageLibrary
GO
/*
EXEC UspSaveMessageLibrary '<?xml version="1.0" encoding="utf-16"?>
<Library>
  <LibraryId>undefined</LibraryId>
  <LibType>Message</LibType>
  <LibraryName>Test Lib</LibraryName>
  <Customer>
    <CustomerId>1</CustomerId>
    <IsActive>false</IsActive>
  </Customer>
</Library>'
*/

CREATE PROCEDURE DBO.UspSaveMessageLibrary
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
	
	DECLARE @CreatedBy INT, @CustomerId INT
	SELECT @CreatedBy = CONVERT(INT,UserId) FROM @UserInfo
	SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
	
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
		INNER JOIN 
		(
			SELECT
				 MLT.LibTypeId, ML.LibraryName, ML.CustomerId
			FROM #MessageLibrary ML
			INNER JOIN DBO.MS_LibraryType MLT
			ON LTRIM(RTRIM(ML.LibType)) = LTRIM(RTRIM(MLT.TypeName))
		) ML 
			ON LTRIM(RTRIM(TL.LibName)) = LTRIM(RTRIM(ML.LibraryName))
			AND TL.LibTypeId = ML.LibTypeId
			AND TL.CustomerId = CONVERT(INT,ML.CustomerId)
	)
	BEGIN
		SELECT 0 AS RetValue, 'Library Already Exist In The System' AS Remark
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
				MLT.LibTypeId, LTRIM(RTRIM(ML.LibraryName)), CONVERT(INT,ML.CustomerId), 1 AS IsActive,
				@CreatedBy, GETDATE(), @CreatedBy, GETDATE()
			FROM #MessageLibrary ML
			INNER JOIN DBO.MS_LibraryType MLT
				ON LTRIM(RTRIM(ML.LibType)) = LTRIM(RTRIM(MLT.TypeName))
			WHERE LTRIM(RTRIM(ML.LibraryId)) = 'undefined'

			SET @LibraryId = @@IDENTITY

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
