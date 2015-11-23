IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCompleteSurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspCompleteSurvey
GO
-- EXEC UspCompleteSurvey 1087,'bfetr245lklgkn55acydevjx'

CREATE PROCEDURE DBO.UspCompleteSurvey
	@SurveyId INT,
	@SessionId VARCHAR(100)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	UPDATE TR
	SET TR.Status = 'C'
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId
		AND LTRIM(RTRIM(TR.SessionId)) = LTRIM(RTRIM(@SessionId))

	SELECT 1 AS RetValue, 'Successfully Response Completed' AS Remark 

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
