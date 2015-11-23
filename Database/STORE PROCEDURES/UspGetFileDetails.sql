IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetFileDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetFileDetails]

GO
-- EXEC UspGetFileDetails 544
CREATE PROCEDURE DBO.UspGetFileDetails 
	@FileLibId INT = NULL 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TFL.FileLibId, TFL.LibId, TFL.FileLibName, TFL.[FileName], TFL.FileType, TL.CustomerId, 
		TFL.Category, TFL.CreatedBy, TFL.CreatedOn, TFL.ModifiedBy, TFL.ModifiedOn
	FROM DBO.TR_FileLibrary TFL
	INNER JOIN DBO.TR_Library TL
		ON TFL.LibId = TL.LibId
		AND TFL.FileLibId = ISNULL(@FileLibId,TFL.FileLibId)
		AND TFL.IsDeleted = 'N'

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
