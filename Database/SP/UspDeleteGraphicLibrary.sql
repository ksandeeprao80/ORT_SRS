IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteGraphicLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteGraphicLibrary]
GO

--EXEC UspDeleteGraphicLibrary 1 

CREATE PROCEDURE DBO.UspDeleteGraphicLibrary
	@GraphicLibId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	UPDATE DBO.TR_GraphicLibrary        
	SET IsActive = 0
	WHERE GraphicLibId = @GraphicLibId

	SELECT 1 AS RetValue, 'Successfully Graphic Library Deleted' AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

