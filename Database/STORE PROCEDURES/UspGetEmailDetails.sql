IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetEmailDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetEmailDetails]

GO

-- EXEC UspGetEmailDetails 
CREATE PROCEDURE DBO.UspGetEmailDetails
	@EmailDetailId INT = NULL,
	@QuestionId INT = NULL,
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TED.EmailDetailId, TED.QuestionId, TED.FromEmailId, TED.ToEmailId,
		ISNULL(TED.SendImmediate,0) AS SendImmediate, ISNULL(TED.DelayInTime,'') AS DelayInTime, 
		ISNULL(TED.MailSent,'') AS MailSent, ISNULL(TED.SentDate,'') AS SentDate,
		TSQ.SurveyId
	FROM DBO.TR_EmailDetails TED
	INNER JOIN TR_SurveyQuestions TSQ
		ON TED.QuestionId = TSQ.QuestionId AND TED.EmailDetailId = ISNULL(@EmailDetailId,TED.EmailDetailId)
		AND TED.QuestionId = ISNULL(@QuestionId,TED.QuestionId) AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId)
		AND TSQ.IsDeleted = 1
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END