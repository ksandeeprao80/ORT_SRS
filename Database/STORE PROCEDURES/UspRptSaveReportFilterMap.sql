IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptSaveReportFilterMap]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptSaveReportFilterMap

GO  
-- UspRptSaveReportFilterMap 6,31
CREATE PROCEDURE DBO.UspRptSaveReportFilterMap
	@ReportId INT,
	@FilterId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @RowId INT,
		@Count INT,
		@Conjuction VARCHAR(20) 
	SET @RowId = 0		
	SET @Count = 0
	SET @Conjuction = ''

	SELECT @Count = COUNT(1) FROM DBO.TR_ReportFilterMapping WHERE ReportId = @ReportId
	IF @Count > 0 SET @Conjuction = 'and'	

	IF EXISTS(SELECT 1 FROM DBO.TR_ReportFilterMapping WHERE ReportId = @ReportId AND FilterId = @FilterId)
	BEGIN
		SELECT 0 AS RetValue, 'Already applied to report' AS Remark
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TR_ReportFilterMapping
		(ReportId, FilterId, Conjuction)
		SELECT @ReportId, @FilterId, @Conjuction
			
		SET @RowId = @@ROWCOUNT
		IF @RowId = 0
		BEGIN 
			SELECT 0 AS RetValue, 'Insert Failed' AS Remark
		END
		ELSE
		BEGIN
			SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark
		END
	END

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
