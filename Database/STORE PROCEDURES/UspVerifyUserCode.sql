IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspVerifyUserCode]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspVerifyUserCode]

GO
-- EXEC UspVerifyUserCode 'SRS2',''
CREATE PROCEDURE DBO.UspVerifyUserCode
	@UserCode VARCHAR(20),
	@UserId VARCHAR(20)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @Count INT
	SET @Count = 0

	IF ISNULL(@UserId,'') = ''
	BEGIN	
		SELECT @Count = COUNT(1) FROM DBO.MS_Users WHERE UserCode = @UserCode
		
		IF @Count = 0
		BEGIN
			SELECT 1 AS RetValue, 'User Code Not Exist In The System' AS Remark
		END
		ELSE
		BEGIN
			SELECT 0 AS RetValue, 'User Code Exist In The System' AS Remark
		END
	END
	ELSE
	BEGIN
		SELECT @Count = COUNT(1) FROM DBO.MS_Users WHERE UserCode = @UserCode 
		
		IF @Count = 0
		BEGIN
			SELECT 1 AS RetValue, 'User Code Not Exist In The System' AS Remark
		END
		ELSE
		BEGIN
			SELECT @Count = COUNT(1) FROM DBO.MS_Users WHERE UserCode = @UserCode AND UserId = @UserId
			
			IF @Count = 1
			BEGIN
				SELECT 1 AS RetValue, 'User Code Not Exist In The System' AS Remark
			END
			ELSE
			BEGIN
				SELECT 0 AS RetValue, 'User Code Exist In The System' AS Remark
			END
		END
	END

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END




 