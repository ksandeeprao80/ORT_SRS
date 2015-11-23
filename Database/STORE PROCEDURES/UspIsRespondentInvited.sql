IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspIsRespondentInvited]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspIsRespondentInvited

GO

-- EXEC UspIsRespondentInvited 
CREATE PROCEDURE DBO.UspIsRespondentInvited
	@RespondentId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @PanelistId INT
	SET @PanelistId = 0
	
	SELECT @PanelistId = PanelistId FROM DBO.MS_Respondent WHERE RespondentId = @RespondentId
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.MS_Invite WHERE InternalPanelId = @PanelistId
	)
	BEGIN
		SELECT 1 AS RetValue, 'Panelist Exist In The System' AS Remark
	END
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'Panelist Not Exist In The System' AS Remark
	END

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

