IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetReport]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetReport]

GO
-- EXEC UspGetReport  

CREATE PROCEDURE DBO.UspGetReport
	@ReportId INT = NULL,
	@ReportName VARCHAR(100) = NULL,
	@ReportType CHAR(1) = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		ReportId, ReportName, CustomerId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, ReportType 
	FROM dbo.TR_Report 
	WHERE ReportId = ISNULL(@ReportId,ReportId)
		AND ReportName = ISNULL(@ReportName,ReportName)
		AND ReportType = ISNULL(@ReportType,'P')
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


