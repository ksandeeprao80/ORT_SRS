IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyQuestions]

GO

-- EXEC UspGetSurveyQuestions 
CREATE PROCEDURE DBO.UspGetSurveyQuestions
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
		ISNULL(TSQ.ForceResponse,0) AS ForceResponse, 
		ISNULL(TSQ.HasSkipLogic,0) AS HasSkipLogic, 
		ISNULL(TSQ.HasEmailTrigger,0) AS HasEmailTrigger, 
		ISNULL(TSQ.HasMedia,0) AS HasMedia, 
		TSQ.IsDeleted, ISNULL(TSQ.DefaultAnswerId,'') AS DefaultAnswerId,
		ISNULL(TSQ.QuestionNo,0) AS QuestionNo
	FROM DBO.TR_SurveyQuestions TSQ
	INNER JOIN MS_QuestionTypes MQT
		ON TSQ.QuestionTypeId = MQT.QuestionTypeId
	WHERE TSQ.QuestionId = ISNULL(@QuestionId,TSQ.QuestionId)
		AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId)
	ORDER BY TSQ.QuestionNo

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END