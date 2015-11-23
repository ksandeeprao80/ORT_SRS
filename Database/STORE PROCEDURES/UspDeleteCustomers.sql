IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteCustomers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteCustomers]
GO

--EXEC UspDeleteCustomers 'Shree Radio','FM 31'
--EXEC UspDeleteCustomers 'M-TV','FM 45'
/*
EXEC UspDeleteCustomers @CustomerName='My FM',@Abbreviation='',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>5</UserId>
  <UserName>Nilesh More</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <UserRole>
      <RoleId>2</RoleId>
      <RoleDesc>SRS Admin</RoleDesc>
      <Hierarchy>1</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/
CREATE PROCEDURE DBO.UspDeleteCustomers
	@CustomerName VARCHAR(150),
	@Abbreviation VARCHAR(20),
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

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM DBO.MS_Customers MC INNER JOIN dbo.MS_Users MU ON MC.CustomerId = MU.CustomerId
			WHERE LTRIM(RTRIM(MC.CustomerName)) = LTRIM(RTRIM(@CustomerName))
				--AND LTRIM(RTRIM(MC.Abbreviation)) = LTRIM(RTRIM(@Abbreviation))
		)
		BEGIN
			SELECT 1 AS RetValue, 'Company Can not Deleted ' AS Remark
		END
		ELSE
		BEGIN
			DELETE FROM DBO.MS_Customers
			WHERE LTRIM(RTRIM(CustomerName)) = LTRIM(RTRIM(@CustomerName))
				--AND LTRIM(RTRIM(Abbreviation)) = LTRIM(RTRIM(@Abbreviation))

			SELECT 1 AS RetValue, 'Successfully Company Deleted' AS Remark
		END
	END
	ELSE
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

