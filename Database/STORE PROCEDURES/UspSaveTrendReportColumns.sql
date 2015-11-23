IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveTrendReportColumns]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveTrendReportColumns]

GO
--	
CREATE PROCEDURE DBO.UspSaveTrendReportColumns
	@ReportId INT, 
	@ColumnName NVARCHAR(300), 
	@Expression NVARCHAR(1000), 
	@ReportStatus INT,
	@TrendType VARCHAR(10)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @TRId INT
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_TrendReportColumns 
		WHERE ReportId = @ReportId AND LTRIM(RTRIM(ColumnName)) = LTRIM(RTRIM(@ColumnName))
	)
	BEGIN
		SELECT 0 AS RetValue, 'Already Exist In The System' AS Remark
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TR_TrendReportColumns
		(ReportId, ColumnName, Expression, ReportStatus, TrendType)
		SELECT 
			@ReportId, @ColumnName, @Expression, @ReportStatus, @TrendType  
		
		SET @TRId = @@IDENTITY
		
		IF @TRId >= 1
		BEGIN
			INSERT INTO DBO.TR_SongTrendReportColumn
			(ReportId, ColumnText, Hidden)
			SELECT 
				TTRC.ReportId, TTRC.ColumnName, 'False' 
			FROM DBO.TR_TrendReportColumns TTRC
			LEFT JOIN DBO.TR_SongTrendReportColumn TSTRC
				ON TTRC.ReportId = TSTRC.ReportId
				AND LTRIM(RTRIM(TTRC.ColumnName)) = LTRIM(RTRIM(TSTRC.ColumnText))
			WHERE TTRC.ReportId = @ReportId AND TSTRC.ColumnText IS NULL
		END 
		 
		SELECT 
			CASE WHEN ISNULL(@TRId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@TRId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
			ISNULL(@TRId,0) AS TRId 
	END
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



