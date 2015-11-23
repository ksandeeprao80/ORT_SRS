IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyRequestDetailsByKey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyRequestDetailsByKey]

GO

-- EXEC UspGetSurveyRequestDetailsByKey 'TFUFDGXNAQDQQRFJWYET'
CREATE PROCEDURE DBO.UspGetSurveyRequestDetailsByKey 
	@SurveyKey VARCHAR(100)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TSRD.RequestId, TSRD.SurveyId, TSRD.RespondentId, TSRD.RespondentSessionId, TSRD.SurveyPassword, 
		TSRD.SurveyKey, TSRD.RenderMode, TSRD.QuestionId, TSRD.RefereeId, LTRIM(RTRIM(TSRD.Channel)) AS Channel,
		ML.LangauageName AS LanguageDesc
	FROM DBO.TR_SurveyRequestDetails TSRD
	INNER JOIN DBO.TR_Survey TS
	   ON TSRD.SurveyId = TS.SurveyId
	INNER JOIN DBO.MS_Languages ML
	   ON TS.LanguageId = ML.LanguageId
	WHERE LTRIM(RTRIM(TSRD.SurveyKey)) = LTRIM(RTRIM(@SurveyKey))
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END