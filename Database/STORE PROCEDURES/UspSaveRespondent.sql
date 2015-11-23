IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveRespondent
GO
/*   
--select * from ms_respondent where customerid = 46 and emailid = 'ksandeeprao80@gmail.com'
EXEC UspSaveRespondent @XMlData='<?xml version="1.0" encoding="utf-16"?>
<Respondent>
  <RespondentId>undefined</RespondentId>
  <RespondentCode />
  <Panel>
    <LibType>Panel</LibType>
    <PanelId>84</PanelId>
    <LastUsed>0001-01-01T00:00:00</LastUsed>
    <IsPanelActive>false</IsPanelActive>
  </Panel>
  <FirstName>SandeepRao</FirstName>
  <LastName>RaoSandeep</LastName>
  <Gender>male</Gender>
  <Age />
  <BirthDate>1981-04-12</BirthDate>
  <Town>Mumbai</Town>
  <RespondentEmailId>ksandeeprao80@gmail.com</RespondentEmailId>
  <ZipCode>400607</UserDefineColumn1>
  <Ethnicity />
  <City />
  <Region />
  <Country />
  <IsRespondentDeleted>true</IsRespondentDeleted>
  <IsRespondentActive>true</IsRespondentActive>
  <Customer>
    <CustomerId>46</CustomerId>
    <IsActive>false</IsActive>
  </Customer>
  <CreatedBy>
    <UserId>116</UserId>
  </CreatedBy>
  <ModifiedBy />
  <Status />
</Respondent>',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>116</UserId>
  <UserName>GRPUsr One</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>46</CustomerId>
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

CREATE PROCEDURE DBO.UspSaveRespondent
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
	
	DECLARE @UserId INT, @CustomerId INT, @RoleDesc VARCHAR(3)
	SELECT @UserId = CONVERT(INT,UserId), @CustomerId = CONVERT(INT,CustomerId), @RoleDesc = RoleDesc FROM @UserInfo

	DECLARE @input XML = @XmlData
	---------------------------------------------------------------------------------------

	CREATE TABLE #Respondent
	(
		RespondentId VARCHAR(20), FirstName VARCHAR(50), LastName VARCHAR(50), Gender VARCHAR(20), BirthDate VARCHAR(50),
		Town VARCHAR(50), EmailId VARCHAR(50), UDF1 VARCHAR(50), UDF2 VARCHAR(50), UDF3 VARCHAR(50), UDF4 VARCHAR(50),
		UDF5 VARCHAR(50), IsRespondentDeleted VARCHAR(20), IsRespondentActive VARCHAR(20), CreatedBy VARCHAR(20),
		ModifiedBy VARCHAR(20), CustomerId VARCHAR(20), IsActive VARCHAR(10), PanelistId VARCHAR(20), LastUsed VARCHAR(50),
		IsPanelActive VARCHAR(20), Age VARCHAR(20) 
	)
	INSERT INTO #Respondent
	(
		RespondentId, FirstName, LastName, Gender, BirthDate, Town, EmailId, UDF1, UDF2, UDF3, UDF4, UDF5, 
		IsRespondentDeleted, IsRespondentActive, Age, CreatedBy, ModifiedBy, CustomerId, IsActive, PanelistId, 
		LastUsed, IsPanelActive
	)
	SELECT
		Parent.Elm.value('(RespondentId)[1]','VARCHAR(20)') AS RespondentId,
		Parent.Elm.value('(FirstName)[1]','VARCHAR(50)') AS FirstName,
		Parent.Elm.value('(LastName)[1]','VARCHAR(50)') AS LastName,
		Parent.Elm.value('(Gender)[1]','VARCHAR(20)') AS Gender,
		Parent.Elm.value('(BirthDate)[1]','VARCHAR(50)') AS BirthDate,
		Parent.Elm.value('(Town)[1]','VARCHAR(50)') AS Town,
		Parent.Elm.value('(RespondentEmailId)[1]','VARCHAR(50)') AS EmailId,
		Parent.Elm.value('(ZipCode)[1]','VARCHAR(50)') AS UDF1,
		Parent.Elm.value('(Ethnicity)[1]','VARCHAR(50)') AS UDF2,
		Parent.Elm.value('(City)[1]','VARCHAR(50)') AS UDF3,
		Parent.Elm.value('(Region)[1]','VARCHAR(50)') AS UDF4,
		Parent.Elm.value('(Country)[1]','VARCHAR(50)') AS UDF5,
		Parent.Elm.value('(IsRespondentDeleted)[1]','VARCHAR(20)') AS IsRespondentDeleted,
		Parent.Elm.value('(IsRespondentActive)[1]','VARCHAR(20)') AS IsRespondentActive,
		Parent.Elm.value('(Age)[1]','VARCHAR(20)') AS Age,
		Child3.Elm.value('(UserId)[1]','VARCHAR(20)') AS CreatedBy,
		Child4.Elm.value('(UserId)[1]','VARCHAR(20)') AS ModifiedBy,
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(10)') AS IsActive,
		Child1.Elm.value('(PanelId)[1]','VARCHAR(20)') AS PanelistId,
		Child1.Elm.value('(LastUsed)[1]','VARCHAR(50)') AS LastUsed,
		Child1.Elm.value('(IsPanelActive)[1]','VARCHAR(20)') AS IsPanelActive
	--INTO #Respondent
	FROM @input.nodes('/Respondent') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Panel') AS Child1(Elm)
	CROSS APPLY
		Parent.Elm.nodes('CreatedBy') AS Child3(Elm)
	CROSS APPLY
		Parent.Elm.nodes('ModifiedBy') AS Child4(Elm)

	DECLARE @RespondentId INT
	DECLARE @RetValue INT
	DECLARE @Remark VARCHAR(50)
	SET @RespondentId = 0
	SET @RetValue = 0
	SET @Remark = ''

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
	BEGIN
		SET @RetValue = 0 
		SET @Remark = 'Access Denied'  
	END
			
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('GU','SU'))
	BEGIN
		IF NOT EXISTS
		(
			SELECT 1 FROM #Respondent R
			INNER JOIN dbo.MS_PanelMembers MPM
				ON CONVERT(INT,R.PanelistId) = MPM.PanelistId
				AND MPM.CustomerId = @CustomerId
		)
		BEGIN
			SET @RetValue = 0 
			SET @Remark = 'Access Denied'  
		END	
		ELSE
		BEGIN
			DECLARE @MemberRoleDesc VARCHAR(2)
			SET @MemberRoleDesc = ''
			
			SELECT @MemberRoleDesc = MU.UserType FROM #Respondent R
			INNER JOIN dbo.MS_PanelMembers MPM
				ON CONVERT(INT,R.PanelistId) = MPM.PanelistId
			INNER JOIN DBO.TR_Library TL		
				ON MPM.LibId = TL.LibId
			INNER JOIN DBO.MS_Users	MU
				ON TL.CreatedBy = MU.UserId
				
			IF @MemberRoleDesc = 'SA'
			BEGIN
				SET @RetValue = 0 
				SET @Remark = 'Access Denied'  
			END	
			ELSE
			BEGIN
				SET @RetValue = 1 
			END
		END
	END
	ELSE IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SA'))
	BEGIN
	  SET @RetValue = 1 
	END	

	IF ISNULL(@RetValue,0) <> 0
	BEGIN
		IF EXISTS(SELECT 1 FROM #Respondent WHERE RespondentId = 'undefined')
		BEGIN
			IF EXISTS
			(
				SELECT 1 FROM DBO.MS_Respondent MR INNER JOIN #Respondent R
				ON LTRIM(RTRIM(MR.EmailId)) = LTRIM(RTRIM(R.EmailId))
				AND MR.CustomerId = CONVERT(INT,R.CustomerId)
				AND MR.IsActive = 1
				--For diff. customer with same email it will allow but for same customer it will throw in exception
			)
			BEGIN
				SET @RetValue = 0 
				SET @Remark = 'Already Email id exists for the same customer' 
			END
			ELSE
			BEGIN
				-- New Respondent insert query
				INSERT INTO DBO.MS_Respondent
				(
					CustomerId, EmailId, PanelistId, IsActive, IsDeleted, FirstName, LastName, BirthDate, Gender, 
					Town, UDF1, UDF2, UDF3, UDF4, UDF5, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, Age
				)
				SELECT 
					CONVERT(INT,R.CustomerId), LTRIM(RTRIM(R.EmailId)), CONVERT(INT,R.PanelistId), 
					CASE WHEN LTRIM(RTRIM(R.IsRespondentActive)) = 'FALSE' THEN 0 ELSE 1 END,
					CASE WHEN LTRIM(RTRIM(R.IsRespondentDeleted)) = 'FALSE' THEN 0 ELSE 1 END,
					LTRIM(RTRIM(R.FirstName)), LTRIM(RTRIM(R.LastName)), LTRIM(RTRIM(R.BirthDate)),
					LTRIM(RTRIM(R.Gender)), LTRIM(RTRIM(R.Town)), LTRIM(RTRIM(R.UDF1)), LTRIM(RTRIM(R.UDF2)), 
					LTRIM(RTRIM(R.UDF3)), LTRIM(RTRIM(R.UDF4)), LTRIM(RTRIM(R.UDF5)), CONVERT(INT,R.CreatedBy),
					GETDATE(), CONVERT(INT,R.CreatedBy), GETDATE(), CONVERT(INT,R.Age)
				FROM #Respondent R
				INNER JOIN dbo.MS_PanelMembers MPM
					ON CONVERT(INT,R.PanelistId) = MPM.PanelistId
					AND MPM.CustomerId = CASE WHEN @RoleDesc = 'SA' THEN MPM.CustomerId ELSE @CustomerId END 
				WHERE R.RespondentId = 'undefined' 

				SET @RespondentId = @@IDENTITY

				UPDATE DBO.MS_Respondent
				SET RespondentCode = 'Res'+CONVERT(VARCHAR(12),@RespondentId)-- For time being "Res" used
				WHERE RespondentId = @RespondentId
				
				SET @RetValue = CASE WHEN ISNULL(@RespondentId,0) = 0 THEN 0 ELSE 1 END
				SET @Remark = CASE WHEN ISNULL(@RespondentId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END
			END
		END
		ELSE
		BEGIN
			IF EXISTS
			(
				SELECT 1 FROM DBO.MS_Respondent MR INNER JOIN #Respondent R
				ON LTRIM(RTRIM(MR.EmailId)) = LTRIM(RTRIM(R.EmailId))
				AND MR.CustomerId = CONVERT(INT,R.CustomerId)
				AND MR.RespondentId <> CONVERT(INT,R.RespondentId)
				AND MR.IsActive = 1
				--For diff. customer with same email it will allow but for same customer it will throw in exception
			)
			BEGIN
				SET @RetValue = 0 
				SET @Remark = 'Already Email id exists for the same customer'
				SELECT @RespondentId = CONVERT(INT,RespondentId) FROM #Respondent
			END
			ELSE
			BEGIN
				-- Exist Respondent update query	
				UPDATE MR
				SET MR.EmailId = CASE WHEN ISNULL(R.EmailId,'') = '' THEN MR.EmailId ELSE LTRIM(RTRIM(R.EmailId)) END,
					MR.IsActive = CASE WHEN LTRIM(RTRIM(R.IsRespondentActive)) = 'FALSE' THEN 0 ELSE 1 END,
					MR.IsDeleted = CASE WHEN LTRIM(RTRIM(R.IsRespondentDeleted)) = 'FALSE' THEN 0 ELSE 1 END,	
					MR.FirstName = CASE WHEN ISNULL(R.FirstName,'') = '' THEN MR.FirstName ELSE LTRIM(RTRIM(R.FirstName)) END,
					MR.LastName = CASE WHEN ISNULL(R.LastName,'') = '' THEN MR.LastName ELSE LTRIM(RTRIM(R.LastName)) END,
					MR.BirthDate = CASE WHEN ISNULL(R.BirthDate,'') = '' THEN MR.BirthDate ELSE LTRIM(RTRIM(R.BirthDate)) END,
					MR.Gender = CASE WHEN ISNULL(R.Gender,'') = '' THEN MR.Gender ELSE LTRIM(RTRIM(R.Gender)) END,
					MR.Town = CASE WHEN ISNULL(R.Town,'') = '' THEN MR.Town ELSE LTRIM(RTRIM(R.Town)) END,
					MR.UDF1 = CASE WHEN ISNULL(R.UDF1,'') = '' THEN MR.UDF1 ELSE LTRIM(RTRIM(R.UDF1)) END,
					MR.UDF2 = CASE WHEN ISNULL(R.UDF2,'') = '' THEN MR.UDF2 ELSE LTRIM(RTRIM(R.UDF2)) END,
					MR.UDF3 = CASE WHEN ISNULL(R.UDF3,'') = '' THEN MR.UDF3 ELSE LTRIM(RTRIM(R.UDF3)) END,
					MR.UDF4 = CASE WHEN ISNULL(R.UDF4,'') = '' THEN MR.UDF4 ELSE LTRIM(RTRIM(R.UDF4)) END,
					MR.UDF5 = CASE WHEN ISNULL(R.UDF5,'') = '' THEN MR.UDF5 ELSE LTRIM(RTRIM(R.UDF5)) END,
					MR.ModifiedBy = CASE WHEN ISNULL(R.ModifiedBy,'') = '' THEN MR.ModifiedBy ELSE CONVERT(INT,R.ModifiedBy) END,
					MR.ModifiedOn = GETDATE(),
					MR.Age = CASE WHEN ISNULL(R.Age,'') = '' THEN MR.Age ELSE CONVERT(INT,R.Age) END
				FROM DBO.MS_Respondent MR
				INNER JOIN #Respondent R
					ON MR.RespondentId = CONVERT(INT,R.RespondentId)
				WHERE R.RespondentId <> 'undefined' 
				
				SELECT @RespondentId = CONVERT(INT,RespondentId) FROM #Respondent
				
				SET @RetValue = 1
				SET @Remark = 'Successfully Updated'
			END	
		END 
	END 

	SELECT @RetValue AS RetValue, @Remark AS Remark, ISNULL(@RespondentId,0) AS RespondentId
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

