IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetFileLibraryInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetFileLibraryInfo]

GO

-- EXEC UspGetFileLibraryInfo 9,1
CREATE PROCEDURE DBO.UspGetFileLibraryInfo
	@LibId INT = NULL,
	@CustomerId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT TFL.LibId, TL.LibName, COUNT(1) AS NoOfSongs
	FROM DBO.TR_FileLibrary TFL
	INNER JOIN TR_Library TL
		ON TFL.LibId = TL.LibId
		AND TFL.LibId = ISNULL(@LibId,TFL.LibId)
		AND TL.CustomerId = @CustomerId	
		AND TFL.IsDeleted = 'N'
	GROUP BY TFL.LibId, TL.LibName

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 