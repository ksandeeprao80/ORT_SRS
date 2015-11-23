IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeletePanelMembers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeletePanelMembers]
GO

--EXEC UspDeletePanelMembers 59 

CREATE PROCEDURE DBO.UspDeletePanelMembers
	@PanelistId INT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	IF EXISTS(SELECT 1 FROM DBO.MS_Invite WHERE InternalPanelId = @PanelistId)
	BEGIN
		SELECT 0 AS RetValue, 'Panel in use, cannot be deleted.' AS Remark
		RETURN
	END

	BEGIN TRAN
		
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
	BEGIN
		DELETE MPM
		FROM DBO.MS_PanelMembers MPM 
		INNER JOIN @UserInfo UI
			ON MPM.CustomerId = UI.CustomerId
		WHERE MPM.PanelistId = @PanelistId
		
		DELETE FROM dbo.MS_Respondent WHERE PanelistId = @PanelistId
			
		SELECT 1 AS RetValue, 'Successfully Panel Members Deleted' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
	BEGIN
		DELETE FROM DBO.MS_PanelMembers WHERE PanelistId = @PanelistId
		
		DELETE FROM dbo.MS_Respondent WHERE PanelistId = @PanelistId

		SELECT 1 AS RetValue, 'Successfully Panel Members Deleted' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
	BEGIN
		DELETE MPM
		FROM DBO.MS_PanelMembers MPM 
		INNER JOIN MS_Respondent MR
			ON MPM.PanelistId = MR.PanelistId
		INNER JOIN @UserInfo UI
			ON MR.CreatedBy = CONVERT(INT,UI.UserId)
		WHERE MPM.PanelistId = @PanelistId
		
		DELETE FROM dbo.MS_Respondent WHERE PanelistId = @PanelistId
			
		SELECT 1 AS RetValue, 'Successfully Panel Members Deleted' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
