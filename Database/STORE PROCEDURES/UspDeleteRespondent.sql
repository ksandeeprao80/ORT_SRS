IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteRespondent]
GO

--EXEC UspDeleteRespondent 45 

CREATE PROCEDURE DBO.UspDeleteRespondent
	@RespondentId INT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
	BEGIN
		DELETE MR
		FROM DBO.MS_Respondent MR 
		INNER JOIN @UserInfo UI
			ON MR.CustomerId = UI.CustomerId
		WHERE MR.RespondentId = @RespondentId
			
		SELECT 1 AS RetValue, 'Successfully Respondent Deleted' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
	BEGIN
		DELETE DBO.MS_Respondent WHERE RespondentId = @RespondentId

		SELECT 1 AS RetValue, 'Successfully Respondent Deleted' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','SLU'))
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

 