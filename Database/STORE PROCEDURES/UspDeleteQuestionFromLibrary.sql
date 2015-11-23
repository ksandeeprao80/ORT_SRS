IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteQuestionFromLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteQuestionFromLibrary]
GO
/*
EXEC UspDeleteQuestionFromLibrary @QuestionLibId='45',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>77</UserId>
  <UserName>Samsung</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <UserRole>
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>2</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/
CREATE PROCEDURE DBO.UspDeleteQuestionFromLibrary
	@QuestionLibId INT,
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
	SELECT @CreatedBy = CONVERT(INT,UserId), @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
	BEGIN
		UPDATE dbo.TR_QuestionLibrary
		SET IsActive = 0,
			ModifiedOn = GETDATE()
		WHERE QuestionLibId = @QuestionLibId
	
		SELECT 1 AS RetValue, 'Successfully Updated' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','GU'))
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM dbo.TR_QuestionLibrary TQL INNER JOIN TR_Library TL 
			ON TQL.LibId = TL.LibId AND TQL.QuestionLibId = @QuestionLibId AND TL.CreatedBy = @CreatedBy
		)
		BEGIN	
			UPDATE dbo.TR_QuestionLibrary
			SET IsActive = 0,
				ModifiedOn = GETDATE()
			WHERE QuestionLibId = @QuestionLibId
		
			SELECT 1 AS RetValue, 'Successfully Updated' AS Remark
		END
		ELSE
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END
	END
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

