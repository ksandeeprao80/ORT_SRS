IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptUpdateConjuction]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptUpdateConjuction
GO
--   
	
CREATE PROCEDURE DBO.UspRptUpdateConjuction  
	@ReportId INT,
	@FilterId INT,
	@Conjunction VARCHAR(20)
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  

	BEGIN TRAN  
  
	UPDATE TR_ReportFilterMapping
	SET Conjuction = @Conjunction
	WHERE ReportId = @ReportId
	AND FilterId = @FilterId

	SELECT 1 AS RetValue, 'Successfully Updated' AS Remark

	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 

