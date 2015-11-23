IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTrInvite]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTrInvite]

GO
-- EXEC UspGetTrInvite  
CREATE PROCEDURE DBO.UspGetTrInvite
	@InviteId INT = NULL,
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TR.RowId, TR.InviteId, MS.SurveyId, MS.InviteType, TR.PanelMemberId, TR.SentDate, MS.IsActive
	FROM DBO.TR_Invite TR
	INNER JOIN DBO.MS_Invite MS
		ON TR.InviteId = MS.InviteId
 		AND TR.InviteId = ISNULL(@InviteId,TR.InviteId) 
 		AND MS.SurveyId = ISNULL(@SurveyId,MS.SurveyId)
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END