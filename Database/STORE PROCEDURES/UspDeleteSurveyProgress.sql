IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSurveyProgress]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspDeleteSurveyProgress

GO
-- EXEC UspDeleteSurveyProgress '123121311D1A23DS1ASDF23SDF13' 
CREATE PROCEDURE DBO.UspDeleteSurveyProgress
	@SessionId VARCHAR(100),
	@SurveyId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DELETE TSP
	FROM DBO.TR_SurveyProgress TSP
	INNER JOIN DBO.TR_SurveyQuestions TSQ
		ON TSP.QuestionId = TSQ.QuestionId
		AND TSQ.SurveyId = @SurveyId
		AND LTRIM(RTRIM(TSP.SessionId)) = LTRIM(RTRIM(@SessionId))
	
	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
						
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
