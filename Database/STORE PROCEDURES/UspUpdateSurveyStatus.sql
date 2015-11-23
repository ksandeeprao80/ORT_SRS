IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdateSurveyStatus]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdateSurveyStatus
GO

-- UspUpdateSurveyStatus  1101,'Active'

CREATE PROCEDURE DBO.UspUpdateSurveyStatus
	@SurveyId INT,
	@SurveyStatusName VARCHAR(10) 
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  

	BEGIN TRAN  

	DECLARE @StatusId INT
		
	SELECT @StatusId = StatusId FROM DBO.MS_SurveyStatus 
	WHERE LTRIM(RTRIM(SurveyStatusName)) = LTRIM(RTRIM(@SurveyStatusName))
	
	DECLARE @RowId INT
	SET @RowId = 0
	
	UPDATE DBO.TR_Survey
	SET StatusId = @StatusId,
		ModifiedDate = GETDATE()
	WHERE SurveyId = @SurveyId
	
	SET @RowId = @@ROWCOUNT
	
	SELECT 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Update Failed' ELSE 'Successfully Updated' END AS Remark 
		 

	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 

