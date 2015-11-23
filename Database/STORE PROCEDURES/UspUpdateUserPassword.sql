IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdateUserPassword]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdateUserPassword
GO
/* 
EXEC UspUpdateUserPassword '<?xml version="1.0" encoding="utf-16"?>
<User>
	<UserId>9</UserId>
	<LoginId>pubuser</LoginId>
	<UserCode>fiel02</UserCode>
	<UserName>TestuserName</UserName>
	<Password>johnnytest</Password>
	<EmailId>test@shd.com</EmailId>
	<UserDetails>
		<IsActive>true</IsActive>
		<Phone1>123564-21331</Phone1>
		<Phone2>123-123</Phone2>
		<TimeZone>2</TimeZone>
		<Language>2</Language>
		<Department>HR</Department>
		<Customer>
			<CustomerId>1</CustomerId>
			<IsActive>false</IsActive>
		</Customer>
		<UserRole>
		 	<RoleId>1</RoleId>
		</UserRole>
	</UserDetails>
	<CreatedBy>
		<UserId />
	</CreatedBy>
	<ModifiedBy>
		<UserId>5</UserId>
	</ModifiedBy>
	<ModifiedOn>2012-09-24 13:36:26.160</ModifiedOn>
</User>'
*/
CREATE PROCEDURE DBO.UspUpdateUserPassword
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	-------------------------------------------------------------------------------------
	CREATE TABLE #Users
	(UserId INT, UserPassword VARCHAR(100))
	INSERT INTO #Users
	(UserId, UserPassword)
	SELECT
		Parent.Elm.value('(UserId)[1]','VARCHAR(20)') AS UserId,
		Parent.Elm.value('(Password)[1]','VARCHAR(100)') AS UserPassword
	FROM @input.nodes('/User') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('UserDetails') AS Child(Elm)
	CROSS APPLY
		Child.Elm.nodes('Customer') AS Child2(Elm)
	CROSS APPLY
		Parent.Elm.nodes('CreatedBy') AS Child3(Elm)
	CROSS APPLY
		Parent.Elm.nodes('ModifiedBy') AS Child4(Elm)
	CROSS APPLY
		Child.Elm.nodes('UserRole') AS Child5(Elm)

	DECLARE @RowId INT
	SET @RowId = 0
	
	UPDATE MU
	SET MU.UserPassword = U.UserPassword,
		MU.ModifiedBy = U.UserId,
		MU.ModifiedOn = GETDATE()
	FROM DBO.MS_Users MU
	INNER JOIN #Users U
	ON MU.UserId = U.UserId
				
	SET @RowId = @@ROWCOUNT
	
	SELECT CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Update Failed' ELSE 'Successfully Updated' END AS Remark,
		UserId  
	FROM #Users	

	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 

