IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptGetReports]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptGetReports]

GO
-- EXEC UspRptGetReports  1168

CREATE PROCEDURE DBO.UspRptGetReports
	@SurveyId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		DISTINCT TR.ReportId,TR.ReportName, CASE WHEN TR.IsActive = 1 THEN 'Active' ELSE 'InActive' END AS RptStatus,
		MUC.UserName AS CreatedBy, CONVERT(VARCHAR(10),TR.CreatedOn,101) AS CreatedOn, MUM.UserName AS ModifiedBy, 
		CONVERT(VARCHAR(10),TR.ModifiedOn,101) AS ModifiedOn, TR.ReportType,
		TT.BaseSurveyName, ISNULL(TT.BaseSurveyId,0) AS BaseSurveyId
	FROM dbo.TR_Report TR
	INNER JOIN dbo.TR_ReportDataSource TRDS
		ON TR.ReportId = TRDS.ReportId AND TR.IsActive = 1
		AND TRDS.SurveyId = @SurveyId
	LEFT OUTER JOIN DBO.MS_Users MUC
		ON TR.CreatedBy = MUC.UserId
	LEFT OUTER JOIN DBO.MS_Users MUM
		ON TR.ModifiedBy = MUM.UserId
	LEFT OUTER JOIN DBO.TR_Trends TT
		ON TR.ReportId = TT.ReportId
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


