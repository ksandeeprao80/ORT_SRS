IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptHideTrendReportColumn]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptHideTrendReportColumn]
GO
 

--EXEC UspRptHideTrendReportColumn 

CREATE PROCEDURE DBO.UspRptHideTrendReportColumn
	@ReportId INT,
	@ColumnText NVARCHAR(150) = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	UPDATE DBO.TR_SongTrendReportColumn
	SET Hidden = 'True'
	WHERE ReportId = @ReportId
		AND LTRIM(RTRIM(ColumnText)) = LTRIM(RTRIM(ISNULL(@ColumnText,ColumnText)))

	SELECT 1 AS RetValue, 'Successfully Updated' AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END