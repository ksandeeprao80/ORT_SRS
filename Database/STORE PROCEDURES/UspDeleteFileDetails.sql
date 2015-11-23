IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteFileDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteFileDetails]
GO
/*
EXEC UspDeleteFileDetails @FileLibId='',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
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
      <AccessModule>
        <ModuleName>SaveSongMetaData</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>GetLibraryTree</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DownloadGraphic</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>CopyGraphic</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>AddSongIntoTestList</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DownloadSongZipfile</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>ReplaceSongFile</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DeleteSongInCloset</ModuleName>
      </AccessModule>
      <AccessModule>
        <ModuleName>DeleteSongInPlayList</ModuleName>
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
</User>'
*/

CREATE PROCEDURE DBO.UspDeleteFileDetails
	@FileLibId INT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	IF EXISTS
	(	
		SELECT 1 FROM DBO.TR_FileLibrary TFL 
		INNER JOIN DBO.TR_PlayList TPL
			ON TFL.FileLibId = TPL.FileLibId 
			AND TFL.FileLibId = @FileLibId
	)
	BEGIN
		SELECT 0 AS RetValue, 'Cannot delete, Song is in Use' AS Remark	
	END
	ELSE
	BEGIN	
		DECLARE @UserInfo TABLE
		(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
		INSERT INTO @UserInfo
		(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
		EXEC DBO.UspGetLogedInUserData @XmlUserInfo

		DECLARE @RowId INT
		SET @RowId = 0
		
		DECLARE @UserId INT, @CustomerId INT
		SELECT @UserId = CONVERT(INT,UserId), @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
		BEGIN
			UPDATE DBO.TR_FileLibrary
			SET IsDeleted = 'Y'
			WHERE FileLibId = @FileLibId
			
			SET @RowId = @@ROWCOUNT
			
			SELECT CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Deletion Failed' ELSE 'Successfully Deleted' END AS Remark
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
		BEGIN
			UPDATE TFL
			SET TFL.IsDeleted = 'Y'
			FROM DBO.TR_FileLibrary TFL
			INNER JOIN DBO.TR_Library TL
				ON TFL.LibId = TL.LibId
				AND TFL.FileLibId = @FileLibId
				AND TL.CustomerId = @CustomerId
			
			SET @RowId = @@ROWCOUNT
			
			SELECT CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Access Denied' ELSE 'Successfully Deleted' END AS Remark	
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
		BEGIN
		
			UPDATE DBO.TR_FileLibrary
			SET IsDeleted = 'Y'
			WHERE FileLibId = @FileLibId
				AND CreatedBy = @UserId
			
			SET @RowId = @@ROWCOUNT
			
			SELECT CASE WHEN ISNULL(@RowId,0)= 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Access Denied' ELSE 'Successfully Deleted' END AS Remark	
		END	
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
		BEGIN
			SELECT 0 AS Retvalue, 'Access Denied' AS Remark
		END 
	END	

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

