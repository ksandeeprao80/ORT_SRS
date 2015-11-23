IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetReportDataSource]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetReportDataSource]

GO
-- EXEC UspGetReportDataSource  

CREATE PROCEDURE DBO.UspGetReportDataSource
	@RDSId INT = NULL,
	@ReportId INT = NULL,
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		RDSId, ReportId, SurveyId, SurveyName 
	FROM dbo.TR_ReportDataSource 
	WHERE RDSId = ISNULL(@RDSId,RDSId)
		AND ReportId = ISNULL(@ReportId,ReportId)
		AND SurveyId = ISNULL(@SurveyId,SurveyId) 
 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


