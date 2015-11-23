IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSurveyQuestion]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteSurveyQuestion]
GO

-- EXEC UspDeleteSurveyQuestion 8929

CREATE PROCEDURE DBO.UspDeleteSurveyQuestion
	@QuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	IF ISNULL(@QuestionId,0) = 0
	BEGIN
		SELECT 0 AS RetValue, 'Question Id is Blank' AS Remark
	END
	ELSE
	BEGIN 
		DELETE TSL 
		FROM DBO.TR_SkipLogic TSL 
		INNER JOIN DBO.MS_QuestionBranches MQB
			ON TSL.BranchId = MQB.BranchId AND MQB.QuestionId = @QuestionId AND MQB.BranchType = 'Skip'

		DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @QuestionId AND BranchType = 'Skip'
		
		--QuestionQuota
		DELETE TQQ
		FROM DBO.TR_QuestionQuota TQQ 
		INNER JOIN DBO.MS_QuestionBranches MQB
			ON TQQ.BranchId = MQB.BranchId AND MQB.QuestionId = @QuestionId AND MQB.BranchType = 'Quota' 

		DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @QuestionId AND BranchType = 'Quota'
		
		--TR_EmailTrigger 
		DELETE TET FROM DBO.TR_EmailTrigger TET 
		INNER JOIN DBO.MS_QuestionBranches MQB 
			ON TET.BranchId = MQB.BranchId AND MQB.QuestionId = @QuestionId AND MQB.BranchType = 'Email'
		DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @QuestionId AND BranchType = 'Email'
		-- TR_EmailTrigger--
		
		DELETE FROM DBO.TR_EmailDetails WHERE QuestionId = @QuestionId
		DELETE FROM DBO.TR_MediaInfo WHERE QuestionId = @QuestionId
		
		--MediaSkipLogic
		DELETE TMSL FROM DBO.TR_MediaSkipLogic TMSL 
		INNER JOIN DBO.MS_QuestionBranches MQB 
			ON TMSL.BranchId = MQB.BranchId AND MQB.QuestionId = @QuestionId AND MQB.BranchType = 'Media'
		DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @QuestionId AND BranchType = 'Media'
		--MediaSkipLogic
		
		DELETE FROM DBO.TR_QuestionSettings WHERE QuestionId = @QuestionId
		DELETE FROM DBO.TR_Responses WHERE QuestionId = @QuestionId
		DELETE FROM DBO.TR_SurveyAnswers WHERE QuestionId = @QuestionId
		
		DECLARE @SurveyId INT
		DECLARE @QuestionNo INT
		
		SELECT @SurveyId= SurveyId, @QuestionNo = QuestionNo FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId	

		DECLARE @RowId INT
		SET @RowId = 0
		
		DELETE FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId
		
		SET @RowId = @@ROWCOUNT

		IF @RowId <> 0
		BEGIN
			UPDATE DBO.TR_SurveyQuestions
			SET QuestionNo = QuestionNo-1
			WHERE SurveyId = @SurveyId
				AND QuestionNo > @QuestionNo
		END
			
		SELECT CASE WHEN ISNULL(@RowId,0)= 0 THEN 0 ELSE 1 END AS RetValue, 
				CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Delete Failed' ELSE 'Successfully Deleted' END AS Remark
	END

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

