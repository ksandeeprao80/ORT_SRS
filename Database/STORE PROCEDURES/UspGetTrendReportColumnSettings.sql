IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTrendReportColumnSettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTrendReportColumnSettings]

GO

-- EXEC UspGetTrendReportColumnSettings 
CREATE PROCEDURE DBO.UspGetTrendReportColumnSettings
	@ReportId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		ReportId, ColumnName, Setting, SettingId
	FROM DBO.TR_TrendReportColumnSettings
	WHERE ReportId = ISNULL(@ReportId,ReportId)
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END