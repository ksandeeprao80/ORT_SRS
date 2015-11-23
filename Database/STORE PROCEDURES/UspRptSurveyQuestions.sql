IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptSurveyQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptSurveyQuestions]

GO
-- EXEC UspRptSurveyQuestions NULL,1158,12

CREATE PROCEDURE DBO.UspRptSurveyQuestions
	@QuestionId INT = NULL,
	@SurveyId INT = NULL,
	@ReportId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	 SELECT  
		TSQ.QuestionId, TSQ.SurveyId, TSQ.CustomerId, TSQ.QuestionTypeId, 
		LTRIM(RTRIM(ISNULL(MQT.QuestionCode,''))) AS QuestionCode, 
		LTRIM(RTRIM(ISNULL(MQT.QuestionName,''))) AS QuestionName, 
		LTRIM(RTRIM(ISNULL(TSQ.QuestionText,''))) AS QuestionText,  
		TSQ.IsDeleted, ISNULL(TSQ.DefaultAnswerId,'') AS DefaultAnswerId,
		ISNULL(TSQ.QuestionNo,0) AS QuestionNo,
		CASE WHEN TRQ.StatusId = 1 THEN 'TRUE' ELSE 'FALSE' END QuestionStatus
	FROM DBO.TR_SurveyQuestions TSQ
	INNER JOIN DBO.MS_QuestionTypes MQT
		ON TSQ.QuestionTypeId = MQT.QuestionTypeId 
		AND MQT.QuestionTypeId IN (1,2,3,5,6,7,8,9)
		AND TSQ.IsDeleted = 1
		AND TSQ.QuestionId = ISNULL(@QuestionId,TSQ.QuestionId)
		AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId)
	INNER JOIN DBO.TR_ReportQuestions TRQ 
		ON TRQ.QuestionId = TSQ.QuestionId 
		AND TRQ.ReportId = @ReportId
	INNER JOIN DBO.TR_ReportDataSource TRD 
		ON TRD.SurveyId = TSQ.SurveyId 
	INNER JOIN DBO.TR_Report TRPT 
		ON TRPT.ReportId = TRD.ReportId 
		AND TRPT.ReportId = @ReportId
	INNER JOIN 
	(		
		SELECT TQS.QuestionId 
		FROM MS_QuestionSettings MQS
		INNER JOIN TR_QuestionSettings TQS
		ON MQS.SettingId = TQS.SettingId
		--WHERE MQS.SettingName = 'IsMTBQuestion'
		AND MQS.SettingName = 'IsMTBQuestion'
		AND TQS.Value = 'False'
	) TQS
		ON TSQ.QuestionId = TQS.QuestionId
	ORDER BY ISNULL(TSQ.QuestionNo,0), TSQ.QuestionId
 
	--DROP TABLE #NotAllowedQuestions
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


