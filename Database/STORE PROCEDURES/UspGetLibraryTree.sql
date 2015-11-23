IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetLibraryTree]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetLibraryTree]

GO
/*
UspGetLibraryTree '<?xml version="1.0" encoding="utf-16"?>
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
    <TimeZone>39</TimeZone>
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
        <ModuleName>SaveSongFile</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>SearchPlayList</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetRoles</ModuleName>
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
  <ModifiedOn>2012-09-24 14:22:20.877</ModifiedOn>
</User>','2012'
*/
CREATE PROCEDURE [dbo].[UspGetLibraryTree]
	@XmlUserInfo AS NTEXT,	
	@Filter AS VARCHAR(200)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId INT, CustomerId INT, RoleId INT, RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	DECLARE @xmlResult XML
	
	IF ISNULL(@Filter,'0') = '0'  
	BEGIN
		SET @XmlResult =
		(
			SELECT 
			(
				SELECT
					(
					SELECT 
						(
							SELECT TL.LibId, TL.LibName 
							FOR XML PATH(''), TYPE 
						),
						(
						SELECT
							(
							SELECT
							(
							SELECT 
								TLC.CategoryId, TL.LibId AS ParentId, TLC.CategoryName, ISNULL(TFL.NoOfFiles,0) AS NoOfFiles,
								TLC.CreatedBy, TLC.CreatedOn, TLC.ModifiedBy, TLC.ModifiedOn,
								(
									SELECT
									(
										SELECT 
											FL.FileLibId AS Id, FL.Category AS parentId, FL.[FileName] AS name,
											SI.Title AS title, SI.artist, SI.Title AS album, FL.[fileName],
											SI.FileLibYear AS [year], FL.FileType AS fileType, TL.libId 
										FROM dbo.TR_FileLibrary FL 
										INNER JOIN DBO.TR_SoundClipInfo SI 
											ON FL.FileLibId = SI.FileLibId 
										WHERE FL.Category = TLC.CategoryId
											AND FL.IsDeleted = 'N'  
										FOR XML PATH('Song'), TYPE
									)
									FOR XML PATH('Songs'), TYPE
								)
								FROM TR_LibraryCategory TLC
								LEFT OUTER JOIN 
								(
									SELECT 
										TFL.Category AS CategoryId, TFL.LibId, ISNULL(COUNT(1),0) AS NoOfFiles
									FROM dbo.TR_FileLibrary TFL 
									INNER JOIN DBO.TR_SoundClipInfo SI 
										ON TFL.FileLibId = SI.FileLibId 
									WHERE TFL.IsDeleted = 'N' 
									GROUP BY TFL.LibId, TFL.Category 
								) TFL
									ON TLC.LibId = TFL.LibId
									AND TLC.CategoryId = TFL.CategoryId 
								WHERE TLC.LibId = TL.LibId
								FOR XML PATH('Category'), TYPE 	
							)
						)
						FOR XML PATH('Categories'), TYPE
					)
					FOR XML PATH('MusicLibrary'), TYPE 
				)
			)
			FROM DBO.TR_Library TL 
			INNER JOIN DBO.MS_LibraryType MLT
				ON TL.LibTypeId = MLT.LibTypeId
				AND MLT.TypeName = 'File'
				AND TL.IsActive = 1
			INNER JOIN @UserInfo UI
				ON TL.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TL.CustomerId ELSE UI.CustomerId END) 
				AND TL.CreatedBy = (CASE WHEN UI.RoleDesc IN ('SA','GU') THEN TL.CreatedBy ELSE UI.UserId END)
			FOR XML PATH(''),
			ROOT('MusicLibraries')  
		)
	END
	ELSE 
	BEGIN
		SET @XmlResult =
		(
			SELECT 
			(
				SELECT
				(
					SELECT 
					(
						SELECT TL.LibId, TL.LibName 
						FOR XML PATH(''), TYPE 
					),
					(
					SELECT
						(
						SELECT
							(
								SELECT 
									TLC.CategoryId, TL.LibId AS ParentId, TLC.CategoryName, ISNULL(TFL.NoOfFiles,0) AS NoOfFiles,
									TLC.CreatedBy, TLC.CreatedOn, TLC.ModifiedBy, TLC.ModifiedOn,
								(
								SELECT
								(
									SELECT 
										FL.FileLibId AS Id, FL.Category AS parentId, FL.[FileName] AS name,
										SI.Title AS title, SI.artist, SI.Title AS album, FL.[fileName],
										SI.FileLibYear AS [year], FL.fileType, TL.libId  
									FROM dbo.TR_FileLibrary FL 
									INNER JOIN DBO.TR_SoundClipInfo SI 
										ON FL.FileLibId = SI.FileLibId 
									WHERE FL.Category = TLC.CategoryId 
										AND FL.IsDeleted = 'N' 
										AND 
										(
											(FL.[FileName] LIKE '%'+@Filter+'%') 
											OR (SI.Artist LIKE '%'+@Filter +'%')
											OR (SI.FileLibYear LIKE '%'+@Filter+'%')
											OR (SI.Title LIKE '%'+@Filter+'%')
										)
									FOR XML PATH('Song'), TYPE
								)
								FOR XML PATH('Songs'), TYPE
								)
								FROM DBO.TR_LibraryCategory TLC
								LEFT OUTER JOIN 
								(
									SELECT 
										Category AS CategoryId, LibId, ISNULL(COUNT(1),0) AS NoOfFiles
									FROM DBO.TR_FileLibrary TFL 
									INNER JOIN DBO.TR_SoundClipInfo SI 
										ON TFL.FileLibId = SI.FileLibId 
									WHERE TFL.IsDeleted = 'N' 
										AND 
										(
											(TFL.[FileName] LIKE '%'+@Filter+'%') 
											OR (SI.Artist LIKE '%'+@Filter+'%')
											OR (SI.FileLibYear LIKE '%'+@Filter+'%')
											OR (SI.Title LIKE '%'+@Filter+'%')
										)
									GROUP BY LibId, Category 
								) TFL
									ON TLC.LibId = TFL.LibId
									AND TLC.CategoryId = TFL.CategoryId 
								WHERE TLC.LibId = TL.LibId
								FOR XML PATH('Category'), TYPE 	
							)
						)FOR XML PATH('Categories'), TYPE
				)FOR XML PATH('MusicLibrary'), TYPE 
			)
		)
		FROM DBO.TR_Library TL 
		INNER JOIN DBO.MS_LibraryType MLT
			ON TL.LibTypeId = MLT.LibTypeId
			AND MLT.TypeName = 'File'
			AND TL.IsActive = 1
		INNER JOIN @UserInfo UI
			ON TL.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TL.CustomerId ELSE UI.CustomerId END) 
			AND TL.CreatedBy = (CASE WHEN UI.RoleDesc IN ('SA','GU') THEN TL.CreatedBy ELSE UI.UserId END)
		FOR XML PATH(''),
		ROOT('MusicLibraries')  
	)
	END
	
	SELECT @XmlResult AS XmlResult
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
