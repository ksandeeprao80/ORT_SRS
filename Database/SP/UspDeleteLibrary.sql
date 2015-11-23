IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteLibrary]
GO

--EXEC UspDeleteLibrary 

CREATE PROCEDURE DBO.UspDeleteLibrary
	@LibraryId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	UPDATE DBO.TR_Library 
	SET IsActive = 0
	WHERE LibId = @LibraryId 

	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

