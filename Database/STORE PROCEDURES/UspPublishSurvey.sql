IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspPublishSurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspPublishSurvey]

GO
-- EXEC UspPublishSurvey 1160

CREATE PROCEDURE DBO.UspPublishSurvey
	@SurveyId INT,
	@RenderMode VARCHAR(1),
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN	

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
	
	DECLARE @UserId INT
	SELECT @UserId = CONVERT(INT,UserId) FROM @UserInfo
	
	-- DBO.PB_TR_Survey
	
	UPDATE DBO.TR_Survey SET PublishStatus = 'I' WHERE SurveyId = @SurveyId AND @RenderMode = 'R'/*P-Preview, R-Render*/
	
	DELETE FROM DBO.PB_TR_Survey WHERE SurveyId = @SurveyId

	INSERT INTO DBO.PB_TR_Survey
	(
		SurveyId,SurveyName,CustomerId,StarMarked,RewardEnabled,CreatedBy,CreatedDate,ModifiedBy,
		ModifiedDate,IsActive,StatusId,CategoryId,LanguageId,SurveyEndDate
	)
	SELECT  
		SurveyId,SurveyName,CustomerId,StarMarked,RewardEnabled,CreatedBy,CreatedDate,ModifiedBy,
		ModifiedDate,IsActive,StatusId,CategoryId,LanguageId,SurveyEndDate
	FROM DBO.TR_Survey WHERE SurveyId = @SurveyId 

	-- DBO.PB_TR_SurveyQuestions
	DELETE FROM  DBO.PB_TR_SurveyQuestions  WHERE SurveyId = @SurveyId
	
	INSERT INTO DBO.PB_TR_SurveyQuestions 
	(QuestionId,SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted,DefaultAnswerId,QuestionNo)
	SELECT QuestionId,SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted,DefaultAnswerId,QuestionNo
	FROM DBO.TR_SurveyQuestions  WHERE SurveyId = @SurveyId AND IsDeleted = 1			 

	-- DBO.PB_TR_SurveyAnswers
	DELETE TSA FROM DBO.PB_TR_SurveyAnswers TSA
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TSA.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId 
	
	INSERT INTO DBO.PB_TR_SurveyAnswers
	(AnswerId,QuestionId,Answer,AnswerText)
	SELECT TSA.AnswerId,TSA.QuestionId,TSA.Answer,TSA.AnswerText FROM DBO.TR_SurveyAnswers TSA
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TSA.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId AND TSQ.IsDeleted = 1
	
	-- DBO.PB_TR_SurveyQuota
	DELETE FROM DBO.PB_TR_SurveyQuota WHERE SurveyId = @SurveyId

	INSERT INTO DBO.PB_TR_SurveyQuota
	(SurveyId,QuotaId,Limit)
	SELECT SurveyId,QuotaId,Limit FROM DBO.TR_SurveyQuota WHERE SurveyId = @SurveyId
	
	-- DBO.PB_TR_SurveySettings
	DELETE FROM DBO.PB_TR_SurveySettings WHERE SurveyId = @SurveyId

	INSERT INTO DBO.PB_TR_SurveySettings 
	(SurveyId,SettingId,CustomerId,Value)
	SELECT SurveyId,SettingId,CustomerId,Value FROM DBO.TR_SurveySettings WHERE SurveyId = @SurveyId
	
	-- DBO.PB_TR_SkipLogic
	DELETE TSL 
	FROM DBO.PB_TR_SkipLogic TSL
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TSL.BranchId = MQB.BranchId AND MQB.SurveyId = @SurveyId AND MQB.BranchType = 'Skip'
	
	INSERT INTO DBO.PB_TR_SkipLogic 
	(LogicExpression, Conjunction, BranchId, PreviousQuestionId)
	SELECT 
		TSL.LogicExpression, TSL.Conjunction, TSL.BranchId, TSL.PreviousQuestionId 
	FROM DBO.TR_SkipLogic TSL
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TSL.BranchId = MQB.BranchId AND MQB.SurveyId = @SurveyId AND MQB.BranchType = 'Skip'
	
	-- DBO.PB_TR_QuestionSettings
	DELETE TQS FROM DBO.PB_TR_QuestionSettings TQS 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQS.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId 
	 
	INSERT INTO DBO.PB_TR_QuestionSettings
	(QuestionId,SettingId,Value)
	SELECT TQS.QuestionId,TQS.SettingId,TQS.Value FROM DBO.TR_QuestionSettings TQS 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQS.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId AND TSQ.IsDeleted = 1
	
	-- DBO.PB_TR_QuestionQuota 
	DELETE TQQ FROM DBO.PB_TR_QuestionQuota TQQ
	INNER JOIN DBO.MS_QuestionBranches MQB ON TQQ.BranchId = MQB.BranchId AND MQB.BranchType = 'Quota'
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON MQB.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId 
	
	INSERT INTO DBO.PB_TR_QuestionQuota 
	(QuotaId,LogicExpression,Conjunction,BranchId,PreviousQuestionId)
	SELECT TQQ.QuotaId,TQQ.LogicExpression,TQQ.Conjunction,MQB.BranchId, TQQ.PreviousQuestionId 
	FROM DBO.TR_QuestionQuota TQQ
	INNER JOIN DBO.MS_QuestionBranches MQB ON TQQ.BranchId = MQB.BranchId AND MQB.BranchType = 'Quota'
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON MQB.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId AND TSQ.IsDeleted = 1
	
	-- DBO.PB_TR_MediaSkipLogic
	DELETE TMSL FROM DBO.PB_TR_MediaSkipLogic TMSL
	INNER JOIN DBO.MS_QuestionBranches MQB ON TMSL.BranchId = MQB.BranchId AND MQB.BranchType = 'Media'
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON MQB.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId 
	
	INSERT INTO DBO.PB_TR_MediaSkipLogic
	(LogicExpression,Conjunction,BranchId,PreviousQuestionId)
	SELECT TMSL.LogicExpression,TMSL.Conjunction,TMSL.BranchId, TMSL.PreviousQuestionId FROM DBO.TR_MediaSkipLogic TMSL
	INNER JOIN DBO.MS_QuestionBranches MQB ON TMSL.BranchId = MQB.BranchId AND MQB.BranchType = 'Media'
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON MQB.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId AND TSQ.IsDeleted = 1
	
	-- DBO.PB_TR_EmailTrigger
	DELETE TET FROM DBO.PB_TR_EmailTrigger TET
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TET.BranchId = MQB.BranchId AND MQB.SurveyId = @SurveyId AND MQB.BranchType = 'Email'
	
	INSERT INTO DBO.PB_TR_EmailTrigger
	(TriggerExpression, Conjunction, BranchId, PreviousQuestionId)
	SELECT 
		TET.TriggerExpression, TET.Conjunction, TET.BranchId, TET.PreviousQuestionId
	FROM DBO.TR_EmailTrigger TET
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TET.BranchId = MQB.BranchId AND MQB.SurveyId = @SurveyId AND MQB.BranchType = 'Email'
	----------------------------------------------------
	
	UPDATE DBO.TR_Survey SET PublishStatus = 'P' WHERE SurveyId = @SurveyId AND @RenderMode = 'R'/*P-Preview, R-Render*/
	
	INSERT INTO DBO.Audit_PublishSurvey
	(SurveyId, PublishedBy, PublishedDate)
	SELECT @SurveyId, @UserId, GETDATE()
	
	SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark
	 
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END