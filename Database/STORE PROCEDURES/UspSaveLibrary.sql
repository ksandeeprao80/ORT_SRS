IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveLibrary]

GO
-- EXEC UspSaveLibrary 
CREATE PROCEDURE DBO.UspSaveLibrary
	@LibId INT,
	@LibTypeId INT,
	@LibName VARCHAR(150),
	@CustomerId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_Library WITH(NOLOCK)
		WHERE LibTypeId = @LibTypeId
			AND LibName = @LibName 
			AND CustomerId = @CustomerId
	) 
	BEGIN
		SELECT 1 AS RetValue, 'Already Exist In The System' AS Remark, 0 AS LibId
	END
	ELSE
	BEGIN
		DECLARE @LibraryId INT
		SET @LibraryId = 0
	 
		INSERT INTO DBO.TR_Library
		(LibTypeId, LibName, CustomerId, IsActive)
		VALUES
		(@LibTypeId, @LibName, @CustomerId, 1)
	
		SET @LibraryId = @@IDENTITY
	
		SELECT CASE WHEN @LibraryId = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN @LibraryId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
			@LibraryId AS LibId
	END
	
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark, 0 AS LibId
END CATCH 

SET NOCOUNT OFF
END