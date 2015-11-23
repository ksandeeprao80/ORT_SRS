IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSurveyAnswers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteSurveyAnswers]
GO

-- EXEC UspDeleteSurveyAnswers 12163

CREATE PROCEDURE DBO.UspDeleteSurveyAnswers
	@QuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	CREATE TABLE #SurveyAnswers
	(AnswerId INT, Answer VARCHAR(1000), AnswerText VARCHAR(1000))
	INSERT INTO #SurveyAnswers
	(AnswerId, Answer, AnswerText)
	SELECT 
		AnswerId, Answer, AnswerText
	FROM DBO.TR_SurveyAnswers
	WHERE QuestionId = @QuestionId
		
	DECLARE @QuestionSkipLogic VARCHAR(50)
	SET @QuestionSkipLogic = 'Question('+CONVERT(VARCHAR(12),@QuestionId)+')'
	
	--IF EXISTS(SELECT 1 FROM DBO.TR_SkipLogic WHERE LogicExpression LIKE '%'+@QuestionSkipLogic+'%' )
	--BEGIN
	--	SELECT 0 AS RetValue, 'Answer Is Already In Use' AS Remark
	--	RETURN
	--END
	
	--IF EXISTS(SELECT 1 FROM DBO.TR_MediaSkipLogic WHERE LogicExpression LIKE '%'+@QuestionSkipLogic+'%')
	--BEGIN
	--	SELECT 0 AS RetValue, 'Answer Is Already In Use' AS Remark
	--	RETURN
	--END
	
	--IF EXISTS(SELECT 1 FROM DBO.TR_Responses TR INNER JOIN #SurveyAnswers SA ON TR.AnswerId = SA.AnswerId)
	--BEGIN
	--	SELECT 0 AS RetValue, 'Answer Is Already In Use' AS Remark
	--	RETURN
	--END
	
	BEGIN TRAN
	
	DECLARE @RowId INT
	SET @RowId = 0
	
	IF EXISTS(SELECT 1 FROM DBO.TR_SurveyAnswers WHERE QuestionId = @QuestionId)
	BEGIN
				
		DELETE FROM DBO.TR_SurveyAnswers WHERE QuestionId = @QuestionId
	
		SET @RowId = @@ROWCOUNT
	
		SELECT 
				CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
				CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Delete Failed' ELSE 'Successfully Deleted' END AS Remark
	END
	ELSE
	BEGIN
		SELECT 1 AS RetValue, 'No data found' AS Remark
	END	 
	DROP TABLE #SurveyAnswers
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
