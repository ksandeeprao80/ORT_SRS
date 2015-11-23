IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUnSubscribeMember]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUnSubscribeMember
GO
-- UspUnSubscribeMember
   
CREATE PROCEDURE DBO.UspUnSubscribeMember  
	@RespondentId INT
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  

	BEGIN TRAN  

	UPDATE DBO.MS_Respondent
	SET IsActive = 0,
		IsDeleted = 0,
		ModifiedOn = GETDATE()
	WHERE RespondentId = @RespondentId
	
	SELECT 1 AS RetValue, 'Successfully Updated' AS Remark

	COMMIT TRAN  
 
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 

