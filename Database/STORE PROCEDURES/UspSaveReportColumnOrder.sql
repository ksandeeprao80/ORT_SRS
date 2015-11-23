IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveReportColumnOrder]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveReportColumnOrder]

GO

-- EXEC UspSaveReportColumnOrder 6,'JO,HN,NY,DI,IAIAIAIAIAI,JKJKJKJKJK,OOOOOO','TrendOption'
-- EXEC UspSaveReportColumnOrder 6,'JJJJJJJJJJ,DDDDDDDDD','TrendOption'
--EXEC UspSaveReportColumnOrder 6,'JJJJJJJJJJ,DDDDDDDDD','TrendRanker'

CREATE PROCEDURE DBO.UspSaveReportColumnOrder
	@ReportId INT,
	@ColumnOrder VARCHAR(500),
	@TableType VARCHAR(20)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	IF EXISTS(SELECT 1 FROM DBO.TR_ReportColumnOrder WHERE ReportId = @ReportId AND LTRIM(RTRIM(TableType)) = LTRIM(RTRIM(@TableType)))
	BEGIN
		UPDATE DBO.TR_ReportColumnOrder
		SET ColumnOrder = @ColumnOrder
		WHERE ReportId = @ReportId 
		AND LTRIM(RTRIM(TableType)) = LTRIM(RTRIM(@TableType))
		
		SELECT 1 AS RetValue, 'Successfully Updated' AS Remark
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TR_ReportColumnOrder  
		(ReportId, ColumnOrder, TableType) 
		VALUES
		(@ReportId,@ColumnOrder,@TableType) 
		
		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark	
	END		

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END


