IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetLogedInUserData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetLogedInUserData
GO
/*
EXEC UspGetLogedInUserData '<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>65</UserId>
  <LoginId>MtvGuser</LoginId>
  <UserCode />
  <UserName>Jdias</UserName>
  <Password>ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad</Password>
  <EmailId>jdias@winso.com</EmailId>
  <UserDetails>
    <IsActive>true</IsActive>
    <Phone1>91-44129909</Phone1>
    <Phone2>91-545114211</Phone2>
    <TimeZone>1</TimeZone>
    <Language>1</Language>
    <Department />
    <Customer>
      <CustomerId>45</CustomerId>
      <CustomerName>M-TV</CustomerName>
      <Abbreviation>FM 45</Abbreviation>
      <ContactPerson>Bret Heart</ContactPerson>
      <Address1>Canada Cold Lake</Address1>
      <Address2>Cold Lake</Address2>
      <ZipCode>1234567</ZipCode>
      <CityCode>5806</CityCode>
      <StateCode>69</StateCode>
      <CountryCode>9</CountryCode>
      <Phone1>01-1234567</Phone1>
      <Phone2>02-1234567</Phone2>
      <Email>mtv@gmail.com</Email>
      <WebSite>http://www.mtv.com</WebSite>
      <IsActive>true</IsActive>
      <CreatedBy>
        <UserId>1</UserId>
      </CreatedBy>
      <CreatedOn>2012-10-15</CreatedOn>
      <ModifiedBy>
        <UserId>1</UserId>
      </ModifiedBy>
      <ModifiedOn>2012-10-15</ModifiedOn>
    </Customer>
    <Module>
      <AccessModule>
        <ModuleName>AddLibrary</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>AddLibraryCategory</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DeleteLibrary</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DeleteLibraryCategory</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DeleteLibraryDetails</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>EditLibrary</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetLibraries</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetLibraryCategories</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SaveGraphicFile</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SaveLibraryDetails</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SearchLibrary</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>UpdateLibraries</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>UpdateLibraryCategories</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetMaster</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>AddMember</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>AddPanel</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>AddPanelCatetory</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>AddPanelibrary</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DeleteMember</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DeletePanel</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetCategory</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetPanleLibrary</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>Index</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SearchPanelList</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>UpdateMember</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>UpdatePanel</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>MySurveys</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>AddUser</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DeleteUser</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetUsers</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SearchUsers</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>UpdateUser</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SearchMemberList</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>AddPlayList</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetSongsInPlayList</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SaveMusicFile</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SearchPlayList</ModuleName>
      </AccessModule>
    </Module>
    <UserRole>
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>2</Hierarchy>
    </UserRole>
  </UserDetails>
  <CreatedBy>
    <UserId>5</UserId>
  </CreatedBy>
  <CreatedOn>2012-10-30</CreatedOn>
  <ModifiedBy>
    <UserId>5</UserId>
  </ModifiedBy>
  <ModifiedOn>2012-10-30 19:28:06.403</ModifiedOn>
</User>'
*/
CREATE PROCEDURE DBO.UspGetLogedInUserData
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @input XML = @XmlUserInfo 

	CREATE TABLE #XmlUserInfo
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO #XmlUserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	SELECT
		DISTINCT
		Parent.Elm.value('(UserId)[1]','VARCHAR(20)') AS UserId,
		-- Parent.Elm.value('(LoginId)[1]','VARCHAR(50)') AS LoginId,
		-- Parent.Elm.value('(UserCode)[1]','VARCHAR(20)') AS UserCode, 
		-- Parent.Elm.value('(UserName)[1]','VARCHAR(50)') AS UserName, 
		-- Parent.Elm.value('(Password)[1]','VARCHAR(500)') AS [Password],
		-- Parent.Elm.value('(EmailId)[1]','VARCHAR(100)') AS EmailId,
		-- Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive,
		-- Child.Elm.value('(Phone1)[1]','VARCHAR(50)') AS Phone1,
		-- Child.Elm.value('(Phone2)[1]','VARCHAR(50)') AS Phone2,
		-- Child.Elm.value('(TimeZone)[1]','VARCHAR(50)') AS TimeZone,
		-- Child.Elm.value('(Language)[1]','VARCHAR(50)') AS Language,
		-- Child.Elm.value('(Department)[1]','VARCHAR(50)') AS Department,
		Child1.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		-- Child1.Elm.value('(CustomerName)[1]','VARCHAR(150)') AS CustomerName,
		-- Child1.Elm.value('(Abbreviation)[1]','VARCHAR(20)') AS Abbreviation,
		-- Child1.Elm.value('(ContactPerson)[1]','VARCHAR(150)') AS ContactPerson,
		-- Child1.Elm.value('(Address1)[1]','VARCHAR(150)') AS Address1,
		-- Child1.Elm.value('(Address2)[1]','VARCHAR(150)') AS Address2,
		-- Child1.Elm.value('(ZipCode)[1]','VARCHAR(50)') AS ZipCode,
		-- Child1.Elm.value('(CityCode)[1]','VARCHAR(50)') AS CityCode,
		-- Child1.Elm.value('(StateCode)[1]','VARCHAR(50)') AS StateCode,
		-- Child1.Elm.value('(CountryCode)[1]','VARCHAR(50)') AS CountryCode,
		-- Child1.Elm.value('(Phone1)[1]','VARCHAR(50)') AS CustomerPhone1,
		-- Child1.Elm.value('(Phone2)[1]','VARCHAR(50)') AS CustomerPhone2,
		-- Child1.Elm.value('(Email)[1]','VARCHAR(50)') AS Email,
		-- Child1.Elm.value('(WebSite)[1]','VARCHAR(150)') AS WebSite,
		-- Child1.Elm.value('(IsActive)[1]','VARCHAR(20)') AS CustomerIsActive,
		-- Child2.Elm.value('(UserId)[1]','VARCHAR(20)') AS CustomerCreatedBy,
		-- Child1.Elm.value('(CreatedOn)[1]','VARCHAR(50)') AS CustomerCreatedOn,
		-- Child3.Elm.value('(UserId)[1]','VARCHAR(20)') AS CustomerModifiedBy,
		-- Child1.Elm.value('(ModifiedOn)[1]','VARCHAR(50)') AS CustomerModifiedOn,
		--Child5.Elm.value('(ModuleName)[1]','VARCHAR(150)') AS ModuleName,
		Child6.Elm.value('(RoleId)[1]','VARCHAR(20)') AS RoleId,
		Child6.Elm.value('(RoleDesc)[1]','VARCHAR(150)') AS RoleDesc,
		Child6.Elm.value('(Hierarchy)[1]','VARCHAR(20)') AS Hierarchy
		-- ,
		-- Child7.Elm.value('(UserId)[1]','VARCHAR(20)') AS CreatedByUserId,
		-- Parent.Elm.value('(CreatedOn)[1]','VARCHAR(50)') AS CreatedOn,
		-- Child8.Elm.value('(UserId)[1]','VARCHAR(50)') AS ModifiedByUserId,
		-- Parent.Elm.value('(ModifiedOn)[1]','VARCHAR(20)') AS ModifiedOn
	--INTO #XmlUserInfo
	FROM @input.nodes('/User') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('UserDetails') AS Child(Elm)
	 CROSS APPLY
	 	Child.Elm.nodes('Customer') AS Child1(Elm)
	-- CROSS APPLY
	-- 	Child1.Elm.nodes('CreatedBy') AS Child2(Elm)
	-- CROSS APPLY
	-- 	Child1.Elm.nodes('ModifiedBy') AS Child3(Elm)
	-- CROSS APPLY
	-- 	Child.Elm.nodes('Module') AS Child4(Elm)
	-- 	CROSS APPLY
	-- 		Child4.Elm.nodes('AccessModule') AS Child5(Elm)
	CROSS APPLY
		Child.Elm.nodes('UserRole') AS Child6(Elm)
	-- CROSS APPLY
	-- 	Parent.Elm.nodes('CreatedBy') AS Child7(Elm)
	-- CROSS APPLY
	-- 	Parent.Elm.nodes('ModifiedBy') AS Child8(Elm)

	UPDATE #XmlUserInfo
	SET RoleDesc = CASE WHEN Hierarchy = '1' THEN 'SA'
						WHEN Hierarchy = '2' THEN 'GU'
						WHEN Hierarchy = '3' THEN 'SU'
						WHEN Hierarchy = '4' THEN 'SLU' END

	SELECT * FROM #XmlUserInfo  
	
	DROP TABLE #XmlUserInfo

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END









