IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyResponse]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyResponse]

GO
-- EXEC UspGetSurveyResponse @QuestionId='17681',@SurveyId=2031,@SessionId='1cmmgbzrgr40ng45d5pawf45',@SongId=0, @RespondentId=0

CREATE PROCEDURE DBO.UspGetSurveyResponse
	@QuestionId INT,
	@SurveyId INT,
	@SessionId VARCHAR(100),
	@SongId INT,
	@RespondentId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	IF (@SongId = '' OR @SongId = 0)
		SET @SongId = NULL
	IF ISNULL(@RespondentId,'') = ''
		SET @RespondentId = 0	
		
	SELECT 
		TR.ResponseId, TR.QuestionId, TR.AnswerId, TR.RespondentId, LTRIM(RTRIM(TR.SessionId)) AS SessionId,
		ISNULL(TR.[Status],'I') AS [Status], 
		CASE WHEN ISNULL(TR.SongId,0) = 0 THEN ISNULL(CONVERT(NVARCHAR(500),TR.AnswerText),CONVERT(NVARCHAR(500),TSA.Answer)) 
			ELSE TMA.Answer END AS AnswerText, 
		ISNULL(TR.ResponseDate,'') AS ResponseDate, ISNULL(TR.SongId,0) AS SongId
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId
		AND TR.QuestionId = @QuestionId 
		AND 
		( 
			(
				ISNULL(@RespondentId,0) = 0 
				AND LTRIM(RTRIM(TR.SessionId)) = LTRIM(RTRIM(@SessionId))
			)
			OR
			(
				(ISNULL(@RespondentId,0) <> 0 AND TR.RespondentId = @RespondentId AND LTRIM(RTRIM(TR.SessionId)) = LTRIM(RTRIM(@SessionId)))
			)
		)
		AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId)
		AND TR.SongId = ISNULL(@SongId,TR.SongId)
		AND TSQ.IsDeleted = 1
	LEFT JOIN DBO.TR_SurveyAnswers TSA
		ON TR.QuestionId = TSA.QuestionId
		AND TR.AnswerId = TSA.AnswerId
	LEFT JOIN DBO.TR_MediaAnswers TMA
		ON TR.AnswerId = TMA.AnswerId
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END









