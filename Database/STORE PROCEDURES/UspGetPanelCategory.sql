IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetPanelCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetPanelCategory]

GO

-- EXEC UspGetPanelCategory 1
CREATE PROCEDURE DBO.UspGetPanelCategory
	@LibId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		TPC.CategoryId, TPC.CategoryName, TPC.LibId
	FROM DBO.TR_PanelCategory TPC
	WHERE TPC.LibId = ISNULL(@LibId,TPC.LibId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

