IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetReportFilter]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetReportFilter]

GO

--EXEC UspGetReportFilter NULL,NULL,'P' 
CREATE PROCEDURE DBO.UspGetReportFilter
	@FilterId INT = NULL,
	@SurveyId INT = NULL,
	@ReportType VARCHAR(1) = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		MRF.FilterId, MRF.FilterName, MRF.SurveyId, TRF.QuestionId, TRF.Operator,
		TRF.AnswerId, TRF.AnswerText, TRF.FilterOperator, MRF.ReportType
	FROM DBO.MS_ReportFilter MRF
	INNER JOIN DBO.TR_ReportFilter TRF
		ON MRF.FilterId = TRF.FilterId
		AND MRF.FilterId = ISNULL(@FilterId,MRF.FilterId)
		AND MRF.SurveyId = ISNULL(@SurveyId,MRF.SurveyId)
		AND MRF.ReportType = ISNULL(@ReportType,MRF.ReportType)
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 