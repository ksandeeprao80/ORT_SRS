IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCanDeleteQuestion]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspCanDeleteQuestion]

GO

--EXEC UspCanDeleteQuestion 13507
CREATE PROCEDURE DBO.UspCanDeleteQuestion
	@QuestionId INT  
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @SurveyId INT
	DECLARE @QuestionNo INT
	DECLARE @Count INT
	SET @Count = 0
	
	SELECT @SurveyId = SurveyId, @QuestionNo = QuestionNo FROM TR_SurveyQuestions WHERE QuestionId = @QuestionId

	SELECT @Count = COUNT(1) FROM TR_SurveyQuestions 
	WHERE SurveyId = @SurveyId 
		AND QuestionNo > @QuestionNo
		AND QuestionText LIKE '%'+'PIPE{Q#'+CONVERT(VARCHAR(12),@QuestionNo)+'}'+'%'
		
	DECLARE @listStr VARCHAR(100)
		
	SELECT @listStr = COALESCE(@listStr+',' ,'') + CONVERT(VARCHAR(12),QuestionNo)
	FROM TR_SurveyQuestions 
	WHERE SurveyId = @SurveyId 
		AND QuestionNo > @QuestionNo
		AND QuestionText LIKE '%'+'PIPE{Q#'+CONVERT(VARCHAR(12),@QuestionNo)+'}'+'%'
		
	SELECT CASE WHEN ISNULL(@Count,0)= 0 THEN 1 ELSE 0 END AS RetValue, 
		CASE WHEN ISNULL(@Count,0)= 0 THEN 'Not Exist' 
			ELSE 'WARNING: This question''s answer been piped-in to the following questions: '+ 
				@listStr + ' .Are you sure you want to proceed? After deletion,	be sure to manually remove the pipe-in references from these questions.' END AS Remark 
		 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
