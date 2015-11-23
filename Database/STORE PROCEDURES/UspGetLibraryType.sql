IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetLibraryType]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetLibraryType]

GO

-- EXEC UspGetLibraryType 3
-- EXEC UspGetLibraryType 
CREATE PROCEDURE DBO.UspGetLibraryType
	@LibTypeId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		LibTypeId, ISNULL(TypeName,'') AS TypeName, ISNULL(IsActive,0) AS IsActive
 	FROM DBO.MS_LibraryType WITH(NOLOCK)
	WHERE LibTypeId = ISNULL(@LibTypeId,LibTypeId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END