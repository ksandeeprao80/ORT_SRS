IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdatePasswordRequested]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdatePasswordRequested
GO
-- UspUpdatePasswordRequested 'pallavi'
CREATE PROCEDURE DBO.UspUpdatePasswordRequested
	@LoginId VARCHAR(30),
	@LinkKey VARCHAR(100)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	UPDATE DBO.MS_Users
	SET PasswordRequested =  CASE WHEN PasswordRequested = 'Y' THEN 'N' ELSE 'Y' END,
		LinkKey = @LinkKey
	WHERE LoginId = @LoginId
				
	SELECT 1 AS RetValue, 'Successfully Updated' AS Remark

	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 

