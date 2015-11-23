IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdateEmailTriggerMail]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdateEmailTriggerMail

GO

/*
select * from TR_EmailTriggerMailsLog
select * from TR_EmailTriggerMails
EXEC UspUpdateEmailTriggerMail '<?xml version="1.0" encoding="utf-16"?>  
<ArrayOfTriggerMailData>
	<TriggerMailData>
		<EmailTriggerId>1</EmailTriggerId>
		<ToEmailId>ksandeeprao80@gmail.com</ToEmailId>
		<ReplyTo>sandeepr@winsoftech.com</ReplyTo>
		<MailSubject>Email Trigger Mail</MailSubject>
		<MailBody></MailBody>
		<QuestionText>What is your gender ?</QuestionText>
		<AnswerText>Male</AnswerText>
		<IsSuccess>Y</IsSuccess>
		<ErrorMessage>test</ErrorMessage>
	</TriggerMailData>
	<TriggerMailData>
		<EmailTriggerId>2</EmailTriggerId>
		<ToEmailId>ksandeeprao80@gmail.com</ToEmailId>
		<ReplyTo>sandeepr@winsoftech.com</ReplyTo>
		<MailSubject>Email Trigger Mail</MailSubject>
		<MailBody></MailBody>    
		<QuestionText>What is your gender ?</QuestionText>
		<AnswerText>Male</AnswerText>
		<IsSuccess>Y</IsSuccess>
		<ErrorMessage>test</ErrorMessage>
	</TriggerMailData>
	<TriggerMailData>
		<EmailTriggerId>3</EmailTriggerId>
		<ToEmailId>ksandeeprao80@gmail.com</ToEmailId>
		<ReplyTo>sandeepr@winsoftech.com</ReplyTo>
		<MailSubject>Email Trigger Mail</MailSubject>
		<MailBody></MailBody>
		<QuestionText>What is your gender ?</QuestionText>
		<AnswerText>Male</AnswerText>
		<IsSuccess>Y</IsSuccess>
		<ErrorMessage>test</ErrorMessage>
	</TriggerMailData>
	<TriggerMailData>
		<EmailTriggerId>4</EmailTriggerId>
		<ToEmailId>ksandeeprao80@gmail.com</ToEmailId>
		<ReplyTo>sandeepr@winsoftech.com</ReplyTo>
		<MailSubject>Email Trigger Mail</MailSubject>
		<MailBody></MailBody>
		<QuestionText>What is your age ?</QuestionText>
		<AnswerText>25</AnswerText>
		<IsSuccess>Y</IsSuccess>
		<ErrorMessage>test</ErrorMessage>
	</TriggerMailData>
</ArrayOfTriggerMailData>'
*/

CREATE PROCEDURE DBO.UspUpdateEmailTriggerMail
	@XMlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	
	CREATE TABLE #MailsLog
	(
		TrgId INT, ToEmailId VARCHAR(100), ReplyTo VARCHAR(100), MailSubject VARCHAR(100), 
		IsSuccess VARCHAR(5), ErrorMessage VARCHAR(500)
	)
	INSERT INTO #MailsLog
	(TrgId, ToEmailId, ReplyTo, MailSubject, IsSuccess, ErrorMessage)
	SELECT
		Child.Elm.value('(EmailTriggerId)[1]','VARCHAR(12)') AS TrgId,
		Child.Elm.value('(ToEmailId)[1]','VARCHAR(100)') AS ToEmailId,
		Child.Elm.value('(ReplyTo)[1]','VARCHAR(100)') AS ReplyTo,
		Child.Elm.value('(MailSubject)[1]','VARCHAR(100)') AS MailSubject,
		Child.Elm.value('(IsSuccess)[1]','VARCHAR(5)') AS IsSuccess,
		Child.Elm.value('(ErrorMessage)[1]','VARCHAR(500)') AS ErrorMessage
	FROM @input.nodes('/ArrayOfTriggerMailData') AS Parent(Elm)
	CROSS APPLY 
		Parent.Elm.nodes('TriggerMailData') AS Child(Elm)	

	DECLARE @RowId INT
	DECLARE @CurrentDate DATETIME
	SET @RowId = 0
	SET @CurrentDate = GETDATE()

	INSERT INTO DBO.TR_EmailTriggerMailsLog
	(TrgId, ToEmailId, ReplyTo, MailSubject, SentDate, IsSuccess, ErrorMessage)
	SELECT 
		TrgId, ToEmailId, ReplyTo, MailSubject, @CurrentDate, IsSuccess, ErrorMessage
	FROM #MailsLog
	
	SET @RowId = @@ROWCOUNT
 
	IF @RowId <> 0 
	BEGIN	
		IF EXISTS(SELECT 1 FROM #MailsLog WHERE LEFT(LTRIM(RTRIM(IsSuccess)),1) = 'Y')
		BEGIN
			UPDATE TETM
			SET TETM.SentDate = @CurrentDate
			FROM DBO.TR_EmailTriggerMails TETM
			INNER JOIN #MailsLog ML
				ON TETM.TrgId = ML.TrgId
				AND LEFT(LTRIM(RTRIM(IsSuccess)),1) = 'Y'
		END
	END	

	SELECT 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Update Failed' ELSE 'Successfully Updated' END AS Remark	
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
	
 