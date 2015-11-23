IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteUsers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteUsers]
GO

--EXEC UspDeleteUsers 'yogesh'  

CREATE PROCEDURE DBO.UspDeleteUsers
	@LoginId VARCHAR(30),
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
	BEGIN
		DELETE MU
		FROM DBO.MS_Users MU 
		INNER JOIN @UserInfo UI
			ON UI.CustomerId = MU.CustomerId
		WHERE LTRIM(RTRIM(MU.LoginId)) = LTRIM(RTRIM(@LoginId))
			AND MU.UserType <> 'SA'
			
		SELECT 1 AS RetValue, 'Successfully User Deleted' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
	BEGIN
		DELETE FROM DBO.MS_Users WHERE LTRIM(RTRIM(LoginId)) = LTRIM(RTRIM(@LoginId)) AND UserType <> 'SA'
		
		SELECT 1 AS RetValue, 'Successfully User Deleted' AS Remark
	END

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','SLU'))
	BEGIN
	
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END
	
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

 