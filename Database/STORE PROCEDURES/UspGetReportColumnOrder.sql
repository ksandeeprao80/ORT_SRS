IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetReportColumnOrder]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetReportColumnOrder]

GO

-- EXEC UspGetReportColumnOrder
CREATE PROCEDURE DBO.UspGetReportColumnOrder
	@ReportId INT,
	@TableType VARCHAR(20)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		RowId, ReportId, ColumnOrder, TableType 
	FROM DBO.TR_ReportColumnOrder
	WHERE ReportId = @ReportId 
		AND LTRIM(RTRIM(TableType)) = LTRIM(RTRIM(@TableType))

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
