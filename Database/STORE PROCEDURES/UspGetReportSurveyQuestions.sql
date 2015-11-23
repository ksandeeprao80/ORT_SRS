IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[USPGetReportSurveyQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[USPGetReportSurveyQuestions]

GO
-- EXEC USPGetReportSurveyQuestions NULL,1112

CREATE PROCEDURE DBO.USPGetReportSurveyQuestions
	@QuestionId INT = NULL,
	@SurveyId INT = NULL
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
		ISNULL(TSQ.QuestionNo,0) AS QuestionNo
	FROM DBO.TR_SurveyQuestions TSQ
	INNER JOIN DBO.MS_QuestionTypes MQT
		ON TSQ.QuestionTypeId = MQT.QuestionTypeId AND MQT.QuestionTypeId in (1,2,3,5,6,7,8,9)
		AND TSQ.QuestionId = ISNULL(@QuestionId,TSQ.QuestionId)
		AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId)
	ORDER BY TSQ.QuestionNo
 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


