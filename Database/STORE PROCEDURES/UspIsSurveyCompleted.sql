IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspIsSurveyCompleted]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspIsSurveyCompleted

GO
CREATE PROCEDURE DBO.UspIsSurveyCompleted
	@SurveyId INT,
	@SessionId VARCHAR(100),
	@RespondentId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @Count INT		 
	SET @Count = 0

	SELECT @Count = COUNT(1) FROM DBO.TR_Responses TR 
	INNER JOIN DBO.TR_SurveyQuestions TSQ 
		ON TR.QuestionId = TSQ.QuestionId
		AND TSQ.SurveyId = @SurveyId 
		AND LTRIM(RTRIM(TR.SessionId)) = ISNULL(@SessionId,LTRIM(RTRIM(TR.SessionId)))
		AND TR.RespondentId = ISNULL(@RespondentId,TR.RespondentId)
	WHERE TR.[Status] = 'C'
	
	IF @Count = 0
	BEGIN
		SELECT 0 AS RetValue, 'Survey Not Completed' AS Remark
	END
	ELSE
	BEGIN
		SELECT 1 AS RetValue, 'Survey Completed' AS Remark
	END

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END





