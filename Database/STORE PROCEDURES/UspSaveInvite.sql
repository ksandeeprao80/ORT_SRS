IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveInvite]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveInvite]

GO
/*
EXEC UspSaveInvite '<?xml version="1.0" encoding="utf-16"?>
<SurveyInvite>
	<Survey>
		<SurveyId>1240</SurveyId>
		<RewardEnabled>false</RewardEnabled>
		<Starred>false</Starred>
		<IsActive>false</IsActive>
	</Survey>
	<InvitedPanel>
		<LibType>Panel</LibType>
		<PanelId>64</PanelId>
		<LastUsed>0001-01-01T00:00:00</LastUsed>
		<IsPanelActive>false</IsPanelActive>
	</InvitedPanel>
	<InviteType>Internal</InviteType>
	<SourceLibrary>
		<MessageLibraryId>1</MessageLibraryId>
		<LibType>Message</LibType>
		<MailType>Invite</MailType>
	</SourceLibrary>
	<SendReminder>false</SendReminder>
	<RemiderMessageLibraryId>
		<MessageLibraryId>2</MessageLibraryId>
		<LibType>Message</LibType>
		<MailType>Reminder</MailType>
	</RemiderMessageLibraryId>
	<TobeSentDate>2013-02-02</TobeSentDate>
	<SendNow>false</SendNow>
	<SocialNetworkDetails>
		<SocialNetworkInvite>
			<NetworkType>Facebook</NetworkType>
			<InviteTitle>Survey With Logo</InviteTitle>
			<InviteDescription>Facebook title</InviteDescription>
		</SocialNetworkInvite>
		<SocialNetworkInvite>
			<NetworkType>Twitter</NetworkType>
			<InviteTitle>Survey With Logo</InviteTitle>
			<InviteDescription>Twitter title</InviteDescription>
		</SocialNetworkInvite>
	</SocialNetworkDetails>
	<InviteFrom>Jd testing</InviteFrom>
	<ReplyTo>TestingofRepllyTo</ReplyTo>
	<InviteSubject>Test</InviteSubject>
	<CustomMessage>testing</CustomMessage>
	<ReminderSendDate></ReminderSendDate>
	<ReminderSentTime></ReminderSentTime>
	<SendRemindedNow></SendRemindedNow>
</SurveyInvite>'
*/
		
CREATE PROCEDURE DBO.UspSaveInvite
	@XMlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	
	SELECT
		Parent.Elm.value('(InviteType)[1]','VARCHAR(50)') AS InviteType,
		Parent.Elm.value('(SendReminder)[1]','VARCHAR(20)') AS SendReminder,
		Parent.Elm.value('(TobeSentDate)[1]','VARCHAR(30)') AS TobeSentDate,
		Parent.Elm.value('(TobeSentTime)[1]','VARCHAR(30)') AS TobeSentTime,
		Parent.Elm.value('(SendReminderAfter)[1]','VARCHAR(30)') AS SendReminderAfter,
		Parent.Elm.value('(SendNow)[1]','VARCHAR(20)') AS SendNow,
		Child.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Child.Elm.value('(RewardEnabled)[1]','VARCHAR(20)') AS SurveyRewardEnabled,
		Child.Elm.value('(Starred)[1]','VARCHAR(20)') AS SurveyStarred,
		Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS SurveyIsActive,
		Child1.Elm.value('(LibType)[1]','VARCHAR(20)') AS InvitedLibType,
		Child1.Elm.value('(PanelId)[1]','VARCHAR(20)') AS InvitedPanelId,
		Child1.Elm.value('(LastUsed)[1]','VARCHAR(30)') AS InvitedLastUsed,
		Child1.Elm.value('(IsPanelActive)[1]','VARCHAR(20)') AS InvitedIsPanelActive,
		Child2.Elm.value('(MessageLibraryId)[1]','VARCHAR(20)') AS SourceMessageLibraryId,
		Child2.Elm.value('(LibType)[1]','VARCHAR(50)') AS SourceLibType,
		Child2.Elm.value('(MailType)[1]','VARCHAR(50)') AS SourceMailType,
		Child3.Elm.value('(MessageLibraryId)[1]','VARCHAR(20)') AS RemiderMessageLibraryId,
		Child3.Elm.value('(LibType)[1]','VARCHAR(50)') AS RemiderLibType,
		Child3.Elm.value('(MailType)[1]','VARCHAR(50)') AS RemiderMailType,
		Parent.Elm.value('(InviteFrom)[1]','VARCHAR(100)') AS InviteFrom,
		Parent.Elm.value('(ReplyTo)[1]','VARCHAR(100)') AS ReplyTo,
		Parent.Elm.value('(InviteSubject)[1]','NVARCHAR(100)') AS InviteSubject,
		Parent.Elm.value('(CustomMessage)[1]','NVARCHAR(MAX)') AS CustomMessage,
		Parent.Elm.value('(ReminderSendDate)[1]','VARCHAR(30)') AS ReminderSendDate,
		Parent.Elm.value('(ReminderSentTime)[1]','VARCHAR(30)') AS ReminderSentTime,
		Parent.Elm.value('(SendRemindedNow)[1]','VARCHAR(20)') AS SendRemindedNow
	INTO #SurveyInvite
	FROM @input.nodes('/SurveyInvite') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Survey') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('InvitedPanel') AS Child1(Elm)	
	CROSS APPLY
		Parent.Elm.nodes('SourceLibrary') AS Child2(Elm)	
	CROSS APPLY
		Parent.Elm.nodes('RemiderMessageLibraryId') AS Child3(Elm)			
	
	SELECT
		Child5.Elm.value('(NetworkType)[1]','VARCHAR(50)') AS SocialNetworkType,
		Child5.Elm.value('(InviteTitle)[1]','VARCHAR(100)') AS SocialInviteTitle,
		Child5.Elm.value('(InviteDescription)[1]','VARCHAR(100)') AS SocialInviteDescription
	INTO #SurveyInvite1
	FROM @input.nodes('/SurveyInvite') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SocialNetworkDetails') AS Child4(Elm)
	CROSS APPLY
		Child4.Elm.nodes('SocialNetworkInvite') AS Child5(Elm)

	-- MS_Invite
	DECLARE @InviteId INT
	SET @InviteId = 0
	
	INSERT INTO DBO.MS_Invite
	(
		SurveyId, InviteType, InvitePassword, ToBeSentDate, ExternalPanelEmailId, InternalPanelId, SendNow,
		TobeSentTime, SendReminderAfter, ReminderSendDate, ReminderSentTime, SendRemindedNow, CreatedOn
	)
	SELECT 	
		CONVERT(INT,SI.SurveyId) AS SurveyId, MIT.InviteType AS InviteType, NULL AS InvitePassword, 
		CASE WHEN SI.SendNow = 'True' THEN GETDATE() ELSE SI.TobeSentDate END AS ToBeSentDate, 
		NULL AS ExternalPanelEmailId, CONVERT(INT,SI.InvitedPanelId) AS InternalPanelId, 
		CASE WHEN SI.SendNow = 'True' THEN 1 ELSE 0 END AS SendNow, SI.TobeSentTime, SI.SendReminderAfter, 
		CASE WHEN SI.SendRemindedNow = 'now' THEN GETDATE()
		WHEN SI.SendRemindedNow = 'later' THEN SI.ReminderSendDate ELSE NULL END AS ReminderSendDate, 
		SI.ReminderSentTime, 
		CASE WHEN SI.SendRemindedNow = 'now' THEN 1 
		     WHEN SI.SendRemindedNow = 'later' THEN 0 ELSE -1 END AS SendRemindedNow,
		GETDATE() AS CreatedOn
	FROM #SurveyInvite SI
	INNER JOIN DBO.MS_InviteTypes MIT
		ON LTRIM(RTRIM(SI.InviteType)) = LTRIM(RTRIM(MIT.InviteTypeName))
		
	SET @InviteId = @@IDENTITY
	
	IF ISNULL(@InviteId,0) <> 0
	BEGIN
		INSERT INTO DBO.TR_Invite
		(InviteId, PanelMemberId, SentDate)
		SELECT 
			@InviteId, MR.RespondentId, NULL 
		FROM DBO.MS_Invite MI
		INNER JOIN DBO.MS_Respondent MR
			ON MI.InternalPanelId = MR.PanelistId
			AND MI.InviteId = @InviteId
			AND MR.IsActive = 1
			AND MR.IsDeleted = 1
		
		-- 	TR_InviteDetails	
		DECLARE @InviteFrom VARCHAR(100), 
				@InviteSubject NVARCHAR(100), 
				@SourceMessageLibraryId VARCHAR(50),
				@CustomMessage NVARCHAR(MAX),
				@RemiderMailType INT,
				@RemiderMessageLibraryId VARCHAR(50),
				@ReplyTo VARCHAR(100)
		
		SELECT @InviteFrom = InviteFrom,
				@InviteSubject = InviteSubject,
				@SourceMessageLibraryId = SourceMessageLibraryId,
				@CustomMessage = CustomMessage,
				@RemiderMailType = CASE WHEN RemiderMailType = 'True' THEN 1 ELSE 0 END,
				@RemiderMessageLibraryId = RemiderMessageLibraryId,
				@ReplyTo = ReplyTo
		FROM #SurveyInvite 
			
		INSERT INTO DBO.TR_InviteDetails
		(
			RowId, InviteFrom, InviteSubject, MessageLibId, CustomMessage, SendReminder, 
			ReminderMessagLibId, CustomReminderMessage, ReplyTo
		)
		SELECT 
			DISTINCT TR.RowId, @InviteFrom, @InviteSubject, @SourceMessageLibraryId AS MessageLibId,
			@CustomMessage, @RemiderMailType AS SendReminder, @RemiderMessageLibraryId AS ReminderMessagLibId, 
			NULL AS CustomReminderMessage, @ReplyTo
		FROM DBO.TR_Invite TR
		WHERE TR.InviteId = @InviteId
	END
	
	SELECT 
		CASE WHEN ISNULL(@InviteId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@InviteId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
		ISNULL(@InviteId,0) AS InviteId
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



