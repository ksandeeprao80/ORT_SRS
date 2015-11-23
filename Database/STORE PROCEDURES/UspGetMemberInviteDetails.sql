IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetMemberInviteDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetMemberInviteDetails]

GO

-- EXEC UspGetMemberInviteDetails 1113,1 
CREATE PROCEDURE DBO.UspGetMemberInviteDetails 
	@SurveyId INT,
	@RespondentId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		RequestId, SurveyId, RespondentId, RespondentSessionId, SurveyPassword, SurveyKey, RenderMode, QuestionId
	FROM DBO.TR_SurveyRequestDetails
	WHERE SurveyId = @SurveyId AND RespondentId = @RespondentId
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END