IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSendSurveyReminderMailData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSendSurveyReminderMailData]

GO

-- EXEC UspGetSendSurveyReminderMailData  
CREATE PROCEDURE DBO.UspGetSendSurveyReminderMailData
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		DISTINCT 
		MI.InviteId, MI.SurveyId, MI.InternalPanelId, TI.PanelMemberId, MR.EmailId AS PanelMemberEmailId,
		'Reminder : '+ISNULL(TID.InviteSubject,'') AS InviteSubject, ISNULL(TML.MessageText,TID.CustomReminderMessage) AS InviteMessage, 
		TI.RowId, MI.IsActive, MI.TobeSentTime, ISNULL(MI.SendReminderAfter,0) AS SendReminderAfter, 
		ISNULL(TSS.LogoFile,'') AS LogoFile, MR.SurveyKey, TI.SentDate,  
		CONVERT(DATETIME,TI.SentDate+ISNULL(MI.SendReminderAfter,0),121) AS SentDateTime,
		CASE WHEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''))),1)='-' THEN '-'
			 WHEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''))),1)='+' THEN '+'
			 ELSE '' END AS Flag, MI.SendNow,
		CONVERT(TIME,REPLACE(REPLACE(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''),'-',''),'+','')) AS PlusMinusTime,
		ISNULL(TID.InviteFrom,'') AS InviteFrom, ISNULL(TID.ReplyTo,'') AS ReplyTo,
		MI.ReminderSendDate, MI.ReminderSentTime, MI.SendRemindedNow, TID.Locked
	INTO #MailData
	FROM DBO.MS_Invite MI
	INNER JOIN DBO.TR_Survey TS
		ON MI.SurveyId = TS.SurveyId
		AND MI.ReminderSendDate IS NOT NULL
		AND ISNULL(MI.SendRemindedNow,0) IN(0,1)
	INNER JOIN dbo.MS_Users MU
		ON TS.CreatedBy = MU.UserId	
	INNER JOIN MS_TimeZone MTZ 
		ON MU.TimeZone = MTZ.TimeZoneId 
	INNER JOIN DBO.TR_Invite TI
		ON MI.InviteId = TI.InviteId 
		AND TI.SentDate IS NOT NULL 
		AND CASE WHEN MI.SendRemindedNow = 1 THEN CONVERT(VARCHAR(25),MI.ReminderSendDate,121)
				 WHEN MI.SendRemindedNow = 0 AND LEFT(CONVERT(TIME,MI.ReminderSentTime,108),12) = '' THEN CONVERT(VARCHAR(25),MI.ReminderSendDate,121)
				 ELSE CONVERT(VARCHAR(10),MI.ReminderSendDate,121)+' '+LEFT(CONVERT(TIME,MI.ReminderSentTime,108),12) END 
				 <= CONVERT(VARCHAR(25),GETDATE(),121)
	INNER JOIN 
	(
		SELECT MR.EmailId, MR.RespondentId, TSRD.SurveyKey, TSRD.SurveyId, TSRD.InviteId 
		FROM DBO.MS_Respondent MR
		INNER JOIN DBO.TR_SurveyRequestDetails TSRD
			ON MR.RespondentId = CONVERT(INT,TSRD.RespondentId)
			AND MR.IsActive = 1 AND MR.IsDeleted = 1
			AND ISNULL(TSRD.ResponseStatus,'') = ''
	) MR	
		ON TI.PanelMemberId = MR.RespondentId
		AND MI.SurveyId = MR.SurveyId
		AND MI.InviteId = CASE WHEN ISNULL(MR.InviteId,0) = 0 THEN MI.InviteId ELSE MR.InviteId END 
	INNER JOIN DBO.TR_InviteDetails TID
		ON TI.RowId = TID.RowId
		AND TID.ReminderSentDate IS NULL
		AND ISNULL(TID.Locked,0) = 0
	LEFT OUTER JOIN DBO.TR_MessageLibrary TML
		ON CONVERT(INT,TID.ReminderMessagLibId) = TML.MessageLibId
	LEFT OUTER JOIN 
	(
		SELECT 
			CONVERT(VARCHAR(12),TGF.LibId)+'/'+CONVERT(VARCHAR(12),TGF.CategoryId)+'/'+TGF.GraphicFileName AS LogoFile, 
			TSS.SurveyId FROM MS_SurveySettings MSS
		INNER JOIN TR_SurveySettings TSS ON MSS.SettingId = TSS.SettingId
		INNER JOIN TR_GraphicFiles TGF ON LTRIM(RTRIM(TSS.Value)) = CONVERT(VARCHAR(12),TGF.GraphicFileId)
			AND MSS.SettingName = 'LogoFile'  
	) TSS
		ON MI.SurveyId = TSS.SurveyId 		
	
	-- Added foll code to mail only those who not reponse to survey -- 20131223
	SELECT 
		DISTINCT MD.* 
	INTO #SurveyNotResponded
	FROM #MailData MD
	LEFT JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		ON MD.SurveyId = TSQ.SurveyId
	LEFT JOIN DBO.TR_Responses TR WITH(NOLOCK) 
		ON TSQ.QuestionId = TR.QuestionId 
		AND MD.PanelMemberId = TR.RespondentId
	WHERE TR.RespondentId IS NULL
	-- End of Added foll code to mail only those who not reponse to survey -- 20131223
		
	-----New Logic For Time Zone-------------------------------------------------------------------	
	SELECT 
		DISTINCT 
		InviteId, SurveyId, InternalPanelId, PanelMemberId, PanelMemberEmailId, InviteSubject, 
		InviteMessage, RowId, IsActive, TobeSentTime, SendReminderAfter, LogoFile, SurveyKey,
		----Above Is Actual Column---------------
		SentDateTime, Flag, PlusMinusTime,
		CASE WHEN SendRemindedNow = 1 THEN ReminderSendDate
			 WHEN SendRemindedNow = 0 AND ReminderSentTime = '' THEN ReminderSendDate
			 WHEN SendRemindedNow = 0 AND Flag = '-' THEN ReminderSendDate-PlusMinusTime
			 WHEN SendRemindedNow = 0 AND Flag = '+' THEN ReminderSendDate+PlusMinusTime
			 ELSE ReminderSendDate END AS ActualSentDateTime,
		InviteFrom, ReplyTo,  ReminderSendDate, ReminderSentTime
	INTO #SurveyMailData		 
	--FROM #MailData
	FROM #SurveyNotResponded
	
	SELECT 
		DISTINCT
		InviteId, SurveyId, InternalPanelId, PanelMemberId, PanelMemberEmailId, InviteSubject, 
		InviteMessage, RowId, IsActive, TobeSentTime, SendReminderAfter, LogoFile, SurveyKey,
		InviteFrom, ReplyTo,  ReminderSendDate, ReminderSentTime
	INTO #Locked
	FROM #SurveyMailData
	WHERE ActualSentDateTime <= GETDATE()

	SELECT 
		LK.InviteId, LK.SurveyId, LK.InternalPanelId, LK.PanelMemberId, LK.PanelMemberEmailId, LK.InviteSubject, 
		LK.InviteMessage, LK.RowId, LK.IsActive, LK.TobeSentTime, LK.SendReminderAfter, LK.LogoFile, LK.SurveyKey,
		LK.InviteFrom, LK.ReplyTo,  LK.ReminderSendDate, LK.ReminderSentTime
	INTO #LockedRes
	FROM #Locked LK 
	LEFT JOIN 
	(
		SELECT 
			DISTINCT TSQ.SurveyId, TR.RespondentId 
		FROM DBO.TR_Responses TR WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON TR.QuestionId = TSQ.QuestionId
		WHERE TR.RespondentId >=1
	) TR
		ON LK.SurveyId = TR.SurveyId AND LK.PanelMemberId = TR.RespondentId
	WHERE TR.RespondentId IS NULL	
	
	UPDATE TID
	SET TID.Locked = 1
	FROM DBO.TR_InviteDetails TID
	INNER JOIN #LockedRes L 
		ON TID.RowId = L.RowId
		
	SELECT 
		DISTINCT
		LR.InviteId, LR.SurveyId, LR.InternalPanelId, LR.PanelMemberId, LR.PanelMemberEmailId, LR.InviteSubject, 
		LR.InviteMessage, LR.RowId, LR.IsActive, LR.TobeSentTime, LR.SendReminderAfter, LR.LogoFile, LR.SurveyKey,
		LR.InviteFrom, LR.ReplyTo,  LR.ReminderSendDate, LR.ReminderSentTime, ML.LangauageName AS LanguageName
	FROM #LockedRes LR
	INNER JOIN DBO.TR_Survey TS
 		ON LR.SurveyId = TS.SurveyId
 	LEFT JOIN DBO.MS_Languages ML
 		ON TS.LanguageId = ML.LanguageId
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END