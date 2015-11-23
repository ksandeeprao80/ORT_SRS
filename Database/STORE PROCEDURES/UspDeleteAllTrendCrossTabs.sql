IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteAllTrendCrossTabs]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteAllTrendCrossTabs]
GO

--EXEC UspDeleteAllTrendCrossTabs 109

CREATE PROCEDURE DBO.UspDeleteAllTrendCrossTabs
	@ReportId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @RowId INT
	SET @RowId = 0
	
	DELETE FROM DBO.TR_TrendCrossTabs WHERE ReportId = @ReportId 

	SET @RowId = @@ROWCOUNT
	IF @RowId >= 1
	BEGIN
		DELETE FROM	DBO.TR_SongTrendReportColumn WHERE ReportId = @ReportId 
	END
	
	SELECT CASE WHEN @RowId = 0 THEN 0 ELSE 1 END AS RetValue,
		CASE WHEN @RowId = 0 THEN 'Delete Failed' ELSE 'Successfully Deleted' END AS Remark 
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

