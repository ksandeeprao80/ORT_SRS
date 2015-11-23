IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyDistributeHistory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyDistributeHistory]

GO
/*
EXEC UspGetSurveyDistributeHistory @CustomerId='1',@PageData='<?xml version="1.0" encoding="utf-16"?>
<PageModel>
	<Page>1</Page>
	<Start>0</Start>
	<Limit>25</Limit>
	<SortBy />
</PageModel>',
@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
	<UserId>5</UserId>
	<UserName>Nilesh More</UserName>
	<UserDetails>
		<IsActive>false</IsActive>
		<Customer>
			<CustomerId>1</CustomerId>
			<IsActive>false</IsActive>
		</Customer>
		<UserRole>
			<RoleId>2</RoleId>
			<RoleDesc>SRS Admin</RoleDesc>
			<Hierarchy>1</Hierarchy>
		</UserRole>
	</UserDetails>
</User>'
*/
CREATE PROCEDURE DBO.UspGetSurveyDistributeHistory
	@CustomerId INT,
	@XmlUserInfo AS NTEXT,
	@PageData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId INT, CustomerId INT, RoleId INT, RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
 
	DECLARE @TotalRecords INT
	SET @TotalRecords = 0
	
	CREATE TABLE #MySurvey 
	(
		InviteId INT, ChannelDescription VARCHAR(100), SurveyId INT, SurveyName NVARCHAR(50), SendNow VARCHAR(8), 
		ToBeSentDate VARCHAR(10), TobeSentTime VARCHAR(8), SentTime VARCHAR(8), TobeSentNow VARCHAR(5), 
		SendReminderAfter INT, SurveyKey VARCHAR(100), TwitterPostTitle VARCHAR(10), TwitterPostMessage VARCHAR(10),
		FacebookPostTitle NVARCHAR(100), FacebookPostMessage NVARCHAR(MAX), InviteFrom VARCHAR(100), 
		InviteSubject NVARCHAR(100), EmailBodyType VARCHAR(10), EmailBody NVARCHAR(MAX), 
		MessageLibId INT, ReminderMessagLibId INT, InternalPanelId INT, TimeZone VARCHAR(150),
		ReplyTo VARCHAR(100), ReminderSendDate DATETIME, ReminderSentTime VARCHAR(10), 
		SendRemindedNow VARCHAR(20), CreatedOn DATETIME
	)
	INSERT INTO #MySurvey
	(
		InviteId, ChannelDescription, SurveyId, SurveyName, SendNow, ToBeSentDate, TobeSentTime,
		SentTime, TobeSentNow, SendReminderAfter, SurveyKey, TwitterPostTitle, TwitterPostMessage,
		FacebookPostTitle, FacebookPostMessage, InviteFrom, InviteSubject, EmailBodyType,
		EmailBody, MessageLibId, ReminderMessagLibId, InternalPanelId, TimeZone, ReplyTo,
		ReminderSendDate, ReminderSentTime, SendRemindedNow, CreatedOn
	)	
	SELECT 
		MI.InviteId, LOWER(ISNULL(TICD.ChannelDescription,'email')) AS ChannelDescription, MI.SurveyId, TS.SurveyName, 
		CASE WHEN MI.SendNow = 1 THEN CONVERT(VARCHAR,MI.ToBeSentDate,108) 
			 ELSE LEFT(CONVERT(TIME,MI.ToBeSentTime,108),8) END AS SendNow,
		CASE WHEN MI.SendNow = 1 THEN '' 
			 ELSE ISNULL(CONVERT(VARCHAR(10),ISNULL(TI.SentDate,MI.ToBeSentDate),101),'') END AS ToBeSentDate, 
		CASE WHEN MI.SendNow = 1 THEN CONVERT(VARCHAR,MI.ToBeSentDate,108) ELSE MI.ToBeSentTime END AS TobeSentTime,
		CONVERT(VARCHAR,ISNULL(TI.SentDate,MI.ToBeSentDate),108) AS SentTime,
		CASE WHEN MI.SendNow = 1 THEN 'true' ELSE 'false' END AS TobeSentNow,
		ISNULL(MI.SendReminderAfter,0) AS SendReminderAfter, TSRD.SurveyKey, '' AS TwitterPostTitle, '' AS TwitterPostMessage,
		ISNULL(TICD.InviteTitle,'') AS FacebookPostTitle, ISNULL(TICD.InviteDescription,'') AS FacebookPostMessage,
		ISNULL(TID.InviteFrom,'') AS InviteFrom, ISNULL(TID.InviteSubject,'') AS InviteSubject, 
		CASE WHEN ISNULL(TID.MessageLibId,0) = 0 THEN 'custom' ELSE 'Library' END AS EmailBodyType,
		CASE WHEN ISNULL(TID.MessageLibId,0) = 0 THEN MIN(TID.CustomMessage) ELSE MIN(TML.MessageText) END AS EmailBody, 
		ISNULL(TID.MessageLibId,0) AS MessageLibId, ISNULL(TID.ReminderMessagLibId,0) AS ReminderMessagLibId, 
		MI.InternalPanelId,MTZ.LocationName AS TimeZone, ISNULL(TID.ReplyTo,'') AS ReplyTo,
		CASE WHEN MI.SendRemindedNow = 1 THEN '' 
			 WHEN MI.SendRemindedNow = 0 THEN ISNULL(CONVERT(VARCHAR(10),ISNULL(TID.ReminderSentDate,MI.ReminderSendDate),101),'') 
			 ELSE '' END AS ReminderSendDate,
		CASE WHEN MI.SendRemindedNow = 1 THEN ISNULL(CONVERT(VARCHAR,MI.ReminderSendDate,108),'') 
		     WHEN MI.SendRemindedNow = 0 THEN ISNULL(MI.ReminderSentTime,'') ELSE '' END AS ReminderSentTime,
		CASE WHEN MI.SendRemindedNow = 1 THEN 'now' 
		     WHEN MI.SendRemindedNow = 0 THEN 'later' ELSE 'notRightNow' END AS SendRemindedNow,
		MI.CreatedOn AS CreatedOn 
	FROM DBO.MS_Invite MI
	INNER JOIN DBO.TR_Survey TS WITH(NOLOCK) ON MI.SurveyId = TS.SurveyId
	INNER JOIN @UserInfo UI
		ON TS.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TS.CustomerId ELSE UI.CustomerId END) 
		AND TS.CreatedBy = (CASE WHEN UI.RoleDesc IN ('SA','GU') THEN TS.CreatedBy ELSE UI.UserId END)  		 
	INNER JOIN DBO.TR_Invite TI WITH(NOLOCK) ON MI.InviteId = TI.InviteId
	INNER JOIN DBO.MS_Users	MU ON TS.CreatedBy = MU.UserId
	INNER JOIN DBO.MS_TimeZone	MTZ ON MU.TimeZone = MTZ.TimeZoneId
	LEFT OUTER JOIN DBO.TR_InviteDetails TID ON TI.RowId = TID.RowId
	LEFT OUTER JOIN DBO.TR_MessageLibrary TML ON TID.MessageLibId = TML.MessageLibId
	LEFT OUTER JOIN 
	(
		SELECT 
			TICD.InviteId, TICD.ChannelId, TICD.InviteDescription, TICD.InviteTitle, MC.ChannelDescription
		FROM DBO.TR_InviteChannelDetail TICD  WITH(NOLOCK)
		INNER JOIN DBO.MS_Channel MC  WITH(NOLOCK)
			ON TICD.ChannelId = MC.ChannelId
	) TICD
		ON TI.InviteId = TICD.InviteId
	LEFT OUTER JOIN
	(
		SELECT DISTINCT TSRD.SurveyId, SurveyKey 
		FROM DBO.TR_SurveyRequestDetails TSRD  WITH(NOLOCK)
		WHERE TSRD.RespondentId = '0' AND TSRD.RenderMode = 'R'
	) TSRD
		ON TS.SurveyId = TSRD.SurveyId 	
	GROUP BY MI.InviteId, LOWER(ISNULL(TICD.ChannelDescription,'email')), MI.SurveyId, TS.SurveyName, MI.SendNow,
		ISNULL(CONVERT(VARCHAR(10),MI.ToBeSentDate,101),''), TSRD.SurveyKey, ISNULL(TICD.InviteTitle,''), 
		ISNULL(TICD.InviteDescription,''), ISNULL(TID.InviteFrom,''), 
		ISNULL(TID.InviteSubject,''), TID.MessageLibId, TID.ReminderMessagLibId, 
		ISNULL(CONVERT(VARCHAR(10),ISNULL(TI.SentDate,MI.ToBeSentDate),101),''),
		CONVERT(VARCHAR,MI.ToBeSentDate,108), MI.InternalPanelId, MI.TobeSentTime, ISNULL(MI.SendReminderAfter,0),
		MI.SendNow, CONVERT(VARCHAR,ISNULL(TI.SentDate,MI.ToBeSentDate),108), MTZ.LocationName, ISNULL(TID.ReplyTo,''),
		ISNULL(CONVERT(VARCHAR(10),ISNULL(TID.ReminderSentDate,MI.ReminderSendDate),101),''), 
		ISNULL(CONVERT(VARCHAR,MI.ReminderSendDate,108),''), ISNULL(MI.ReminderSentTime,''), MI.SendRemindedNow,
		MI.CreatedOn
	
	SELECT @TotalRecords = COUNT(1) FROM #MySurvey
				
	--------------------------------------
	DECLARE @input1 XML = @PageData        

	DECLARE @PagingViewModel TABLE
	(RowId INT IDENTITY(1,1), PageNo INT, Start INT, RowLimit INT)
	INSERT INTO @PagingViewModel
	(PageNo, Start, RowLimit)
	SELECT
		Parent.Elm.value('(Page)[1]','VARCHAR(20)') AS PageNo,
		Parent.Elm.value('(Start)[1]','VARCHAR(20)') AS Start,
		Parent.Elm.value('(Limit)[1]','VARCHAR(20)') AS RowLimit
	FROM @input1.nodes('/PageModel') AS Parent(Elm)

	DECLARE @PagingViewModelOrder TABLE
	(RowId INT IDENTITY(1,1), Property VARCHAR(50), Direction VARCHAR(5))
	INSERT INTO @PagingViewModelOrder
	(Property, Direction)
	SELECT
		Child1.Elm.value('(Property)[1]','VARCHAR(20)') AS Property,
		Child1.Elm.value('(Direction)[1]','VARCHAR(20)') AS Direction
	FROM @input1.nodes('/PageModel') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SortBy') AS Child(Elm)
	CROSS APPLY
		Child.Elm.nodes('SortModel') AS Child1(Elm)	
		
	DECLARE @Count INT
	DECLARE @PageNo INT
	DECLARE @PageSize INT
	DECLARE @ColumnNameOrderBy VARCHAR(150)
	SET @Count = 0
	SET @ColumnNameOrderBy = ''
	
	SELECT @PageNo = PageNo, @PageSize = RowLimit FROM @PagingViewModel WHERE RowId = 1

	SELECT @Count = COUNT(1) FROM @PagingViewModelOrder
	IF @Count >= 1
	BEGIN
		SELECT @ColumnNameOrderBy = COALESCE(@ColumnNameOrderBy,'','') +  Property+' '+ISNULL(Direction,'ASC')+',' FROM @PagingViewModelOrder ORDER BY RowId ASC
		SET @ColumnNameOrderBy = LEFT(@ColumnNameOrderBy,LEN(@ColumnNameOrderBy)-1)
	END
	
	IF ISNULL(@PageNo,0) = 0 
	BEGIN			
		SET @PageNo = 1
	END
	IF ISNULL(@PageSize,0) = 0
	BEGIN
		SET @PageSize = 20
	END
	
	DECLARE @FirstRecord INT
	DECLARE @LastRecord INT
	SET @FirstRecord = (@PageNo - 1) * @PageSize + 1  
	SET @LastRecord = @FirstRecord + @PageSize - 1 

	DECLARE @OrderedKeys TABLE 
	(
		RowNum INT IDENTITY NOT NULL PRIMARY KEY CLUSTERED, InviteId INT, ChannelDescription VARCHAR(100), 
		SurveyId INT, SurveyName NVARCHAR(50), SendNow VARCHAR(8), ToBeSentDate VARCHAR(10), TobeSentTime VARCHAR(8), 
		SentTime VARCHAR(8), TobeSentNow VARCHAR(5), SendReminderAfter INT, SurveyKey VARCHAR(100), 
		TwitterPostTitle VARCHAR(10), TwitterPostMessage VARCHAR(10), FacebookPostTitle NVARCHAR(100), 
		FacebookPostMessage NVARCHAR(MAX), InviteFrom VARCHAR(100), InviteSubject NVARCHAR(100), 
		EmailBodyType VARCHAR(10), EmailBody NVARCHAR(MAX), MessageLibId INT, ReminderMessagLibId INT, 
		InternalPanelId INT, TimeZone VARCHAR(150), ReplyTo VARCHAR(100), ReminderSendDate DATETIME, 
		ReminderSentTime VARCHAR(10), SendRemindedNow VARCHAR(20), CreatedOn VARCHAR(10) 
	)
	
	SET ROWCOUNT @LastRecord
	
	DECLARE @SqlScript NVARCHAR(4000)

	IF ISNULL(@ColumnNameOrderBy,'') = ''
	BEGIN
		SET @SqlScript = 'SELECT InviteId,ChannelDescription,SurveyId,SurveyName,SendNow,ToBeSentDate, 
			TobeSentTime,SentTime,TobeSentNow,SendReminderAfter,SurveyKey,TwitterPostTitle, 
			TwitterPostMessage,FacebookPostTitle,FacebookPostMessage,InviteFrom,  
			InviteSubject,EmailBodyType,EmailBody,MessageLibId,ReminderMessagLibId,InternalPanelId, 
			TimeZone,ReplyTo,ReminderSendDate,ReminderSentTime,SendRemindedNow,CONVERT(VARCHAR(10),CreatedOn,101)
			FROM #MySurvey ORDER BY CONVERT(VARCHAR(10),CreatedOn,112) DESC, SentTime DESC'
	END
	ELSE
	BEGIN
		SET @SqlScript = 'SELECT InviteId,ChannelDescription,SurveyId,SurveyName,SendNow,ToBeSentDate, 
			TobeSentTime,SentTime,TobeSentNow,SendReminderAfter,SurveyKey,TwitterPostTitle, 
			TwitterPostMessage,FacebookPostTitle,FacebookPostMessage,InviteFrom,  
			InviteSubject,EmailBodyType,EmailBody,MessageLibId,ReminderMessagLibId,InternalPanelId, 
			TimeZone,ReplyTo,ReminderSendDate,ReminderSentTime,SendRemindedNow,CONVERT(VARCHAR(10),CreatedOn,101)
			FROM #MySurvey ORDER BY '+ @ColumnNameOrderBy
	END					
						
	INSERT INTO @OrderedKeys
	(
		InviteId, ChannelDescription, SurveyId, SurveyName, SendNow, ToBeSentDate, TobeSentTime,
		SentTime, TobeSentNow, SendReminderAfter, SurveyKey, TwitterPostTitle, TwitterPostMessage,
		FacebookPostTitle, FacebookPostMessage, InviteFrom, InviteSubject, EmailBodyType,
		EmailBody, MessageLibId, ReminderMessagLibId, InternalPanelId, TimeZone, ReplyTo,
		ReminderSendDate, ReminderSentTime, SendRemindedNow, CreatedOn
	)	
	EXEC SP_ExecuteSql @SqlScript  

	SET ROWCOUNT 0

	SELECT * INTO #DistributeHistory FROM @OrderedKeys OK WHERE OK.RowNum >= @FirstRecord ORDER BY OK.RowNum 

	DECLARE @xmlResult XML

	SET @XmlResult =
	(
		SELECT
		(
			SELECT 
				DH.RowNum, DH.InviteId, DH.ChannelDescription, DH.SurveyId, DH.SurveyName, DH.SendNow, 
				CASE WHEN CONVERT(VARCHAR(10),DH.ToBeSentDate,101) = '01/01/1900' THEN '' 
					 ELSE CONVERT(VARCHAR(10),DH.ToBeSentDate,101) END AS ToBeSentDate, 
				DH.TobeSentTime, DH.SentTime, DH.TobeSentNow, DH.SendReminderAfter, DH.SurveyKey, DH.TwitterPostTitle, 
				DH.TwitterPostMessage, DH.FacebookPostTitle, DH.FacebookPostMessage, DH.InviteFrom, DH.ReplyTo, 
				DH.InviteSubject, DH.EmailBodyType, DH.EmailBody, DH.MessageLibId, DH.ReminderMessagLibId, 
				DH.InternalPanelId, DH.TimeZone, 
				CASE WHEN CONVERT(VARCHAR(10),DH.ReminderSendDate,101)  = '01/01/1900' THEN '' 
					 ELSE CONVERT(VARCHAR(10),DH.ReminderSendDate,101) END AS ReminderSendDate, 
				DH.ReminderSentTime, DH.SendRemindedNow, ISNULL(DH.CreatedOn,'') AS CreatedOn
				FOR XML PATH('Invite'), TYPE 
		) 	
		FROM #DistributeHistory DH
		FOR XML PATH(''), ROOT('XmlResult')
	)	

	SELECT @XmlResult AS XmlResult
	
	SELECT ISNULL(@TotalRecords,0) AS TotalRecords

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END 
	
	