IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyRequestDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyRequestDetails]

GO

-- EXEC UspGetSurveyRequestDetails 1113

CREATE PROCEDURE DBO.UspGetSurveyRequestDetails
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TSRD.RequestId, TSRD.SurveyId, TSRD.RespondentId, ISNULL(TSRD.RespondentSessionId,'') AS RespondentSessionId, 
		ISNULL(TSRD.SurveyPassword,'') AS SurveyPassword, TSRD.SurveyKey, TSRD.RenderMode, TSRD.QuestionId, 
		TSRD.RefereeId, LTRIM(RTRIM(TSRD.Channel)) AS Channel, ML.LangauageName AS LanguageDesc
	FROM DBO.TR_SurveyRequestDetails TSRD
	INNER JOIN DBO.TR_Survey TS
	   ON TSRD.SurveyId = TS.SurveyId
	INNER JOIN DBO.MS_Languages ML
	   ON TS.LanguageId = ML.LanguageId
	WHERE TSRD.SurveyId = @SurveyId
		AND TSRD.RespondentId = '0' AND TSRD.RenderMode = 'R'
 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

