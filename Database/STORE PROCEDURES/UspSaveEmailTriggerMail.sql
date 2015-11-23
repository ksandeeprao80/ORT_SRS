IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveEmailTriggerMail]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveEmailTriggerMail

GO

-- EXEC UspSaveEmailTriggerMail

CREATE PROCEDURE DBO.UspSaveEmailTriggerMail
	@ToEmailId VARCHAR(100),
	@QuestionId INT,
	@Answer VARCHAR(100),
	@AnswerType VARCHAR(5),
	@RespondentId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @TrgId INT
	SET @TrgId = 0
	
	INSERT INTO DBO.TR_EmailTriggerMails
	(ToEmailId, QuestionId, AnswerId, AnswerType, RespondentId)
	VALUES
	(@ToEmailId, @QuestionId, LTRIM(RTRIM(@Answer)), LTRIM(RTRIM(@AnswerType)), @RespondentId)
	
	SET @TrgId = @@IDENTITY
	
	SELECT CASE WHEN ISNULL(@TrgId,0) = 0 THEN 0 ELSE 1 END AS RetValue,  
			CASE WHEN ISNULL(@TrgId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
			ISNULL(@TrgId,0) AS TrgId
			
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
	
 