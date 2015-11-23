IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptReportDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptReportDetails]

GO
-- EXEC UspRptReportDetails 1

CREATE PROCEDURE DBO.UspRptReportDetails
	@ReportId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		DISTINCT TR.ReportId, TR.ReportName, TR.CustomerId, TR.IsActive, TR.CreatedBy, 
		CONVERT(VARCHAR(10),TR.CreatedOn,101) AS CreatedOn, TR.ModifiedBy, 
		CONVERT(VARCHAR(10),TR.ModifiedOn,101) AS ModifiedOn,
		CASE WHEN TR.IsActive = 1 THEN 'Active' ELSE 'InActive' END AS RptStatus, TR.ReportType,
		TT.BaseSurveyName
	FROM dbo.TR_Report TR
	LEFT OUTER JOIN DBO.TR_Trends TT
		ON TR.ReportId = TT.ReportId
	WHERE TR.ReportId = @ReportId 
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


