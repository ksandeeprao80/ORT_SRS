IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCopySurveyQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspCopySurveyQuestions]

GO
--	EXEC UspCopySurveyQuestions 13585
CREATE PROCEDURE DBO.UspCopySurveyQuestions
	@QuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @SurveyId INT
	DECLARE @QuestionNo INT
	
	SELECT @SurveyId = SurveyId, @QuestionNo = QuestionNo 
	FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId 
	
	UPDATE DBO.TR_SurveyQuestions
	SET QuestionNo = QuestionNo+2
	WHERE SurveyId = @SurveyId AND QuestionNo > @QuestionNo 
	
	INSERT INTO DBO.TR_SurveyQuestions 
	(SurveyId, CustomerId, QuestionTypeId, QuestionText, IsDeleted, DefaultAnswerId, QuestionNo)
	SELECT 
		DISTINCT SurveyId, CustomerId, 4 AS QuestionTypeId, '' AS QuestionText, 
		1 AS IsDeleted, NULL AS DefaultAnswerId, @QuestionNo+1
	FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId 
	
	DECLARE @NewQuestionId INT
	
	INSERT INTO DBO.TR_SurveyQuestions 
	(SurveyId, CustomerId, QuestionTypeId, QuestionText, IsDeleted, DefaultAnswerId, QuestionNo)
	SELECT 
		SurveyId, CustomerId, QuestionTypeId, QuestionText, IsDeleted, DefaultAnswerId, @QuestionNo+2
	FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId 
	
	SET @NewQuestionId = @@IDENTITY

	DECLARE @OldNewAnswerTable TABLE
	(QuestionId INT, NewQuestionId INT, AnswerId INT, Answer VARCHAR(1000), NewAnswerId INT)
	INSERT INTO @OldNewAnswerTable
	(QuestionId, NewQuestionId, AnswerId, Answer)	
	SELECT 
		QuestionId, @NewQuestionId, AnswerId, Answer  
	FROM TR_SurveyAnswers WHERE QuestionId = @QuestionId 
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId, Answer, AnswerText)
	SELECT 
		@NewQuestionId, Answer, AnswerText
	FROM DBO.TR_SurveyAnswers
	WHERE QuestionId = @QuestionId 
	
	UPDATE ONAT
	SET ONAT.NewAnswerId = TSA.AnswerId 
	FROM @OldNewAnswerTable ONAT
	INNER JOIN DBO.TR_SurveyAnswers TSA
		ON TSA.QuestionId = ONAT.NewQuestionId
		AND TSA.Answer = ONAT.Answer

	INSERT INTO DBO.TR_QuestionSettings
	(QuestionId, SettingId, Value)
	SELECT 
		@NewQuestionId, SettingId, Value
	FROM DBO.TR_QuestionSettings 
	WHERE QuestionId = @QuestionId 
	
	IF EXISTS(SELECT 1 FROM TR_QuestionFollowUpMap WHERE QuestionId = @QuestionId)
	BEGIN
		INSERT INTO TR_QuestionFollowUpMap
		(QuestionId, FollowUpQuestionId)
		SELECT 
			@NewQuestionId, FollowUpQuestionId 
		FROM TR_QuestionFollowUpMap WHERE QuestionId = @QuestionId
	END

	IF EXISTS(SELECT 1 FROM DBO.MS_QuestionBranches WHERE QuestionId = @QuestionId)
	BEGIN
		UPDATE DBO.MS_QuestionBranches SET OldBranchId = NULL WHERE SurveyId = @SurveyId
		
		INSERT INTO DBO.MS_QuestionBranches
		(
			BranchType, TrueAction, FalseAction, SurveyId, QuestionId, 
			SendAtEnd, MessageLibId, EmailDetailId, OldBranchId
		)
		SELECT 
			BranchType, TrueAction, REPLACE(FalseAction,CONVERT(VARCHAR(12),@QuestionId),CONVERT(VARCHAR(12),@NewQuestionId)), 
			SurveyId, @NewQuestionId AS QuestionId, SendAtEnd, MessageLibId, EmailDetailId, BranchId AS OldBranchId
		FROM DBO.MS_QuestionBranches WHERE QuestionId = @QuestionId

		INSERT INTO DBO.TR_QuestionQuota
		(LogicExpression, Conjunction, BranchId, PreviousQuestionId)
		SELECT 
			REPLACE(TQQ.LogicExpression,CONVERT(VARCHAR(20),ONAT.AnswerId),CONVERT(VARCHAR(20),ONAT.NewAnswerId)), 
			TQQ.Conjunction, MQB.BranchId, TQQ.PreviousQuestionId 
		FROM TR_QuestionQuota TQQ
		INNER JOIN DBO.MS_QuestionBranches MQB
			ON TQQ.BranchId = MQB.OldBranchId
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON MQB.QuestionId = TSQ.QuestionId
			AND TSQ.QuestionId = @NewQuestionId	
		INNER JOIN @OldNewAnswerTable ONAT
			ON TQQ.LogicExpression LIKE '%'+'AnswerId('+CONVERT(VARCHAR(20),ONAT.AnswerId)+'%'
		WHERE MQB.BranchType = 'Quota'	

		INSERT INTO DBO.TR_SkipLogic
		(LogicExpression, Conjunction, BranchId, PreviousQuestionId)	
		SELECT 
			REPLACE(REPLACE(TSL.LogicExpression,'Answer('+CONVERT(VARCHAR(12),ONAT.AnswerId),'Answer('+CONVERT(VARCHAR(12),ONAT.NewAnswerId)),'Question('+CONVERT(VARCHAR(12),@QuestionId),'Question('+CONVERT(VARCHAR(12),@NewQuestionId)),
			TSL.Conjunction, MQB.BranchId, TSL.PreviousQuestionId
		FROM DBO.TR_SkipLogic TSL
		INNER JOIN DBO.MS_QuestionBranches MQB
			ON TSL.BranchId = MQB.OldBranchId
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON MQB.QuestionId = TSQ.QuestionId
			AND TSQ.QuestionId = @NewQuestionId	
		LEFT OUTER JOIN @OldNewAnswerTable ONAT
			ON TSL.LogicExpression LIKE '%'+'Answer('+CONVERT(VARCHAR(20),ONAT.AnswerId)+'%'
		WHERE MQB.BranchType = 'Skip'
			AND TSL.LogicExpression LIKE '%'+'Question('+CONVERT(VARCHAR(20),TSQ.QuestionId)+'%'
		
		INSERT INTO DBO.TR_MediaSkipLogic
		(LogicExpression, Conjunction, BranchId, PreviousQuestionId)
		SELECT 
			REPLACE(REPLACE(TMSL.LogicExpression,'Answer('+CONVERT(VARCHAR(12),ONAT.AnswerId),'Answer('+CONVERT(VARCHAR(12),ONAT.NewAnswerId)),'Question('+CONVERT(VARCHAR(12),@QuestionId),'Question('+CONVERT(VARCHAR(12),@NewQuestionId)),
			TMSL.Conjunction, MQB.BranchId, TMSL.PreviousQuestionId
		FROM DBO.TR_MediaSkipLogic TMSL
		INNER JOIN DBO.MS_QuestionBranches MQB
			ON TMSL.BranchId = MQB.OldBranchId
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON MQB.QuestionId = TSQ.QuestionId
			AND TSQ.QuestionId = @NewQuestionId	
		LEFT OUTER JOIN @OldNewAnswerTable ONAT
			ON TMSL.LogicExpression LIKE '%'+'Answer('+CONVERT(VARCHAR(20),ONAT.AnswerId)+'%'
		WHERE MQB.BranchType = 'Media'
			AND TMSL.LogicExpression LIKE '%'+'Question('+CONVERT(VARCHAR(20),TSQ.QuestionId)+'%'

		INSERT INTO DBO.TR_EmailTrigger
		(TriggerExpression, Conjunction, BranchId, PreviousQuestionId)	
		SELECT 
			REPLACE(REPLACE(TET.TriggerExpression,'Answer('+CONVERT(VARCHAR(12),ONAT.AnswerId),'Answer('+CONVERT(VARCHAR(12),ONAT.NewAnswerId)),'Question('+CONVERT(VARCHAR(12),@QuestionId),'Question('+CONVERT(VARCHAR(12),@NewQuestionId)),
			TET.Conjunction, MQB.BranchId, TET.PreviousQuestionId
		FROM DBO.TR_EmailTrigger TET
		INNER JOIN DBO.MS_QuestionBranches MQB
			ON TET.BranchId = MQB.OldBranchId
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON MQB.QuestionId = TSQ.QuestionId
			AND TSQ.QuestionId = @NewQuestionId	
		LEFT OUTER JOIN @OldNewAnswerTable ONAT
			ON TET.TriggerExpression LIKE '%'+'Answer('+CONVERT(VARCHAR(20),ONAT.AnswerId)+'%'
		WHERE MQB.BranchType = 'Email'
			AND TET.TriggerExpression LIKE '%'+'Question('+CONVERT(VARCHAR(20),TSQ.QuestionId)+'%'
	END

	SELECT 
		CASE WHEN ISNULL(@NewQuestionId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@NewQuestionId,0) = 0 THEN 'Question Copy Failed...' ELSE 'Question Copied Successfully' END AS RetValue,
		ISNULL(@NewQuestionId,0) AS NewQuestionId
		
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END


