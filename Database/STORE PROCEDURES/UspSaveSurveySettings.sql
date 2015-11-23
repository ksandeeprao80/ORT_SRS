IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveySettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSurveySettings]
GO
/*
EXEC UspSaveSurveySettings @SurveyId='1193',@XmlData='<?xml version="1.0" encoding="utf-16"?>
<ArrayOfSetting>
  <Setting>
	<SettingId></SettingId>
    <SettingName>LogoFile</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>BackGroundColor</SettingName>
    <Value>Black</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>AutoAdvance</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
    <SettingName>BTN_BACK</SettingName>
    <Value>True</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>ALLOW_SAVE_CONTINUE</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>NextBackTextLink</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>ALLOW_ANONYMOUS</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>BY_INVITE</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>INVITE_HAS_PSW</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>ALLOW_REPEAT</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>E_O_S_MESSAGE</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>E_O_S_MESSAGE_ID</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>E_O_S_MESSAGE_TEXT</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  
  <Setting>
  <SettingId></SettingId>
    <SettingName>E_O_S_REDIRECT</SettingName>
    <Value>True</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>E_O_S_REDIRECT_URL</SettingName>
    <Value>google.com</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>E_O_S_EMAIL</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>E_O_S_EMAIL_ID</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>E_O_S_EMAIL_TEXT</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>ANSWER_FONT</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>ANSWER_FONT_COLOR</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>ANSWER_FONT_SIZE</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>HEADER_FONT</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>HEADER_FONT_SIZE</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>HEADER_FONT_COLOR</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  
  <Setting>
  <SettingId></SettingId>
    <SettingName>QUESTION_FONT</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>QUESTION_FONT_COLOR</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>QUESTION_FONT_SIZE</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>HEADER_SHOW_DATE_TIME</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>DateTimeFormat</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>ValidationAnswerValues</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>CheckSurveyEnd</SettingName>
    <Value>True</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>RewardSet</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>VerifySkipLogic</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>RandomizeTestList</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>TestListRandomNo</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>AutoPlay</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>InvitePassword</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>CheckQuota</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>QuotaCount</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>SendQuotaFullEmail</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>QuotaFullToEmailId</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>QuotaFullMessageId</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
  <SettingId></SettingId>
    <SettingName>TemplateId</SettingName>
    <Value />
    <IsAassigned>false</IsAassigned>
  </Setting>
</ArrayOfSetting>',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
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
CREATE PROCEDURE DBO.UspSaveSurveySettings
	@SurveyId AS INT,
	@XmlData AS NTEXT,
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
	
	DECLARE @UserId INT 
	DECLARE @CustomerId INT
	SELECT @UserId = CONVERT(INT,UserId) FROM @UserInfo
	SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
		
	DECLARE @input XML = @XmlData
	 
	CREATE TABLE #SurveySettings
	(
		SettingName VARCHAR(50), Value NVARCHAR(2000), IsAassigned VARCHAR(20)
	)
	INSERT INTO #SurveySettings
	(
		SettingName, Value, IsAassigned
	)
	SELECT 
		Child.Elm.value('(SettingName)[1]','VARCHAR(50)') AS SettingName,
		Child.Elm.value('(Value)[1]','NVARCHAR(2000)') AS Value,
		Child.Elm.value('(IsAassigned)[1]','VARCHAR(20)') AS IsAassigned
	--INTO #SurveySettings
	FROM @input.nodes('/ArrayOfSetting') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Setting') AS Child(Elm)
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU') 
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END
	ELSE
	BEGIN
		DECLARE @Row INT
		SET @Row = 0
		
		DECLARE @ExInvitePassword VARCHAR(150)
		SET @ExInvitePassword = ''
		 
		SELECT @ExInvitePassword = ISNULL(TSS.Value,'') FROM TR_SurveySettings TSS
		INNER JOIN DBO.MS_SurveySettings MSS ON TSS.SettingId = MSS.SettingId
		AND TSS.SurveyId = @SurveyId AND MSS.SettingName = 'InvitePassword'
		
		DECLARE @InvitePassword VARCHAR(150)
		DECLARE @INVITE_HAS_PSW VARCHAR(150)
		
		SELECT @InvitePassword = LTRIM(RTRIM(Value)) FROM #SurveySettings 
		WHERE LTRIM(RTRIM(SettingName)) = 'InvitePassword'
		
		SELECT @INVITE_HAS_PSW = LTRIM(RTRIM(Value)) FROM #SurveySettings 
		WHERE LTRIM(RTRIM(SettingName)) = 'INVITE_HAS_PSW'	
		
		IF ISNULL(@InvitePassword,'') = '' AND LTRIM(RTRIM(@INVITE_HAS_PSW)) = 'True'
		BEGIN
			UPDATE #SurveySettings
			SET Value = @ExInvitePassword
			WHERE LTRIM(RTRIM(SettingName)) = 'InvitePassword'
		END	
			
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA') 
		BEGIN
			DELETE FROM DBO.TR_SurveySettings WHERE SurveyId = @SurveyId
			
			INSERT INTO DBO.TR_SurveySettings
			(SurveyId, SettingId, CustomerId, Value) 
			SELECT 
				@SurveyId, MSS.SettingId, @CustomerId, SS.Value
			FROM #SurveySettings SS
			INNER JOIN DBO.MS_SurveySettings MSS
				ON LTRIM(RTRIM(SS.SettingName)) = LTRIM(RTRIM(MSS.SettingName))
			 
			SET @Row = @@ROWCOUNT
			 
			SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
				CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU') 
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_Survey WHERE SurveyId = @SurveyId AND CustomerId = @CustomerId)
			BEGIN
				DELETE FROM DBO.TR_SurveySettings WHERE SurveyId = @SurveyId
			
				INSERT INTO DBO.TR_SurveySettings
				(SurveyId, SettingId, CustomerId, Value) 
				SELECT 
					@SurveyId, MSS.SettingId, @CustomerId, SS.Value
				FROM #SurveySettings SS
				INNER JOIN DBO.MS_SurveySettings MSS
					ON LTRIM(RTRIM(SS.SettingName)) = LTRIM(RTRIM(MSS.SettingName))
				 
				SET @Row = @@ROWCOUNT
				 
				SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
			END
			ELSE
			BEGIN
				SELECT 0 AS RetValue, 'Access Denied' AS Remark
			END
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU') 
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_Survey WHERE SurveyId = @SurveyId AND CreatedBy = @UserId)
			BEGIN
				DELETE FROM DBO.TR_SurveySettings WHERE SurveyId = @SurveyId
				
				INSERT INTO DBO.TR_SurveySettings
				(SurveyId, SettingId, CustomerId, Value) 
				SELECT 
					@SurveyId, MSS.SettingId, @CustomerId, SS.Value
				FROM #SurveySettings SS
				INNER JOIN DBO.MS_SurveySettings MSS
					ON LTRIM(RTRIM(SS.SettingName)) = LTRIM(RTRIM(MSS.SettingName))
				 
				SET @Row = @@ROWCOUNT
				 
				SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
			END
			ELSE
			BEGIN
				SELECT 0 AS RetValue, 'Access Denied' AS Remark
			END
		END
	END
	
	DROP TABLE #SurveySettings
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
