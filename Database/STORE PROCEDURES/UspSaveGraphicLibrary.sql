IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveGraphicLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveGraphicLibrary
GO

/*
EXEC UspSaveGraphicLibrary '<?xml version="1.0" encoding="utf-16"?>
<GraphicLibrary>
	<LibraryId>6</LibraryId>
	<LibType>Graphic</LibType>
	<LibraryName>Nilesh Johnny Message</LibraryName>
	<Customer>
		<CustomerId>28</CustomerId>
		<IsActive>false</IsActive>
	</Customer>
	<GraphicLibraryId>1</GraphicLibraryId>
	<GraphicLibraryName>Lib Sonali</GraphicLibraryName>
	<Category></Category>
</GraphicLibrary>'
,'<?xml version="1.0" encoding="utf-16"?>
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
			<CustomerId>1</CustomerId>
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
CREATE PROCEDURE DBO.UspSaveGraphicLibrary
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
	
	DECLARE @CreatedBy INT
	SELECT @CreatedBy = CONVERT(INT,UserId) FROM @UserInfo
	
	DECLARE @input XML = @XmlData
	------------------------------------------------------------------------------------

	CREATE TABLE #GraphicLibrary
	(
		LibraryId VARCHAR(20), LibType VARCHAR(30), LibraryName VARCHAR(100), GraphicLibraryId VARCHAR(50), 
		GraphicLibraryName VARCHAR(100), Category VARCHAR(100), CustomerId VARCHAR(20), IsActive VARCHAR(10) 	
	)
	INSERT INTO #GraphicLibrary
	(
		LibraryId, LibType, LibraryName, GraphicLibraryId, GraphicLibraryName, 
		Category, CustomerId, IsActive 		
	)
	SELECT
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibraryId,
		Parent.Elm.value('(LibType)[1]','VARCHAR(30)') AS LibType,
		Parent.Elm.value('(LibraryName)[1]','VARCHAR(100)') AS LibraryName,
		Parent.Elm.value('(GraphicLibraryId)[1]','VARCHAR(50)') AS GraphicLibraryId,
		Parent.Elm.value('(GraphicLibraryName)[1]','VARCHAR(100)') AS GraphicLibraryName,
		Parent.Elm.value('(CreatedOn)[1]','VARCHAR(20)') AS CreatedOn,
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(10)') AS IsActive
	--INTO #GraphicLibrary
	FROM @input.nodes('/GraphicLibrary') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)
	--CROSS APPLY
	--	Parent.Elm.nodes('CreatedBy') AS Child1(Elm)
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_Library TL 
		INNER JOIN 
		(
			SELECT
				 MLT.LibTypeId, GL.GraphicLibraryName, GL.CustomerId
			FROM #GraphicLibrary GL
			INNER JOIN DBO.MS_LibraryType MLT
			ON LTRIM(RTRIM(GL.LibType)) = LTRIM(RTRIM(MLT.TypeName))
		) GL 
			ON LTRIM(RTRIM(TL.LibName)) = LTRIM(RTRIM(GL.GraphicLibraryName))
			AND TL.LibTypeId = GL.LibTypeId
			AND TL.CustomerId = CONVERT(INT,GL.CustomerId)
	)
	BEGIN
		SELECT 0 AS RetValue, 'Library Already Exist In The System' AS Remark
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SA','GU','SU'))
		BEGIN
			IF EXISTS(SELECT 1 FROM #GraphicLibrary WHERE LTRIM(RTRIM(GraphicLibraryId)) = 'undefined')
			BEGIN
				DECLARE @LibraryId INT
				SET @LibraryId = 0
	
				-- New Library insert query
				INSERT INTO DBO.TR_Library
				(
					LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
				)
				SELECT 
					MLT.LibTypeId, LTRIM(RTRIM(GL.GraphicLibraryName)), CONVERT(INT,GL.CustomerId), 1 AS IsActive,
					@CreatedBy, GETDATE(), @CreatedBy, GETDATE() 
				FROM #GraphicLibrary GL
				INNER JOIN DBO.MS_LibraryType MLT
					ON LTRIM(RTRIM(GL.LibType)) = LTRIM(RTRIM(MLT.TypeName))
				WHERE LTRIM(RTRIM(GL.GraphicLibraryId)) = 'undefined'

				SET @LibraryId = @@IDENTITY

				SELECT CASE WHEN ISNULL(@LibraryId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN ISNULL(@LibraryId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
					ISNULL(@LibraryId,0) AS LibraryId
			END
			ELSE
			BEGIN
				UPDATE TL
				SET TL.LibName = LTRIM(RTRIM(GL.LibraryName)),
					TL.ModifiedBy = @CreatedBy,
					TL.ModifiedOn = GETDATE()
				FROM DBO.TR_Library TL
				INNER JOIN #GraphicLibrary GL
					ON TL.LibId = CONVERT(INT,GL.LibraryId)
				INNER JOIN @UserInfo UI
					ON TL.CreatedBy = (CASE WHEN UI.RoleDesc = 'SU' THEN CONVERT(INT,UI.UserId) ELSE TL.CreatedBy END) 
					AND TL.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TL.CustomerId ELSE CONVERT(INT,UI.CustomerId) END) 
				WHERE LTRIM(RTRIM(GL.GraphicLibraryId)) <> 'undefined'
				
				SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, LibraryId FROM #GraphicLibrary
			END
		END
		ELSE
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END
	END
	
	DROP TABLE #GraphicLibrary

	COMMIT TRAN
		
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



