IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetRoleAccess]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetRoleAccess]

GO

-- EXEC UspGetRoleAccess 1

CREATE PROCEDURE DBO.UspGetRoleAccess
	@RoleId VARCHAR(20) = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		DISTINCT 
		MRA.RoleId, LTRIM(RTRIM(MRA.RoleType)) AS RoleType, 
		MRA.AccessId, LTRIM(RTRIM(MRA.AccessModule)) AS AccessModule, MR.OpenAccess
	FROM DBO.MS_RoleAccess MRA 
	INNER JOIN DBO.MS_Users MU
		ON MRA.RoleType = MU.UserType
	INNER JOIN MS_Roles MR
		ON MU.UserType = MR.RoleType 
		AND MR.RoleId = ISNULL(CONVERT(INT,@RoleId),MR.RoleId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
 

   