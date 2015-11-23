IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetPrivileges]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetPrivileges 

GO
--  UspGetPrivileges 2
CREATE PROCEDURE DBO.UspGetPrivileges 
	@UserId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @RoleId INT
	SELECT @RoleId = MR.RoleId FROM MS_Users MU INNER JOIN MS_Roles MR ON MU.UserType = MR.RoleType WHERE MU.UserId = @UserId  

	SELECT 
		MMA.ModuleId, MMA.ModuleName, MMA.ParentId, ISNULL(MMRA.RoleId,0) AS RoleId, 
		--CASE WHEN MMRA.ModuleId IS NULL THEN 'false' ELSE 'true' END AS AccessStatus,
		'true' AS AccessStatus, MMA.AccessLevel
	FROM MS_MenuAccess MMA
	--LEFT OUTER JOIN 
	INNER JOIN dbo.MS_MenuRoleAccess MMRA
		ON MMA.ModuleId = MMRA.ModuleId 
	WHERE MMRA.RoleId = @RoleId
		 --AND  MMRA.ModuleId IS NOT NULL
	ORDER BY MMA.AccessLevel, MMA.ModuleId ASC
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

