	SELECT * INTO TR_SkipLogic_Backup_20130312 FROM TR_SkipLogic
	SELECT * INTO TR_EmailTrigger_Backup_20130312 FROM TR_EmailTrigger
	SELECT * INTO TR_QuestionQuota_Backup_20130312 FROM TR_QuestionQuota
	SELECT * INTO TR_MediaSkipLogic_Backup_20130312 FROM TR_MediaSkipLogic

	ALTER TABLE DBO.TR_SkipLogic ADD Conjunction VARCHAR(20), BranchId INT, PreviousQuestionId INT  
	ALTER TABLE DBO.PB_TR_SkipLogic ADD Conjunction VARCHAR(20), BranchId INT, PreviousQuestionId INT 
	ALTER TABLE DBO.TR_EmailTrigger ADD Conjunction VARCHAR(20),BranchId INT, PreviousQuestionId INT 
	ALTER TABLE DBO.PB_TR_EmailTrigger ADD Conjunction VARCHAR(20),BranchId INT, PreviousQuestionId INT 
	ALTER TABLE DBO.TR_QuestionQuota ADD Conjunction VARCHAR(20),BranchId INT, PreviousQuestionId INT 
	ALTER TABLE DBO.PB_TR_QuestionQuota ADD Conjunction VARCHAR(20),BranchId INT, PreviousQuestionId INT 
	ALTER TABLE DBO.TR_MediaSkipLogic ADD Conjunction VARCHAR(20),BranchId INT, PreviousQuestionId INT 
	ALTER TABLE DBO.PB_TR_MediaSkipLogic ADD Conjunction VARCHAR(20),BranchId INT, PreviousQuestionId INT 


-- PreviousQuestionId

	INSERT INTO DBO.MS_QuestionBranches
	(BranchType,TrueAction,FalseAction,SurveyId,QuestionId)
	SELECT 
		'Skip' AS BranchType, TrueAction, FalseAction, SurveyId, FalseAction AS QuestionId 
	FROM TR_SkipLogic 

	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, TrueAction, FalseAction, SurveyId, QuestionId, SendAtEnd, MessageLibId, EmailDetailId)
	SELECT 
		'Email' AS BranchType, TET.TrueAction, TET.FalseAction, TSQ.SurveyId, TET.QuestionId, 
		TET.SendAtEnd, TET.MessageLibId, TET.EmailDetailId
	FROM TR_EmailTrigger TET
	INNER JOIN TR_SurveyQuestions TSQ
		ON TET.QuestionId = TSQ.QuestionId

	INSERT INTO DBO.MS_QuestionBranches
	(BranchType,FalseAction,SurveyId,QuestionId)
	SELECT 
		'Quota' AS BranchType, TQQ.FalseAction, TSQ.SurveyId, TQQ.QuestionId 
	FROM TR_QuestionQuota TQQ
	INNER JOIN TR_SurveyQuestions TSQ
		ON TQQ.QuestionId = TSQ.QuestionId 

	INSERT INTO DBO.MS_QuestionBranches
	(BranchType,TrueAction,FalseAction,SurveyId,QuestionId)
	SELECT 
		'Media' AS BranchType, TMSC.TrueAction, TMSC.FalseAction, TSQ.SurveyId, TMSC.QuestionId 
	FROM TR_MediaSkipLogic TMSC
	INNER JOIN TR_SurveyQuestions TSQ
		ON TMSC.QuestionId = TSQ.QuestionId


	UPDATE TQQ
	SET TQQ.BranchId = MQB.BranchId
	FROM TR_QuestionQuota TQQ
	INNER JOIN DBO.MS_QuestionBranches MQB
	ON TQQ.QuestionId = MQB.QuestionId  
	WHERE MQB.BranchType = 'Quota'

	UPDATE TQQ
	SET TQQ.BranchId = MQB.BranchId
	FROM PB_TR_QuestionQuota TQQ
	INNER JOIN DBO.MS_QuestionBranches MQB
	ON TQQ.QuestionId = MQB.QuestionId  
	WHERE MQB.BranchType = 'Quota'


	--UPDATE MS_QuestionBranches
	--SET BranchName = BranchType+CONVERT(VARCHAR(12),BranchId)

	--SELECT DISTINCT TET.BranchId, MQB.BranchId
	UPDATE TET
	SET TET.BranchId = MQB.BranchId
	FROM TR_EmailTrigger TET
	INNER JOIN MS_QuestionBranches MQB
		ON TET.TrueAction = MQB.TrueAction
		AND ISNULL(TET.FalseAction,'') = ISNULL(MQB.FalseAction,'')
		AND TET.QuestionId = MQB.QuestionId
		AND TET.BranchId IS NULL
	WHERE MQB.BranchType = 'Email'
		
		
	UPDATE TET
	SET TET.BranchId = MQB.BranchId
	FROM PB_TR_EmailTrigger TET
	INNER JOIN MS_QuestionBranches MQB
		ON TET.TrueAction = MQB.TrueAction
		AND ISNULL(TET.FalseAction,'') = ISNULL(MQB.FalseAction,'')
		AND TET.QuestionId = MQB.QuestionId
		AND TET.BranchId IS NULL	
	WHERE MQB.BranchType = 'Email'

	--SELECT DISTINCT TST.BranchId, MQB.BranchId
	UPDATE TST
	SET TST.BranchId = MQB.BranchId
	FROM TR_SkipLogic TST
	INNER JOIN MS_QuestionBranches MQB
		ON TST.TrueAction = MQB.TrueAction
		AND TST.FalseAction = MQB.FalseAction
		AND TST.SurveyId = MQB.SurveyId
		AND TST.BranchId IS NULL
	WHERE MQB.BranchType = 'Skip'	
		
	UPDATE TST
	SET TST.BranchId = MQB.BranchId
	FROM PB_TR_SkipLogic TST
	INNER JOIN MS_QuestionBranches MQB
		ON TST.TrueAction = MQB.TrueAction
		AND TST.FalseAction = MQB.FalseAction
		AND TST.SurveyId = MQB.SurveyId
		AND TST.BranchId IS NULL
	WHERE MQB.BranchType = 'Skip'	
	
	UPDATE TMSC
	SET TMSC.BranchId = MQB.BranchId
	FROM TR_MediaSkipLogic TMSC
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TMSC.QuestionId = MQB.QuestionId  
	WHERE MQB.BranchType = 'Media'

	UPDATE TMSC
	SET TMSC.BranchId = MQB.BranchId
	FROM PB_TR_MediaSkipLogic TMSC
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TMSC.QuestionId = MQB.QuestionId  
	WHERE MQB.BranchType = 'Media'

	ALTER TABLE TR_SkipLogic DROP CONSTRAINT FK_TR_SkipLogic_TR_Survey
	DROP INDEX TR_SkipLogic.IX_TR_SkipLogic_SurveyId
	DROP INDEX PB_TR_SkipLogic.IX_PB_TR_SkipLogic
	ALTER TABLE TR_EmailTrigger DROP CONSTRAINT FK_TR_Email_Trigger_TR_Survey_Questions
	DROP INDEX PB_TR_QuestionQuota.IX_PB_TR_QuestionQuota
	
	ALTER TABLE TR_MediaSkipLogic DROP CONSTRAINT FK_TR_MediaSkipLogic_TR_SurveyQuestions
	DROP INDEX TR_MediaSkipLogic.IX_TR_MediaSkipLogic_QuestionId
	DROP INDEX PB_TR_MediaSkipLogic.IX_PB_TR_MediaSkipLogic

	-----------------------------------------------------------
	ALTER TABLE TR_EmailTrigger DROP COLUMN QuestionId
	ALTER TABLE TR_EmailTrigger DROP COLUMN TrueAction
	ALTER TABLE TR_EmailTrigger DROP COLUMN FalseAction
	ALTER TABLE TR_EmailTrigger DROP COLUMN SendAtEnd
	ALTER TABLE TR_EmailTrigger DROP COLUMN MessageLibId
	ALTER TABLE TR_EmailTrigger DROP COLUMN EmailDetailId

	ALTER TABLE PB_TR_EmailTrigger DROP COLUMN QuestionId
	ALTER TABLE PB_TR_EmailTrigger DROP COLUMN TrueAction
	ALTER TABLE PB_TR_EmailTrigger DROP COLUMN FalseAction
	ALTER TABLE PB_TR_EmailTrigger DROP COLUMN SendAtEnd
	ALTER TABLE PB_TR_EmailTrigger DROP COLUMN MessageLibId
	ALTER TABLE PB_TR_EmailTrigger DROP COLUMN EmailDetailId
	-----------------------------------------------------------
	ALTER TABLE PB_TR_SkipLogic DROP COLUMN TrueAction
	ALTER TABLE PB_TR_SkipLogic DROP COLUMN FalseAction
	ALTER TABLE PB_TR_SkipLogic DROP COLUMN SurveyId

	ALTER TABLE TR_SkipLogic DROP COLUMN TrueAction
	ALTER TABLE TR_SkipLogic DROP COLUMN FalseAction
	ALTER TABLE TR_SkipLogic DROP COLUMN SurveyId
	-----------------------------------------------------------
	ALTER TABLE TR_QuestionQuota DROP COLUMN QuestionId
	ALTER TABLE TR_QuestionQuota DROP COLUMN FalseAction
	 
	ALTER TABLE PB_TR_QuestionQuota DROP COLUMN QuestionId
	ALTER TABLE PB_TR_QuestionQuota DROP COLUMN FalseAction
 	-----------------------------------------------------------
 	
 	ALTER TABLE TR_MediaSkipLogic DROP COLUMN TrueAction
	ALTER TABLE TR_MediaSkipLogic DROP COLUMN FalseAction
	ALTER TABLE TR_MediaSkipLogic DROP COLUMN QuestionId
	 
	ALTER TABLE PB_TR_MediaSkipLogic DROP COLUMN TrueAction
	ALTER TABLE PB_TR_MediaSkipLogic DROP COLUMN FalseAction
	ALTER TABLE PB_TR_MediaSkipLogic DROP COLUMN QuestionId

