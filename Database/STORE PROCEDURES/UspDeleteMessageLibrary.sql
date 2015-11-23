IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteMessageLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteMessageLibrary]
GO

--EXEC UspDeleteMessageLibrary 1 

CREATE PROCEDURE DBO.UspDeleteMessageLibrary
	@MessageLibId INT,
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

	DECLARE @CreatedBy INT, @CustomerId INT
	SELECT @CreatedBy = CONVERT(INT,UserId) FROM @UserInfo
	SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
	BEGIN
		IF EXISTS(SELECT 1 FROM DBO.TR_MessageLibrary WHERE MessageLibId = @MessageLibId AND CreatedBy = @CreatedBy)
		BEGIN
			DELETE FROM DBO.TR_MessageLibrary WHERE MessageLibId = @MessageLibId AND CreatedBy = @CreatedBy
		    SELECT 1 AS RetValue, 'Successfully Message Library Deleted' AS Remark	
		END
		ELSE
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END	
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
	BEGIN
		IF EXISTS(SELECT 1 FROM DBO.TR_MessageLibrary WHERE MessageLibId = @MessageLibId AND CreatedBy = @CreatedBy)
		BEGIN
			DELETE FROM DBO.TR_MessageLibrary WHERE MessageLibId = @MessageLibId AND CreatedBy = @CreatedBy
		    SELECT 1 AS RetValue, 'Successfully Message Library Deleted' AS Remark	
		END
		ELSE
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END	
		--DELETE TML
		--FROM DBO.TR_MessageLibrary TML 
		--INNER JOIN DBO.TR_Library TL
		--	ON TML.LibId = TL.LibId
		--WHERE TL.CustomerId = @CustomerId
		--	AND TML.MessageLibId = @MessageLibId 
			
		--SELECT 1 AS RetValue, 'Successfully Message Library Deleted' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
	BEGIN
		DELETE FROM DBO.TR_MessageLibrary WHERE MessageLibId = @MessageLibId 
		
		SELECT 1 AS RetValue, 'Successfully Message Library Deleted' AS Remark
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

