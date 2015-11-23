IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspVerifyUser]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspVerifyUser]

GO
-- EXEC UspVerifyUser 'prasadk','abc',NULL
-- EXEC UspVerifyUser 'jdias','abc',NULL
-- EXEC UspVerifyUser NULL,NULL,'jdias@winsoftech.com'
-- EXEC UspVerifyUser NULL,NULL,'jOhnydias@winsoftech.com'

CREATE PROCEDURE DBO.UspVerifyUser
	@LoginId VARCHAR(30),
	@UserPassword VARCHAR(100),
	@EmailId VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY
	
	IF @LoginId IS NOT NULL AND @UserPassword IS NOT NULL AND @EmailId IS NULL 
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM DBO.MS_Users WHERE LoginId = @LoginId AND UserPassword = @UserPassword) 
		BEGIN
			SELECT 0 AS UserId, 'False' AS [Status], 'Invalid Login Id or Password.' AS Msg
			RETURN
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM DBO.MS_Users WHERE LoginId = @LoginId AND UserPassword = @UserPassword AND IsActive = 1)
			BEGIN
				SELECT 0 AS UserId, 'False' AS [Status], 'Inactive User' AS Msg
				RETURN
			END 
			ELSE
			BEGIN
				IF EXISTS(SELECT 1 FROM DBO.MS_Users WHERE ISNULL(IsLogin,0) = 1) 
				BEGIN
					SELECT 0 AS UserId, 'False' AS [Status], 'User is already logged in' AS Msg
					RETURN
				END
				ELSE
				BEGIN
					SELECT 
						ISNULL(UserId,0) AS UserId, 'True' AS [Status], 'Success' AS Msg
					FROM DBO.MS_Users 
					WHERE LoginId = @LoginId
						AND UserPassword = @UserPassword
						AND IsActive = 1
	
					UPDATE DBO.MS_Users SET IsLogin = 1 WHERE LoginId = @LoginId
						AND UserPassword = @UserPassword AND IsActive = 1
				END
			END
		END
	END
	
	IF @LoginId IS NULL AND @UserPassword IS NULL AND @EmailId IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM DBO.MS_Users WHERE EmailId = @EmailId) 
		BEGIN
			SELECT 0 AS UserId, 'False' AS [Status], 'Email id is not registered with us.' AS Msg
			RETURN
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM DBO.MS_Users WHERE EmailId = @EmailId AND IsActive = 1)
			BEGIN
				SELECT 0 AS UserId, 'False' AS [Status], 'Inactive User' AS Msg
				RETURN
			END 
			ELSE
			BEGIN
				IF EXISTS(SELECT 1 FROM DBO.MS_Users WHERE ISNULL(IsLogin,0) = 1) 
				BEGIN
					SELECT 0 AS UserId, 'False' AS [Status], 'User is already logged in' AS Msg
					RETURN
				END
				ELSE
				BEGIN
					SELECT 
						ISNULL(UserId,0) AS UserId, 'True' AS [Status], 'Success' AS Msg
					FROM DBO.MS_Users 
					WHERE EmailId = @EmailId
						AND IsActive = 1
	
					UPDATE DBO.MS_Users SET IsLogin = 1 WHERE EmailId = @EmailId AND IsActive = 1
				END
			END
		END
	END

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

