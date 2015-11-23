IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteRespondentData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteRespondentData]
GO

--EXEC UspDeleteRespondentData 1,1

CREATE PROCEDURE DBO.UspDeleteRespondentData
	@SurveyId INT,
	@RespondentId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DELETE TR
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId
	WHERE TR.RespondentId = @RespondentId
		AND TSQ.SurveyId = @SurveyId

	DELETE TSP
	FROM dbo.TR_SurveyProgress TSP
	INNER JOIN dbo.TR_SurveyQuestions TSQ
		ON TSP.QuestionId = TSQ.QuestionId
		AND TSP.RespondentId = @RespondentId
				
	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
		
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

