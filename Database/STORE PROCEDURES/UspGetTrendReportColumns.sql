IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTrendReportColumns]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetTrendReportColumns

GO
-- UspGetTrendReportColumns  
CREATE PROCEDURE DBO.UspGetTrendReportColumns 
	@ReportId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TRId, ReportId, ColumnName, Expression, ReportStatus, TrendType  
	FROM DBO.TR_TrendReportColumns 
	WHERE ReportId = @ReportId 
	

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
