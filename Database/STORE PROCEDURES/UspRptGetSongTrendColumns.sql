IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptGetSongTrendColumns]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptGetSongTrendColumns]
GO
 
--EXEC UspRptGetSongTrendColumns 

CREATE PROCEDURE DBO.UspRptGetSongTrendColumns
	@ReportId INT,
	@TabType VARCHAR(15) 
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT ReportId, ColumnText, Hidden, Tab
	FROM DBO.TR_SongTrendReportColumn
	WHERE ReportId = ISNULL(@ReportId,ReportId)
		AND Tab = ISNULL(@TabType,Tab)

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END