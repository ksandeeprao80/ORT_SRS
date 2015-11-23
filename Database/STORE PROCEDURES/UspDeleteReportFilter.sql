IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteReportFilter]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteReportFilter]
GO
 
 
--EXEC UspDeleteReportFilter 

CREATE PROCEDURE DBO.UspDeleteReportFilter
	@FilterId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	IF EXISTS(SELECT 1 FROM dbo.TR_ReportFilterMapping WHERE FilterId = @FilterId)
	BEGIN
		SELECT 0 AS RetValue, 'Can Not Delete, Filter Is Used In Other Report' AS Remark
	END
	ELSE
	BEGIN
		DELETE FROM DBO.TR_ReportFilter WHERE FilterId = @FilterId
		
		DELETE FROM DBO.MS_ReportFilter WHERE FilterId = @FilterId
		
		SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
	END

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
 