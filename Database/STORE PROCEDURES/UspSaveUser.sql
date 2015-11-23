IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveUser]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveUser
GO
/*
EXEC UspSaveUser '<?xml version="1.0" encoding="utf-16"?>
<User>
	<UserId>44</UserId>
	<LoginId>pubuser</LoginId>
	<UserCode>fiel02</UserCode>
	<UserName>TestuserName</UserName>
	<Password />
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
CREATE PROCEDURE DBO.UspSaveUser
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	-------------------------------------------------------------------------------------
	CREATE TABLE #Users
	(
		UserId VARCHAR(20), LoginId VARCHAR(30), UserCode VARCHAR(20), UserName VARCHAR(50), [Password] VARCHAR(100),
		EmailId VARCHAR(50), IsActive VARCHAR(10), Phone1 VARCHAR(20), Phone2 VARCHAR(20), LanguageId VARCHAR(50),
		TimeZoneId VARCHAR(150), Department VARCHAR(150), CustomerId VARCHAR(20), CustomerStatus VARCHAR(20),
		CreatedBy VARCHAR(20), ModifiedBy VARCHAR(20), ModifiedOn VARCHAR(25), RoleId VARCHAR(20) 
	)
	INSERT INTO #Users
	(
		UserId, LoginId, UserCode, UserName, [Password], EmailId, IsActive, Phone1, Phone2, LanguageId, TimeZoneId, 
		Department, CustomerId, CustomerStatus, CreatedBy, ModifiedBy, ModifiedOn, RoleId
	)
	SELECT
		Parent.Elm.value('(UserId)[1]','VARCHAR(20)') AS UserId,
		Parent.Elm.value('(LoginId)[1]','VARCHAR(30)') AS LoginId,
		Parent.Elm.value('(UserCode)[1]','VARCHAR(20)') AS UserCode,
		Parent.Elm.value('(UserName)[1]','VARCHAR(50)') AS UserName,
		Parent.Elm.value('(Password)[1]','VARCHAR(100)') AS [Password],
		Parent.Elm.value('(EmailId)[1]','VARCHAR(50)') AS EmailId,
		--For the UserDetails----------
		Child.Elm.value('(IsActive)[1]','VARCHAR(10)') AS IsActive,
		Child.Elm.value('(Phone1)[1]','VARCHAR(20)') AS Phone1,
		Child.Elm.value('(Phone2)[1]','VARCHAR(20)') AS Phone2,
		Child.Elm.value('(Language)[1]','VARCHAR(50)') AS LanguageId,
		Child.Elm.value('(TimeZone)[1]','VARCHAR(150)') AS TimeZoneId,
        Child.Elm.value('(Department)[1]','VARCHAR(150)') AS Department,
		-- ******************For the Customer/Customer Node*********-----------------
		Child2.Elm.value('(CustomerId)[1]', 'VARCHAR(20)') AS CustomerId,
		Child2.Elm.value('(IsActive)[1]', 'VARCHAR(20)') AS CustomerStatus,
		Child3.Elm.value('(UserId)[1]','VARCHAR(20)') AS CreatedBy,
		Child4.Elm.value('(UserId)[1]','VARCHAR(20)') AS ModifiedBy,
		Parent.Elm.value('(ModifiedOn)[1]','VARCHAR(25)') AS ModifiedOn,
		Child5.Elm.value('(RoleId)[1]','VARCHAR(20)') AS RoleId
	--INTO #Users
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

	DECLARE @NewUserId INT,
		@UserId VARCHAR(50),
		@Remark VARCHAR(100)
	SET @NewUserId = 0
	SET @UserId = ''
	SET @Remark = ''
	
	IF EXISTS(SELECT 1 FROM #Users WHERE UserId <> 'undefined')
	BEGIN 
		DECLARE @Count INT, 
			@ModifiedOn VARCHAR(25)
		SET @Count = 0

		SELECT @ModifiedOn = CONVERT(VARCHAR(25),MU.ModifiedOn,121) FROM DBO.MS_Users MU INNER JOIN #Users U ON CONVERT(VARCHAR,MU.UserId) = U.UserId

		SELECT @Count = COUNT(1) FROM #Users WHERE LTRIM(RTRIM(ModifiedOn)) = LTRIM(RTRIM(@ModifiedOn))
		IF @Count = 0 
		--Checking for concurrency issue
		BEGIN
			SELECT @UserId = UserId, @Remark = 'Kindly capture the latest data' FROM #Users WHERE UserId <> 'undefined'
		END
		ELSE
		BEGIN		
			-- Exist Users update query	
			UPDATE MU
			SET --MU.LoginId = CASE WHEN ISNULL(LTRIM(RTRIM(U.LoginId)),'') = '' THEN MU.LoginId ELSE LTRIM(RTRIM(U.LoginId)) END,
			    MU.UserName = CASE WHEN ISNULL(U.UserName,'') = '' THEN MU.UserName ELSE LTRIM(RTRIM(U.UserName)) END,
			    MU.UserCode = CASE WHEN ISNULL(U.UserCode,'') = '' THEN MU.UserCode ELSE LTRIM(RTRIM(U.UserCode)) END,
			    MU.UserPassword =  CASE WHEN ISNULL(U.[Password],'') = '' THEN MU.UserPassword ELSE LTRIM(RTRIM(U.[Password])) END,
			    MU.CustomerId = CONVERT(INT,U.CustomerId),
			    MU.EmailId = CASE WHEN ISNULL(U.EmailId,'') = '' THEN MU.EmailId ELSE LTRIM(RTRIM(U.EmailId)) END,
			    MU.IsActive = CASE WHEN LTRIM(RTRIM(U.IsActive)) = 'FALSE' THEN 0 ELSE 1 END,
			    MU.UserType = CASE WHEN ISNULL(MR.RoleType,'') = '' THEN MU.UserType ELSE LTRIM(RTRIM(MR.RoleType)) END,
			    MU.LangauageName = LTRIM(RTRIM(ML.LangauageName)), 
			    MU.TimeZone = CASE WHEN ISNULL(U.TimeZoneId,'') = '' THEN MU.TimeZone ELSE CONVERT(INT,U.TimeZoneId) END, 
			    MU.Phone1 = LTRIM(RTRIM(U.Phone1)), 
			    MU.Phone2 = LTRIM(RTRIM(U.Phone2)), 
			    --MU.Department = LTRIM(RTRIM(U.Department)),
			    MU.ModifiedBy = CASE WHEN U.ModifiedBy = '0' OR ISNULL(U.ModifiedBy,'') = '' THEN MU.ModifiedBy ELSE CONVERT(INT,U.ModifiedBy) END,
			    MU.ModifiedOn = GETDATE()
			FROM DBO.MS_Users MU
			INNER JOIN #Users U
				ON MU.UserId = CONVERT(INT,U.UserId)
			LEFT OUTER JOIN DBO.MS_Languages ML
				ON U.LanguageId = ML.LanguageId
			--LEFT OUTER JOIN DBO.MS_TimeZone MTZ
				--ON MTZ.TimeZoneId = U.TimeZoneId
			LEFT OUTER JOIN DBO.MS_Roles MR  
				ON CONVERT(INT,U.RoleId) = MR.RoleId
			WHERE U.UserId <> 'undefined' 
				AND LTRIM(RTRIM(MU.UserName)) <> 'SYSADMIN'
	
			SELECT @UserId = UserId, @Remark = 'Successfully Updated' FROM #Users WHERE UserId <> 'undefined'
		END
	END
	ELSE
	BEGIN
		-- New Users insert query
		INSERT INTO DBO.MS_Users
		(
			LoginId, UserCode, UserName, UserPassword, CustomerId, EmailId, IsActive, UserType, LangauageName, TimeZone, 
			Phone1, Phone2, Department, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
		)
		SELECT 
			LTRIM(RTRIM(U.LoginId)), LTRIM(RTRIM(U.UserCode)), LTRIM(RTRIM(U.UserName)), 
			LTRIM(RTRIM(U.[Password])), CONVERT(INT,U.CustomerId), LTRIM(RTRIM(U.EmailId)), 
			CASE WHEN LTRIM(RTRIM(U.IsActive)) = 'FALSE' THEN 0 ELSE 1 END, 
			LTRIM(RTRIM(MR.RoleType)), LTRIM(RTRIM(ML.LangauageName)), U.TimeZoneId, 
			LTRIM(RTRIM(U.Phone1)), LTRIM(RTRIM(U.Phone2)), LTRIM(RTRIM(U.Department)), 
			CONVERT(INT,U.CreatedBy), GETDATE(), CONVERT(INT,U.CreatedBy), GETDATE() 
		FROM #Users U
		INNER JOIN DBO.MS_Roles MR  
			ON CONVERT(INT,U.RoleId) = MR.RoleId
		INNER JOIN DBO.MS_Languages ML
			ON U.LanguageId = ML.LanguageId
		--INNER JOIN DBO.MS_TimeZone MTZ
			--ON MTZ.TimeZoneId = U.TimeZoneId
		LEFT OUTER JOIN DBO.MS_Users MU
			ON LTRIM(RTRIM(U.LoginId)) = LTRIM(RTRIM(MU.LoginId))
		WHERE ISNULL(MU.LoginId,'') = ''
			AND U.UserId = 'undefined' 
	
		SET @NewUserId = @@IDENTITY

		IF ISNULL(@NewUserId,0) = 0 
		BEGIN 
			SET @Remark = 'Login Id Already Exist'
		END
		ELSE
		BEGIN
			SET @Remark = 'Successfully Inserted'
		END
	END
	
	SELECT
 		CASE WHEN @Remark = 'Kindly capture the latest data' THEN 0 
 			 WHEN @Remark = 'Login Id Already Exist' THEN 0
 			 ELSE 1 END AS RetValue, 
 		@Remark AS Remark,
		CASE WHEN @Remark = 'Successfully Inserted' THEN CONVERT(VARCHAR(12),@NewUserId)
		     WHEN @Remark = 'Successfully Updated' THEN @UserId 
			 WHEN @Remark = 'Kindly capture the latest data' THEN @UserId ELSE '0' END AS UserId
		
	DROP TABLE #Users

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

