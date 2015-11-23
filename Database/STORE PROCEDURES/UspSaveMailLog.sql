IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveMailLog]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveMailLog]

GO
/*
EXEC UspSaveMailLog '<?xml version="1.0" encoding="utf-16"?>
<ArrayOfMailData>
	<FromEmailId>johnnydias@gmail.com</FromEmailId>  
	<EmailFromName>johnny dias</EmailFromName>  
	<ToEmailId>johnnydias@gmail.com</ToEmailId>  
	<CcEmailId>johnnydias@gmail.com</CcEmailId>  
	<BccEmailId>johnnydias@gmail.com</BccEmailId>  
	<ReplyTo>johnny</ReplyTo> 
	<Subject>johnny testing data</Subject>  
	<Attachment>nothing</Attachment>  
	<EmailBody>johnny test got surccess</EmailBody>  
	<HostServer>192.91.201.130</HostServer> 
	<HostPort>ORT_SRS</HostPort>  
	<SmtpUser>srs admin</SmtpUser>  
	<SmtpPassword>jkljkeijecjduerjkeljrekljeajkljerejklkklkklkl</SmtpPassword>  
</ArrayOfMailData>'
*/
		
CREATE PROCEDURE DBO.UspSaveMailLog
	@XMlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData

	DECLARE @RowId INT
	SET @RowId = 0
	
	INSERT INTO DBO.TR_EmailLog
	(
		FromEmailId, EmailFromName, ToEmailId, CcEmailId, BccEmailId, ReplyTo, EmailSubject,
		Attachment, EmailBody, HostServer, HostPort, SmtpUser, SmtpPassword	 
	)	
	SELECT
		Parent.Elm.value('(FromEmailId)[1]','VARCHAR(20)') AS FromEmailId,
		Parent.Elm.value('(EmailFromName)[1]','VARCHAR(20)') AS EmailFromName,
		Parent.Elm.value('(ToEmailId)[1]','VARCHAR(20)') AS ToEmailId,
		Parent.Elm.value('(CcEmailId)[1]','VARCHAR(20)') AS CcEmailId,
		Parent.Elm.value('(BccEmailId)[1]','VARCHAR(50)') AS BccEmailId,
		Parent.Elm.value('(ReplyTo)[1]','VARCHAR(100)') AS ReplyTo,
		Parent.Elm.value('(Subject)[1]','VARCHAR(MAX)') AS EmailSubject,
		Parent.Elm.value('(Attachment)[1]','VARCHAR(20)') AS Attachment,
		Parent.Elm.value('(EmailBody)[1]','VARCHAR(50)') AS EmailBody,
		Parent.Elm.value('(HostServer)[1]','VARCHAR(500)') AS HostServer,
		Parent.Elm.value('(HostPort)[1]','VARCHAR(500)') AS HostPort,
		Parent.Elm.value('(SmtpUser)[1]','VARCHAR(500)') AS SmtpUser,
		Parent.Elm.value('(SmtpPassword)[1]','VARCHAR(500)') AS SmtpPassword 
	--	INTO #MailLog
	FROM @input.nodes('/ArrayOfMailData') AS Parent(Elm)
	
	SET @RowId = @@ROWCOUNT
	
	SELECT 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
			
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



