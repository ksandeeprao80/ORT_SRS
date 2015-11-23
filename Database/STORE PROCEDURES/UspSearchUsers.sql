IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchUsers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchUsers]

GO
/*
--EXEC UspSearchUsers NULL,NULL,NULL,NULL,'RADIO','<?xml version="1.0" encoding="utf-16"?>
<User>
	<UserId>5</UserId>
	<LoginId>nilesh</LoginId>
	<UserCode>SRS5</UserCode>
	<UserName>Nilesh More</UserName>
	<Password>ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad</Password>
	<EmailId>sdh@sdh.com</EmailId>
	<UserDetails>
		<IsActive>true</IsActive>
		<Phone1>+1 (206) 347-2188</Phone1>
		<Phone2>+1 (206) 347-2388</Phone2>
		<TimeZone>4</TimeZone>
		<Language>5</Language>
		<Department>HR</Department>
		<Customer>
			<CustomerId>2</CustomerId>
			<CustomerName>RED FM</CustomerName>
			<Abbreviation>FM 1</Abbreviation>
			<ContactPerson>Anthony Gonsalves</ContactPerson>
			<Address1>Test1111</Address1>
			<Address2>Test2222</Address2>
			<ZipCode>400083</ZipCode>
			<CityCode>1</CityCode>
			<StateCode>4</StateCode>
			<CountryCode>2</CountryCode>
			<Phone1>022-42119999</Phone1>
			<Phone2>022-42119926</Phone2>
			<Email>info.88_9@gmail.com</Email>
			<WebSite>www.88_9.com</WebSite>
			<IsActive>true</IsActive>
			<CreatedBy>
				<UserId>5</UserId>
			</CreatedBy>
			<CreatedOn>2012-07-09</CreatedOn>
			<ModifiedBy>
				<UserId>0</UserId>
			</ModifiedBy>
			<ModifiedOn>2012-07-09</ModifiedOn>
		</Customer>

		<Module>
			<AccessModule>
				<ModuleName>AddCustomer</ModuleName>
			</AccessModule>
			<AccessModule>
				<ModuleName>DeleteCustomer</ModuleName>
			</AccessModule>
			<AccessModule>
				<ModuleName>SearchCustomer</ModuleName>
			</AccessModule>
			<AccessModule>
				<ModuleName>UpdateCustomer</ModuleName>
			</AccessModule>
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
				<ModuleName>GetCompany</ModuleName>
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
			<RoleId>2</RoleId>
			<RoleDesc>SRS Admin</RoleDesc>
			<Hierarchy>1</Hierarchy>
		</UserRole>
	</UserDetails>
	<CreatedBy>
		<UserId>1</UserId>
	</CreatedBy>
	<CreatedOn>2012-07-09</CreatedOn>
	<ModifiedBy>
		<UserId>5</UserId>
	</ModifiedBy>
	<ModifiedOn>2012-09-24</ModifiedOn>
</User>'

*/
CREATE PROCEDURE DBO.UspSearchUsers
	@UserCode VARCHAR(20),
	@UserName VARCHAR(50),
	@LoginId VARCHAR(30),
	@EmailId VARCHAR(50), 
	@CustomerName VARCHAR(150),
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SA','GU'))
	BEGIN
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
		BEGIN
			SELECT 
				MU.UserId, ISNULL(MU.UserName,'') AS UserName, ISNULL(MU.UserPassword,'') AS UserPassword, 
				ISNULL(MU.CustomerId,0) AS CustomerId, ISNULL(MU.EmailId,'') AS EmailId,
				ISNULL(MU.IsActive,0) AS IsActive, ISNULL(MR.RoleId,0) AS RoleId,
				ISNULL(MR.RoleDescription,'') AS UserType, ISNULL(ML.LanguageId,0) AS LanguageId,
				ISNULL(MU.LangauageName,'') AS LangauageName, ISNULL(MTZ.TimeZoneId,0) AS TimeZoneId,
				ISNULL(MTZ.TimeZone,'') AS TimeZone, ISNULL(MU.Phone1,'') AS Phone1, 
				ISNULL(MU.Phone2,'') AS Phone2, ISNULL(MU.Phone3,'') AS Phone3,
				ISNULL(MU.UserCode,'') AS UserCode, MU.LoginId, ISNULL(MU.Department,'') AS Department,
				MU.CreatedBy, CONVERT(VARCHAR(25),MU.CreatedOn,121) AS CreatedOn,
				ISNULL(MU.ModifiedBy,0) AS ModifiedBy, ISNULL(CONVERT(VARCHAR(25),MU.ModifiedOn,121),'') AS ModifiedOn,
				ISNULL(MR.Hierarchy,0) AS Hierarchy, MR.OpenAccess
			FROM DBO.MS_Users MU
			LEFT OUTER JOIN DBO.MS_Customers MC
				ON MU.CustomerId = MC.CustomerId
			LEFT OUTER JOIN DBO.MS_Roles MR
				ON MU.UserType = MR.RoleType
			LEFT OUTER JOIN DBO.MS_Languages ML
				ON LTRIM(RTRIM(MU.LangauageName)) = LTRIM(RTRIM(ML.LangauageName)) 
			LEFT OUTER JOIN DBO.MS_TimeZone MTZ
				ON MU.TimeZone = MTZ.TimeZoneId
			WHERE MU.UserCode LIKE '%'+ISNULL(@UserCode,MU.UserCode)+'%' 
				AND MU.LoginId LIKE '%'+ISNULL(@LoginId,MU.LoginId)+'%'
				AND MU.EmailId LIKE '%'+ISNULL(@EmailId,MU.EmailId)+'%'
				AND MC.CustomerName LIKE '%'+ISNULL(@CustomerName,MC.CustomerName)+'%'
				AND MU.UserName LIKE '%'+ISNULL(@UserName,MU.UserName)+'%'
				AND MU.IsActive = 1 AND MC.IsActive = 1
			ORDER BY MU.UserName
		END

		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
		BEGIN		
			SELECT 
				MU.UserId, ISNULL(MU.UserName,'') AS UserName, ISNULL(MU.UserPassword,'') AS UserPassword, 
				ISNULL(MU.CustomerId,0) AS CustomerId, ISNULL(MU.EmailId,'') AS EmailId,
				ISNULL(MU.IsActive,0) AS IsActive, ISNULL(MR.RoleId,0) AS RoleId,
				ISNULL(MR.RoleDescription,'') AS UserType, ISNULL(ML.LanguageId,0) AS LanguageId,
				ISNULL(MU.LangauageName,'') AS LangauageName, ISNULL(MTZ.TimeZoneId,0) AS TimeZoneId,
				ISNULL(MTZ.TimeZone,'') AS TimeZone, ISNULL(MU.Phone1,'') AS Phone1, 
				ISNULL(MU.Phone2,'') AS Phone2, ISNULL(MU.Phone3,'') AS Phone3,
				ISNULL(MU.UserCode,'') AS UserCode, MU.LoginId, ISNULL(MU.Department,'') AS Department,
				MU.CreatedBy, CONVERT(VARCHAR(25),MU.CreatedOn,121) AS CreatedOn,
				ISNULL(MU.ModifiedBy,0) AS ModifiedBy, ISNULL(CONVERT(VARCHAR(25),MU.ModifiedOn,121),'') AS ModifiedOn,
				ISNULL(MR.Hierarchy,0) AS Hierarchy, MR.OpenAccess
			FROM DBO.MS_Users MU
			INNER JOIN @UserInfo UI
				ON MU.CustomerId = CONVERT(INT,UI.CustomerId)
			LEFT OUTER JOIN DBO.MS_Customers MC
				ON MU.CustomerId = MC.CustomerId
			LEFT OUTER JOIN DBO.MS_Roles MR
				ON MU.UserType = MR.RoleType
			LEFT OUTER JOIN DBO.MS_Languages ML
				ON LTRIM(RTRIM(MU.LangauageName)) = LTRIM(RTRIM(ML.LangauageName)) 
			LEFT OUTER JOIN DBO.MS_TimeZone MTZ
				ON MU.TimeZone = MTZ.TimeZoneId
			WHERE MU.UserCode LIKE '%'+ISNULL(@UserCode,MU.UserCode)+'%' 
				AND MU.LoginId LIKE '%'+ISNULL(@LoginId,MU.LoginId)+'%'
				AND MU.EmailId LIKE '%'+ISNULL(@EmailId,MU.EmailId)+'%'
				AND MC.CustomerName LIKE '%'+ISNULL(@CustomerName,MC.CustomerName)+'%'
				AND MU.UserName LIKE '%'+ISNULL(@UserName,MU.UserName)+'%'
				AND MU.IsActive = 1 AND MC.IsActive = 1
				AND MU.UserType IN ('GU','SU','SLU')
			ORDER BY MU.UserName	
		END
	END	
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


