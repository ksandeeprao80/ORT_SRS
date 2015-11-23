IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetMessageDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetMessageDetails]

GO
-- EXEC UspGetMessageDetails 1
CREATE PROCEDURE DBO.UspGetMessageDetails
	@MessageLibId INT = NULL 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY
 
	SELECT 
		LibId, CategoryId, MessageLibId AS MessageLibraryId, MessageDescription, MessageText 
	FROM DBO.TR_MessageLibrary
	WHERE MessageLibId = ISNULL(@MessageLibId,MessageLibId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END