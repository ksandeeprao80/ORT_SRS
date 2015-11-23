IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetUserAccess]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetUserAccess]

GO

-- EXEC UspGetUserAccess
CREATE PROCEDURE DBO.UspGetUserAccess
	@AccessId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT  
		AccessId, ISNULL(AccessName,'')AS AccessName, ISNULL(AccessModule,'') AS AccessModule,
		ISNULL(AccessLink,'') AS AccessLink, ISNULL(IsActive,0) AS IsActive
	FROM MS_UserAccess WITH(NOLOCK)
	WHERE AccessId = ISNULL(@AccessId,AccessId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END