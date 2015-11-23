IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveEmailDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveEmailDetails]

GO
-- EXEC UspSaveEmailDetails 
CREATE PROCEDURE DBO.UspSaveEmailDetails
	@EmailDetailId INT,
	@QuestionId INT,
	@FromEmailId VARCHAR(150),
	@ToEmailId VARCHAR(150),
	@SendImmediate BIT,
	@DelayInTime VARCHAR(10),
	@MailSent CHAR(1),
	@SentDate DATETIME
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_EmailDetails WITH(NOLOCK)
		WHERE QuestionId = @QuestionId AND FromEmailId = @FromEmailId AND ToEmailId = @ToEmailId
	) 
	BEGIN
		UPDATE DBO.TR_EmailDetails
		SET QuestionId = @QuestionId, 
		    FromEmailId = @FromEmailId, 
		    ToEmailId = @ToEmailId, 
		    SendImmediate = @SendImmediate, 
		    DelayInTime = @DelayInTime, 
		    MailSent = @MailSent, 
		    SentDate = @SentDate
		WHERE EmailDetailId = @EmailDetailId

		SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, 0 AS EmailDetailId
		
		RETURN
	END
	ELSE
	BEGIN
		DECLARE @RowId INT
		SET @RowId = 0
	 
		INSERT INTO DBO.TR_EmailDetails
		(		
			QuestionId, FromEmailId, ToEmailId, SendImmediate, DelayInTime, MailSent, SentDate
		)
		VALUES
		(
			@QuestionId, @FromEmailId, @ToEmailId, @SendImmediate, @DelayInTime, @MailSent, @SentDate
	 	)
	
		SET @RowId = @@IDENTITY
	
		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark, @RowId AS EmailDetailId
		
		RETURN
	END
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark, 0 AS EmailDetailId
END CATCH 

SET NOCOUNT OFF
END