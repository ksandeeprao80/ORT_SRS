IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetPlayListForEngine]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetPlayListForEngine]

GO

-- EXEC UspGetPlayListForEngine  
CREATE PROCEDURE DBO.UspGetPlayListForEngine
	@PlayListId INT = NULL,
	@PlayListName VARCHAR(150) = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		MPL.PlayListId, MPL.PlayListName, MPL.IsActive, MPL.CustomerId, MPL.CreatedBy,
		MPL.CreatedOn, MPL.ModifiedBy, MPL.ModifiedOn
	FROM DBO.MS_PlayList MPL
	WHERE MPL.PlayListId = ISNULL(@PlayListId,MPL.PlayListId)
		AND MPL.PlayListName LIKE '%'+ISNULL(@PlayListName,MPL.PlayListName)+'%'
		AND MPL.IsActive = 1

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END