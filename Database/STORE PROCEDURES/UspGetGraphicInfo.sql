IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetGraphicInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetGraphicInfo]

GO
-- EXEC UspGetGraphicInfo 6
CREATE PROCEDURE DBO.UspGetGraphicInfo 
	@LibId INT = NULL 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TGF.GraphicFileId, TGF.LibId, TGF.CategoryId, ISNULL(TGF.GraphicFileName,'') AS GraphicFileName,
		ISNULL(TGF.Extension,'') AS Extension, ISNULL(TGF.FilePath,'') AS FilePath, TGF.CustomerId, 
		TGF.UploadedBy, TGF.UploadedDate
	FROM DBO.TR_GraphicFiles TGF
	WHERE TGF.LibId = ISNULL(@LibId,TGF.LibId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


