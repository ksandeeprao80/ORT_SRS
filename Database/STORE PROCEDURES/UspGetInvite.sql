IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetInvite]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetInvite]

GO
-- EXEC UspGetInvite  
CREATE PROCEDURE DBO.UspGetInvite
	@InviteId INT = NULL,
	@SurveyId INT = NULL,
	@InviteType INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		InviteId, SurveyId, InviteType, InvitePassword, ToBeSentDate, ExternalPanelEmailId, InternalPanelId, 
		IsActive, SendNow, TobeSentTime, SendReminderAfter	
	FROM DBO.MS_Invite 
 	WHERE InviteId = ISNULL(@InviteId,InviteId) 
 		AND SurveyId = ISNULL(@SurveyId,SurveyId)
		AND InviteType = ISNULL(@InviteType,InviteType)
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END