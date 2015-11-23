IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCheckLibraryCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspCheckLibraryCategory]

GO

-- EXEC UspCheckLibraryCategory 22,100
CREATE PROCEDURE DBO.UspCheckLibraryCategory
	@LibId INT,
	@CategoryId INT
AS 
SET NOCOUNT ON
BEGIN
BEGIN TRY

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_LibraryCategory WITH(NOLOCK) 
		WHERE LibId =  @LibId AND CategoryId = @CategoryId
	)
	BEGIN
		SELECT 1 AS RetValue, 'True' AS Remark
	END
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'False' AS Remark
	END

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END