IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspReOrderQuestion]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspReOrderQuestion]
GO
-- EXEC UspReOrderQuestion 8924,'Before',8932 
-- EXEC UspReOrderQuestion 8935,'Before',8927 
-- EXEC UspReOrderQuestion 8926,'After',8937 
-- EXEC UspReOrderQuestion 8933,'After',8921 

CREATE PROCEDURE DBO.UspReOrderQuestion
	@QuestionId INT,
	@Position VARCHAR(10),
	@TargetQuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	IF ISNULL(@Position,'') = '' 
	BEGIN
		SELECT 0 AS RetValue, 'Invalid Record' AS Remark
	END
	ELSE
	BEGIN
		DECLARE @SurveyId INT
		DECLARE @QuestionNo INT
		DECLARE @TargetQuestionNo INT
		SELECT @SurveyId = SurveyId, @QuestionNo = ISNULL(QuestionNo,0) FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId
		SELECT @TargetQuestionNo = ISNULL(QuestionNo,0) FROM DBO.TR_SurveyQuestions WHERE QuestionId = @TargetQuestionId
		
		IF @Position = 'Before'
		BEGIN
			IF @QuestionNo < @TargetQuestionNo
			BEGIN
				UPDATE DBO.TR_SurveyQuestions
				SET QuestionNo = QuestionNo-1
				WHERE SurveyId = @SurveyId
					AND QuestionNo > @QuestionNo 
					AND QuestionNo < @TargetQuestionNo
					AND IsDeleted = 1
				
				UPDATE DBO.TR_SurveyQuestions
				SET QuestionNo = @TargetQuestionNo-1
				WHERE QuestionId = @QuestionId
					AND IsDeleted = 1
			END
			
			IF @QuestionNo > @TargetQuestionNo
			BEGIN
			
				UPDATE DBO.TR_SurveyQuestions
				SET QuestionNo = QuestionNo+1
				WHERE SurveyId = @SurveyId
					AND QuestionNo >= @TargetQuestionNo 
					AND QuestionNo < @QuestionNo
					AND IsDeleted = 1
				
				UPDATE DBO.TR_SurveyQuestions
				SET QuestionNo = @TargetQuestionNo
				WHERE QuestionId = @QuestionId
			END
		END
		
		IF @Position = 'After'
		BEGIN
			IF @QuestionNo < @TargetQuestionNo
			BEGIN
				UPDATE DBO.TR_SurveyQuestions
				SET QuestionNo = QuestionNo-1
				WHERE SurveyId = @SurveyId
					AND QuestionNo > @QuestionNo 
					AND QuestionNo <= @TargetQuestionNo
					AND IsDeleted = 1
				
				UPDATE DBO.TR_SurveyQuestions
				SET QuestionNo = @TargetQuestionNo
				WHERE QuestionId = @QuestionId
			END
			
			IF @QuestionNo > @TargetQuestionNo
			BEGIN
				UPDATE DBO.TR_SurveyQuestions
				SET QuestionNo = QuestionNo+1
				WHERE SurveyId = @SurveyId
					AND QuestionNo > @TargetQuestionNo 
					AND QuestionNo < @QuestionNo
					AND IsDeleted = 1
				
				UPDATE DBO.TR_SurveyQuestions
				SET QuestionNo = @TargetQuestionNo+1
				WHERE QuestionId = @QuestionId
			
			END
		END
	END
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_QuestionSettings 
		WHERE SettingId = 32 AND LTRIM(RTRIM(Value)) = CONVERT(VARCHAR(12),@QuestionId)
	)
	BEGIN 
		DECLARE @FollowupQuestionId INT
		DECLARE @mtbquestionNo INT

		SELECT @FollowupQuestionId = Questionid FROM DBO.TR_QuestionSettings
		WHERE SettingId = 32 AND LTRIM(RTRIM(Value)) = CONVERT(VARCHAR(12),@QuestionId)

		SELECT @mtbquestionNo = QuestionNo FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId

		UPDATE DBO.TR_SurveyQuestions SET QuestionNo = @mtbquestionNo WHERE QuestionId = @FollowupQuestionId
	END
	
	
	SELECT 1 AS RetValue, 'Successfully Updated' AS Remark 
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

