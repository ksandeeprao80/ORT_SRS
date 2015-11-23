IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCleanUpSurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspCleanUpSurvey]
GO

-- EXEC UspCleanUpSurvey 2002

CREATE PROCEDURE DBO.UspCleanUpSurvey
	@SurveyId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DELETE TRQ FROM DBO.TR_ReportQuestions TRQ
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TRQ.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId
	
	DELETE FROM DBO.TR_TrendPerceptFilter WHERE FilterId IN(SELECT FilterId FROM DBO.MS_TrendPerceptFilter WHERE SurveyId = @SurveyId)

	DELETE FROM DBO.MS_TrendPerceptFilter WHERE SurveyId = @SurveyId

	DELETE FROM DBO.TR_TrendOptionMapping WHERE TrendId IN(SELECT TrendId FROM DBO.TR_Trends WHERE SurveyId = @SurveyId OR BaseSurveyId =  @SurveyId)

	DELETE FROM DBO.TR_TrendCrossTabs WHERE BaseSurveyId = @SurveyId	 

	DELETE FROM DBO.TR_Trends WHERE SurveyId = @SurveyId OR BaseSurveyId = @SurveyId

	DELETE FROM DBO.Trail_ReportAnalysis  WHERE SurveyId = @SurveyId

	DELETE FROM DBO.TR_ReportAnalysis  WHERE SurveyId = @SurveyId

	DELETE TRQM FROM DBO.TR_ReportQuestionMapped TRQM
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TRQM.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE TSP FROM DBO.TR_SurveyProgress TSP
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TSP.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE TQFU FROM DBO.TR_QuestionFollowUpMap TQFU
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQFU.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE TETM FROM DBO.TR_EmailTriggerMails TETM
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TETM.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE TRF FROM DBO.TR_ReportFilter TRF 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TRF.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE PTSA FROM DBO.PB_TR_SurveyAnswers PTSA 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON PTSA.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE TSL FROM DBO.PB_TR_SkipLogic TSL 
	INNER JOIN DBO.MS_QuestionBranches MQB ON TSL.BranchId = MQB.BranchId WHERE MQB.SurveyId = @SurveyId
	DELETE TSL FROM DBO.TR_SkipLogic TSL 
	INNER JOIN DBO.MS_QuestionBranches MQB ON TSL.BranchId = MQB.BranchId WHERE MQB.SurveyId = @SurveyId
	
	DELETE TQQ FROM DBO.PB_TR_QuestionQuota TQQ 
	INNER JOIN DBO.MS_QuestionBranches MQB ON TQQ.BranchId = MQB.BranchId WHERE MQB.SurveyId = @SurveyId
	DELETE TQQ FROM DBO.TR_QuestionQuota TQQ 
	INNER JOIN DBO.MS_QuestionBranches MQB ON TQQ.BranchId = MQB.BranchId WHERE MQB.SurveyId = @SurveyId

	DELETE TET FROM DBO.PB_TR_EmailTrigger TET 
	INNER JOIN DBO.MS_QuestionBranches MQB ON TET.BranchId = MQB.BranchId WHERE MQB.SurveyId = @SurveyId
	DELETE TET FROM DBO.TR_EmailTrigger TET 
	INNER JOIN DBO.MS_QuestionBranches MQB ON TET.BranchId = MQB.BranchId WHERE MQB.SurveyId = @SurveyId

	DELETE TED FROM DBO.TR_EmailDetails TED 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TED.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE TMI FROM DBO.TR_MediaInfo TMI
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TMI.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId
 
 	DELETE TMSL FROM DBO.PB_TR_MediaSkipLogic TMSL 
	INNER JOIN DBO.MS_QuestionBranches MQB ON TMSL.BranchId = MQB.BranchId WHERE MQB.SurveyId = @SurveyId
	DELETE TMSL FROM DBO.TR_MediaSkipLogic TMSL 
	INNER JOIN DBO.MS_QuestionBranches MQB ON TMSL.BranchId = MQB.BranchId WHERE MQB.SurveyId = @SurveyId
	 
	DELETE FROM DBO.PB_TR_SurveyQuota WHERE SurveyId = @SurveyId
	
	DELETE FROM DBO.TR_SurveyQuota WHERE SurveyId = @SurveyId
		 
	DELETE FROM DBO.MS_QuestionBranches WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.TR_ReportAnalysis WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.TR_ReportDataSource WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.TR_Respondent_PlayList WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.TR_RespondentReferalCount WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.TR_RespondentReferrels WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.TR_Reward WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.TR_Winner WHERE SurveyId = @SurveyId
	
	DELETE FROM DBO.TR_SurveyBrowserMetaData WHERE SurveyId = @SurveyId
	
	DELETE FROM DBO.TR_SurveyRequestDetails WHERE SurveyId = @SurveyId
	
	DELETE FROM DBO.TR_SurveyLibrary WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.TR_InviteLog WHERE SurveyId = @SurveyId
	
	DELETE TC FROM TR_InviteChannelDetail TC
	INNER JOIN DBO.MS_Invite MI ON MI.InviteId = TC.InviteId WHERE MI.SurveyId = @SurveyId
	
	DELETE TID FROM DBO.TR_InviteDetails TID
	INNER JOIN DBO.TR_Invite TI ON TID.RowId = TI.RowId
	INNER JOIN DBO.MS_Invite MI ON TI.InviteId = MI.InviteId WHERE MI.SurveyId = @SurveyId
		
	DELETE TI FROM DBO.TR_Invite TI 
	INNER JOIN DBO.MS_Invite MI ON TI.InviteId = MI.InviteId WHERE MI.SurveyId = @SurveyId
	
	DELETE FROM DBO.MS_Invite WHERE SurveyId = @SurveyId
	
	DELETE FROM dbo.PB_TR_SurveySettings WHERE SurveyId = @SurveyId
	DELETE FROM dbo.TR_SurveySettings WHERE SurveyId = @SurveyId
	
	DELETE TQS FROM DBO.PB_TR_QuestionSettings TQS
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQS.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId
	DELETE TQS FROM DBO.TR_QuestionSettings TQS
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQS.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId
	
	DELETE FROM dbo.MS_ReportFilter WHERE SurveyId = @SurveyId
	
	DELETE TQS FROM TR_QuestionLibrarySetting TQS
	JOIN TR_QuestionLibrary TQL ON TQS.QuestionLibId = TQL.QuestionLibId
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQL.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId
	
	DELETE TQA FROM TR_QuestionLibraryAnswers TQA
	JOIN TR_QuestionLibrary TQL ON TQA.QuestionLibId = TQL.QuestionLibId
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQL.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId 
	
	DELETE TQL FROM TR_QuestionLibrary TQL
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TQL.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE TR FROM DBO.TR_Responses TR 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId

	DELETE TSA FROM DBO.PB_TR_SurveyAnswers TSA 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TSA.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId
	DELETE TSA FROM DBO.TR_SurveyAnswers TSA 
	INNER JOIN DBO.TR_SurveyQuestions TSQ ON TSA.QuestionId = TSQ.QuestionId WHERE TSQ.SurveyId = @SurveyId
	
	DELETE TSQ FROM DBO.PB_TR_SurveyQuestions TSQ
	INNER JOIN DBO.TR_Survey TS ON TSQ.SurveyId = TS.SurveyId WHERE TSQ.SurveyId = @SurveyId
	DELETE TSQ FROM DBO.TR_SurveyQuestions TSQ
	INNER JOIN DBO.TR_Survey TS ON TSQ.SurveyId = TS.SurveyId WHERE TSQ.SurveyId = @SurveyId
	
	DELETE FROM DBO.Audit_PublishSurvey WHERE SurveyId = @SurveyId
	DELETE FROM Audit_SurveyRequestDetails WHERE SurveyId = @SurveyId
	
	DELETE FROM DBO.PB_TR_Survey WHERE SurveyId = @SurveyId
	DELETE FROM DBO.TR_Survey WHERE SurveyId = @SurveyId
			
	SELECT 1 AS RetValue, 'Survey Successfully Deleted...' AS Remark		
			
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END


