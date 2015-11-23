IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveTwitterInvite]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveTwitterInvite]

GO
/*
EXEC UspSaveTwitterInvite '<?xml version="1.0" encoding="utf-16"?>
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
      <NetworkType>Twitter</NetworkType>
      <InviteTitle>Survey With Logo</InviteTitle>
      <InviteDescription>Twitter title</InviteDescription>
    </SocialNetworkInvite>
    <SocialNetworkInvite>
      <NetworkType>Twitter</NetworkType>
      <InviteTitle>Survey With Logo</InviteTitle>
      <InviteDescription>Twitter title</InviteDescription>
    </SocialNetworkInvite>
  </SocialNetworkDetails>
  <InviteFrom>Jd testing</InviteFrom>
  <InviteSubject>Test</InviteSubject>
  <CustomMessage>testing</CustomMessage>
</SurveyInvite>'
*/
		
CREATE PROCEDURE DBO.UspSaveTwitterInvite
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
		Parent.Elm.value('(InviteFrom)[1]','VARCHAR(150)') AS InviteFrom,
		Parent.Elm.value('(InviteSubject)[1]','VARCHAR(100)') AS InviteSubject,
		Parent.Elm.value('(CustomMessage)[1]','VARCHAR(MAX)') AS CustomMessage
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
	(SurveyId, InviteType, InvitePassword, ToBeSentDate, ExternalPanelEmailId,InternalPanelId, CreatedOn)
	SELECT 	
		CONVERT(INT,SI.SurveyId), MIT.InviteType, NULL, GETDATE(), 	NULL, CONVERT(INT,SI.InvitedPanelId),
		GETDATE()
	FROM #SurveyInvite SI
	INNER JOIN DBO.MS_InviteTypes MIT
		ON LTRIM(RTRIM(SI.InviteType)) = LTRIM(RTRIM(MIT.InviteTypeName))
		
	SET @InviteId = @@IDENTITY
	
	IF ISNULL(@InviteId,0) <> 0
	BEGIN
		INSERT INTO DBO.TR_Invite
		(InviteId, PanelMemberId, SentDate)
		SELECT @InviteId, 0, NULL 
		
		-- 	TR_InviteChannelDetail
		INSERT INTO DBO.TR_InviteChannelDetail
		(InviteId, InviteTitle, InviteDescription, ChannelId)
		SELECT 
			@InviteId, SI.SocialInviteTitle, SI.SocialInviteDescription, 3 AS ChannelId
		FROM #SurveyInvite1 SI
		/*--1	Email, --2	Facebook, --3	Twitter*/
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



