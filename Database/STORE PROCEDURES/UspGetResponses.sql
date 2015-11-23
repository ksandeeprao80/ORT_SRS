IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetResponses]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetResponses]

GO

-- EXEC UspGetResponses 
CREATE PROCEDURE DBO.UspGetResponses
	@ResponseId INT = NULL,
	@QuestionId INT = NULL,
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TR.ResponseId AS ResponseId, ISNULL(TR.QuestionId,0) AS QuestionId, 
		ISNULL(TR.AnswerId,0) AS AnswerId, ISNULL(TR.RespondentId,0) AS RespondentId,
		TSQ.SurveyId, ISNULL(TR.AnswerText,'') AS AnswerText,
		ISNULL(TR.ResponseDate,'') AS ResponseDate, ISNULL(TR.SongId,0) AS SongId 
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId
		AND TR.ResponseId = ISNULL(@ResponseId,TR.ResponseId)
		AND TR.QuestionId = ISNULL(@QuestionId,TR.QuestionId)
		AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId)
		AND TSQ.IsDeleted = 1
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END