IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchPanelMembers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchPanelMembers]

GO
/*
--EXEC UspSearchPanelMembers 4,1,NULL,'<?xml version="1.0" encoding="utf-16"?>
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

CREATE PROCEDURE DBO.UspSearchPanelMembers
	@LibId INT,
	@CategoryId INT,
	@PanelistName VARCHAR(150),
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	IF @PanelistName = ''
		SET @PanelistName = NULL
		
	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','SA','GU'))
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM DBO.TR_PanelCategory TPC
			WHERE TPC.LibId = @LibId
				AND TPC.CategoryId = @CategoryId
		)
		BEGIN
			SELECT 
				MPM.PanelistId, 
				LTRIM(RTRIM(MPM.PanelistName)) AS PanelistName, MPM.CustomerId, ISNULL(TPC.CategoryId,0) AS CategoryId, 
				ISNULL(TPC.CategoryName,'') AS CategoryName, MPM.LastUsed, MPM.IsActive,
				ISNULL(MR.Members,0) AS Members, MPM.LibId, 1 AS RetValue
			FROM DBO.MS_PanelMembers MPM
			INNER JOIN @UserInfo UI
				ON MPM.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN MPM.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
			LEFT OUTER JOIN 
			(
				SELECT COUNT(1) AS Members, MR.PanelistId
				FROM DBO.MS_Respondent MR
				WHERE MR.IsDeleted = 1
				GROUP BY MR.PanelistId
			) MR
				ON MPM.PanelistId = MR.PanelistId
			LEFT OUTER JOIN DBO.TR_PanelCategory TPC
				ON MPM.LibId = TPC.LibId
				AND MPM.CategoryId = TPC.CategoryId
			WHERE MPM.LibId = @LibId
				AND TPC.CategoryId = @CategoryId
				AND MPM.PanelistName LIKE '%'+ISNULL(@PanelistName,MPM.PanelistName)+'%'
				AND MPM.IsActive = 1
		END
		ELSE
		BEGIN
			SELECT 0 AS RetValue, 'Please select correct category' AS Remark
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


