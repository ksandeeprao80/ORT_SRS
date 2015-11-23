IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchLibraryGraphic]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchLibraryGraphic]

GO
--EXEC UspSearchLibraryGraphic 12,3
 
CREATE PROCEDURE DBO.UspSearchLibraryGraphic
	@LibId INT,
	@CategoryId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT   
		TL.LibId, MLT.LibTypeId, MLT.TypeName, TL.CustomerId, TL.LibName, TSL.GraphicLibId, 
		TSL.GraphicLibName, TGC.CategoryId, TGC.CategoryName, TGC.[FileName], TGC.FileType,
		TSL.CreatedBy, TSL.CreatedOn, ISNULL(TSL.ModifiedBy,'') AS ModifiedBy, 
		ISNULL(TSL.ModifiedOn,'') AS ModifiedOn
	FROM DBO.TR_GraphicLibrary TSL 
	INNER JOIN DBO.TR_Library TL 
		ON TSL.LibId = TL.LibId
		AND TSL.LibId = @LibId
		AND TL.IsActive = 1
	INNER JOIN DBO.MS_LibraryType MLT 
		ON MLT.LibTypeId = TL.LibTypeId 
	INNER JOIN DBO.TR_GraphicCategory TGC
		ON TSL.GraphicLibId = TGC.GraphicLibId
		AND TGC.CategoryId = ISNULL(@CategoryId,TGC.CategoryId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END