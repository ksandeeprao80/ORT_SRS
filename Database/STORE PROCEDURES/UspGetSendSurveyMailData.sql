IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSendSurveyMailData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSendSurveyMailData]

GO

-- EXEC UspGetSendSurveyMailData  
CREATE PROCEDURE DBO.UspGetSendSurveyMailData
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		MI.InviteId, MI.SurveyId, MI.InternalPanelId, TI.PanelMemberId, MR.EmailId AS PanelMemberEmailId,
		TID.InviteSubject, ISNULL(TML.MessageText,TID.CustomMessage) AS InviteMessage, TI.RowId, MI.IsActive,
		MI.TobeSentTime, ISNULL(MI.SendReminderAfter,0) AS SendReminderAfter, ISNULL(TSS.LogoFile,'') AS LogoFile,
		'' AS SurveyKey, MI.SendNow,
		CASE WHEN MI.SendNow = 1 THEN MI.ToBeSentDate 
			 WHEN MI.SendNow = 0 AND LEFT(CONVERT(TIME,MI.ToBeSentTime,108),12) = '' THEN MI.ToBeSentDate
			 ELSE CONVERT(DATETIME,CONVERT(VARCHAR(10),CONVERT(DATE,MI.ToBeSentDate))+' '+LEFT(CONVERT(TIME,MI.ToBeSentTime,108),12),121) 
			 END AS SentDateTime,
		CASE WHEN MI.SendNow = 1 THEN ''
			 WHEN MI.SendNow = 0 AND LEFT(LTRIM(RTRIM(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''))),1)='-' THEN '-'
			 WHEN MI.SendNow = 0 AND LEFT(LTRIM(RTRIM(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''))),1)='+' THEN '+'
			 ELSE '' END AS Flag,
		CONVERT(TIME,REPLACE(REPLACE(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''),'-',''),'+','')) AS PlusMinusTime,
		ISNULL(TID.InviteFrom,'') AS InviteFrom, ISNULL(TID.ReplyTo,'') AS ReplyTo,
		TI.Locked
	INTO #MailData
	FROM DBO.MS_Invite MI
	INNER JOIN DBO.TR_Survey TS ON MI.SurveyId = TS.SurveyId
	INNER JOIN dbo.MS_Users MU ON TS.CreatedBy = MU.UserId	
	INNER JOIN MS_TimeZone MTZ ON MU.TimeZone = MTZ.TimeZoneId 
	INNER JOIN DBO.TR_Invite TI ON MI.InviteId = TI.InviteId AND ISNULL(TI.Locked,0) = 0
	AND CASE WHEN MI.SendNow = 1 THEN CONVERT(VARCHAR(25),MI.ToBeSentDate,121) 
			 WHEN MI.SendNow = 0 AND LEFT(CONVERT(TIME,MI.ToBeSentTime,108),12) = '' THEN CONVERT(VARCHAR(25),MI.ToBeSentDate,121)
			 ELSE CONVERT(VARCHAR(10),MI.ToBeSentDate,121)+' '+LEFT(CONVERT(TIME,MI.ToBeSentTime,108),12) END 
			 <= CONVERT(VARCHAR(25),GETDATE(),121)
		AND TI.SentDate IS NULL
	INNER JOIN DBO.MS_Respondent MR ON TI.PanelMemberId = MR.RespondentId AND MR.IsActive = 1 AND MR.IsDeleted = 1
	INNER JOIN DBO.TR_InviteDetails TID ON TI.RowId = TID.RowId
	LEFT OUTER JOIN 
	(
		SELECT 
			CONVERT(VARCHAR(12),TGF.LibId)+'/'+CONVERT(VARCHAR(12),TGF.CategoryId)+'/'+TGF.GraphicFileName AS LogoFile, 
			TSS.SurveyId FROM MS_SurveySettings MSS
		INNER JOIN TR_SurveySettings TSS ON MSS.SettingId = TSS.SettingId
		INNER JOIN TR_GraphicFiles TGF ON LTRIM(RTRIM(TSS.Value)) = CONVERT(VARCHAR(12),TGF.GraphicFileId)
		WHERE MSS.SettingName = 'LogoFile'  
	) TSS
		ON MI.SurveyId = TSS.SurveyId 	
	LEFT OUTER JOIN DBO.TR_MessageLibrary TML ON CONVERT(INT,TID.MessageLibId) = TML.MessageLibId
		
	SELECT
		MD.InviteId, MD.SurveyId, MD.InternalPanelId, MD.PanelMemberId, MD.PanelMemberEmailId, MD.InviteSubject, 
		MD.InviteMessage, MD.RowId, MD.IsActive, MD.TobeSentTime, MD.SendReminderAfter, MD.LogoFile, MD.SurveyKey, 
		MD.SendNow, MD.SentDateTime, MD.Flag, MD.PlusMinusTime, MD.InviteFrom, MD.ReplyTo, MD.Locked, 
		CASE WHEN ISNULL(TSS.Value,'') <> '' THEN 'True' 
			 ELSE DBO.FN_CheckRespoSurveyDayDiff(MD.SurveyId,MD.PanelMemberId) END AS Valid
	INTO #ValidRespondent	
	FROM #MailData MD
	LEFT JOIN 
	(
		SELECT SurveyId, Value FROM DBO.TR_SurveySettings TSS WITH(NOLOCK)
		WHERE SettingId = 68 /*NonSurveyDays*/
	) TSS
		ON MD.SurveyId = TSS.SurveyId
		
	-----New Logic For Time Zone-------------------------------------------------------------------	
	SELECT 
		InviteId, SurveyId, InternalPanelId, PanelMemberId, PanelMemberEmailId, InviteSubject, InviteMessage, 
		RowId, IsActive, TobeSentTime, SendReminderAfter, LogoFile, SurveyKey,
		----Above Is Actual Column---------------
		SentDateTime, Flag, PlusMinusTime,
		CASE WHEN Flag = '-' THEN SentDateTime-PlusMinusTime
			 WHEN Flag = '+' THEN SentDateTime+PlusMinusTime
			 ELSE SentDateTime END AS ActualSentDateTime,
		InviteFrom, ReplyTo	 
	INTO #SurveyMailData		 
	FROM #ValidRespondent WHERE Valid = 'True'
	
	SELECT 
		InviteId, SurveyId, InternalPanelId, PanelMemberId, PanelMemberEmailId, InviteSubject, InviteMessage, 
		RowId, IsActive, TobeSentTime, SendReminderAfter, LogoFile, SurveyKey, InviteFrom, ReplyTo
	INTO #Locked
	FROM #SurveyMailData SMD
	WHERE SMD.ActualSentDateTime <= GETDATE()

	SELECT
		LK.InviteId, LK.SurveyId, LK.InternalPanelId, LK.PanelMemberId, LK.PanelMemberEmailId, LK.InviteSubject, 
		LK.InviteMessage, LK.RowId, LK.IsActive, LK.TobeSentTime, LK.SendReminderAfter, LK.LogoFile, LK.SurveyKey, 
		LK.InviteFrom, LK.ReplyTo 
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
		
	UPDATE TI
	SET TI.Locked = 1
	FROM DBO.TR_Invite TI
	INNER JOIN #LockedRes L 
		ON TI.InviteId = L.InviteId
 	
 	SELECT 
 		LR.InviteId, LR.SurveyId, LR.InternalPanelId, LR.PanelMemberId, LR.PanelMemberEmailId, LR.InviteSubject, 
 		LR.InviteMessage, LR.RowId, LR.IsActive, LR.TobeSentTime, LR.SendReminderAfter, LR.LogoFile, LR.SurveyKey, 
 		LR.InviteFrom, LR.ReplyTo, ML.LangauageName AS LanguageName 
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