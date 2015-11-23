IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteTrendReportColumns]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteTrendReportColumns]
GO

-- EXEC UspDeleteTrendReportColumns 

CREATE PROCEDURE DBO.UspDeleteTrendReportColumns
	@ReportId INT,
	@ColumnId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @ReportColumns NVARCHAR(150)
	DECLARE @CrossTabs NVARCHAR(150)

	SELECT @ReportColumns = ColumnName FROM DBO.TR_TrendReportColumns WHERE ReportId = @ReportId AND TRId = @ColumnId
	SELECT @CrossTabs = ISNULL(OptionDisplayText,MTBOptionName) FROM TR_TrendCrossTabs WHERE ReportId = @ReportId AND MtbOptionId = @ColumnId

	DELETE FROM DBO.TR_TrendReportColumns WHERE ReportId = @ReportId AND TRId = @ColumnId
	
	DELETE FROM DBO.TR_TrendCrossTabs WHERE ReportId = @ReportId AND MtbOptionId = @ColumnId
	
	DELETE FROM DBO.TR_SongTrendReportColumn WHERE ReportId = @ReportId AND LTRIM(RTRIM(ColumnText)) = LTRIM(RTRIM(@ReportColumns))

	DELETE FROM DBO.TR_SongTrendReportColumn WHERE ReportId = @ReportId AND LTRIM(RTRIM(ColumnText)) = LTRIM(RTRIM(@CrossTabs))
	
	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
	
 	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END