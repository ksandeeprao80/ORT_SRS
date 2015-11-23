IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetGraphicDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetGraphicDetails]

GO
-- EXEC UspGetGraphicDetails 15
CREATE PROCEDURE DBO.UspGetGraphicDetails 
	@GraphicFileId INT = NULL 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TGF.GraphicFileId, TGF.LibId, TGF.CategoryId, ISNULL(TGF.GraphicFileName,'') AS GraphicFileName,
		ISNULL(TGF.Extension,'') AS Extension, ISNULL(TGF.FilePath,'') AS FilePath, TGF.CustomerId, 
		TGF.UploadedBy, TGF.UploadedDate, TL.CustomerId
	FROM DBO.TR_GraphicFiles TGF
	INNER JOIN DBO.TR_Library TL
		ON TGF.LibId = TL.LibId
	WHERE TGF.GraphicFileId = ISNULL(@GraphicFileId,TGF.GraphicFileId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END





