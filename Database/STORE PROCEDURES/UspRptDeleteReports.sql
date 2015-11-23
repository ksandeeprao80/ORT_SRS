IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptDeleteReports]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptDeleteReports]

GO
-- EXEC UspRptDeleteReports  101

CREATE PROCEDURE DBO.UspRptDeleteReports
	@ReportId INT 
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @ReportType CHAR(1)
	SELECT @ReportType = ReportType FROM dbo.TR_Report WHERE ReportId = @ReportId

	IF @ReportType = 'T' 
	BEGIN
		DELETE FROM DBO.TR_TrendCrossTabs WHERE ReportId = @ReportId

		DELETE TTOM
		FROM DBO.TR_TrendOptionMapping TTOM
		INNER JOIN DBO.TR_Trends TT
			ON TTOM.TrendId = TT.TrendId
		WHERE TT.ReportId = @ReportId	

		DELETE FROM DBO.TR_Trends WHERE ReportId = @ReportId
		
		DELETE FROM DBO.TR_ReportQuestions WHERE ReportId = @ReportId
		
		DELETE FROM DBO.TR_ReportDataSource WHERE ReportId = @ReportId
		
		DELETE FROM DBO.TR_Report WHERE ReportId = @ReportId AND ReportType = 'T'
	END
	ELSE
	BEGIN
		UPDATE dbo.TR_Report SET IsActive = 0 WHERE ReportId = @ReportId 
	END
   
	SELECT 1 as RetValue, 'Successfully Updated' AS Remark,@ReportId AS ReportId 
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH

	ROLLBACK TRAN
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage

END CATCH 

SET NOCOUNT OFF
END



 
 