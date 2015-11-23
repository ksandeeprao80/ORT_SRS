IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetRole]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetRole]

GO

--EXEC UspGetRole 'GU'
--EXEC UspGetRole NULL
CREATE PROCEDURE DBO.UspGetRole
	@RoleType VARCHAR(5) = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		RoleId, RoleType, RoleDescription, Hierarchy, OpenAccess
	FROM DBO.MS_Roles WITH(NOLOCK)
	WHERE RoleType = ISNULL(@RoleType,RoleType)
	ORDER BY Hierarchy

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 