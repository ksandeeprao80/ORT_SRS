IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveFileLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveFileLibrary]
GO
 
/*
EXEC UspSaveFileLibrary '<?xml version="1.0" encoding="utf-16"?>
<SongUpload>
	<SongId></SongId>
	<FileType>1</FileType>
	<FileName>JdTestCan Stay Young (Forever) - 2012.wma</FileName>
	<CustomerId>1</CustomerId>
	<UploadedBy>1</UploadedBy>
	<UploadedDate>2012-11-15</UploadedDate>
	<ParentId>101</ParentId>
	<FolderPath>E:\KKSoni\ORT_SRS\ORT_FrontEnd\ORT_FrontEnd\ORT_APPLICATION\media\/101/84</FolderPath>
	<Extension>.wma</Extension>
	<Category>84</Category>
	<Artist>BressieDD</Artist>
	<Title>Can Stay Young Test(Forever)</Title>
	<Year>2011</Year>
</SongUpload>','<?xml version="1.0" encoding="utf-16"?>
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
      <RoleId>1</RoleId>
      <RoleDesc>Group User</RoleDesc>
      <Hierarchy>1</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'
*/ 
CREATE PROCEDURE DBO.UspSaveFileLibrary
	@XmlData NTEXT,
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
	SELECT @UserId = CONVERT(INT,UserId) FROM @UserInfo
	
	DECLARE @input XML = @XmlData

	CREATE TABLE #FileLibrary
	(
		FileLibId VARCHAR(20), FileType VARCHAR(20), [FileName] VARCHAR(150), CustomerId VARCHAR(20), UploadedBy VARCHAR(100),
		UploadedDate VARCHAR(50), LibId VARCHAR(20), FolderPath VARCHAR(1000), Extension VARCHAR(50),
		Category VARCHAR(20), Artist VARCHAR(100), Title VARCHAR(100), FileLibYear VARCHAR(20)
	)
	INSERT INTO #FileLibrary
	(
		FileLibId, FileType, [FileName], CustomerId, UploadedBy, UploadedDate, LibId, FolderPath, 
		Extension, Category, Artist, Title, FileLibYear
	)
	SELECT
		Parent.Elm.value('(SongId)[1]','VARCHAR(20)') AS FileLibId,
		Parent.Elm.value('(FileType)[1]','VARCHAR(20)') AS FileType,
		Parent.Elm.value('(FileName)[1]','VARCHAR(150)') AS [FileName],
		Parent.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Parent.Elm.value('(UploadedBy)[1]','VARCHAR(100)') AS UploadedBy,
		Parent.Elm.value('(UploadedDate)[1]','VARCHAR(50)') AS UploadedDate,
		Parent.Elm.value('(ParentId)[1]','VARCHAR(20)') AS LibId,
		Parent.Elm.value('(FolderPath)[1]','VARCHAR(1000)') AS FolderPath,
		Parent.Elm.value('(Extension)[1]','VARCHAR(50)') AS Extension,
		Parent.Elm.value('(Category)[1]','VARCHAR(20)') AS Category,
		Parent.Elm.value('(Artist)[1]','VARCHAR(100)') AS Artist,
		Parent.Elm.value('(Title)[1]','VARCHAR(100)') AS Title,
		Parent.Elm.value('(Year)[1]','VARCHAR(20)') AS FileLibYear
	--INTO #FileLibrary
	FROM @input.nodes('/SongUpload') AS Parent(Elm)

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END
	ELSE
	BEGIN
		DECLARE @FileLibId INT
		DECLARE @SoundFileCount INT 
		DECLARE @CustomerId INT

		SELECT DISTINCT TL.CustomerId		
		INTO #ExistCustomers
		FROM #FileLibrary FL 
		INNER JOIN DBO.TR_SoundClipInfo TSCI WITH(NOLOCK) 
			ON LTRIM(RTRIM(FL.Title)) = LTRIM(RTRIM(TSCI.Title))
			AND LTRIM(RTRIM(FL.Artist)) = LTRIM(RTRIM(TSCI.Artist)) 
			AND LTRIM(RTRIM(FL.FileLibYear)) = LTRIM(RTRIM(TSCI.FileLibYear))
		INNER JOIN DBO.TR_FileLibrary TFL WITH(NOLOCK)
			ON TFL.FileLibId = TSCI.FileLibId
		INNER JOIN DBO.TR_Library TL WITH(NOLOCK) 
			ON TFL.LibId = TL.LibId	
	  
		SELECT @CustomerId = TL.CustomerId FROM #FileLibrary FL 
		INNER JOIN DBO.TR_Library TL WITH(NOLOCK) ON LTRIM(RTRIM(FL.LibId)) = CONVERT(VARCHAR(12),TL.LibId)	
		
		SELECT @SoundFileCount = COUNT(1) FROM #ExistCustomers WHERE CustomerId = @CustomerId 

		IF ISNULL(@SoundFileCount,0) >= 1
		BEGIN
			SELECT 0 AS RetValue, 'File already exist in the system' AS Remark
		END
		ELSE	
		BEGIN
			IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
			BEGIN
				IF EXISTS(SELECT 1 FROM #FileLibrary WHERE ISNULL(FileLibId,'') = '')
				BEGIN
					INSERT INTO DBO.TR_FileLibrary
					(LIBID, FileLibName, Category, [FileName], FileType, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
					SELECT 
						CONVERT(INT,FL.LibId), TL.LibName AS FileLibName, CONVERT(INT,FL.Category), 
						FL.[FileName], REPLACE(FL.Extension,'.','') AS FileType, @UserId, GETDATE(), @UserId, GETDATE()
					FROM #FileLibrary FL
					INNER JOIN DBO.TR_Library TL
						ON CONVERT(INT,FL.LibId) = TL.LibId
					WHERE ISNULL(FL.FileLibId,'') = '' 
				
					SET @FileLibId = @@IDENTITY

					INSERT INTO DBO.TR_SoundClipInfo
					(FileLibId, Title, Artist, FileLibYear, FilePath)
					SELECT 
						@FileLibId, Title, Artist, FileLibYear, FolderPath
					FROM #FileLibrary
					WHERE ISNULL(FileLibId,'') = '' 

					SELECT 
						CASE WHEN ISNULL(@FileLibId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
						CASE WHEN ISNULL(@FileLibId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
						@FileLibId AS FileLibId
				END
				ELSE
				BEGIN
					UPDATE TFL
					SET TFL.[FileName] = CASE WHEN ISNULL(FL.[FileName],'') = '' THEN TFL.[FileName] ELSE FL.[FileName] END,
						TFL.ModifiedBy = @UserId,
						TFL.ModifiedOn = GETDATE()
					FROM DBO.TR_FileLibrary TFL
					INNER JOIN #FileLibrary FL
						ON CONVERT(VARCHAR(12),TFL.FileLibId) = LTRIM(RTRIM(FL.FileLibId))
					WHERE ISNULL(FL.FileLibId,'') <> '' 
					
					UPDATE TSCI
					SET TSCI.Title = CASE WHEN ISNULL(FL.Title,'') = '' THEN TSCI.Title ELSE FL.Title END,
						TSCI.Artist = CASE WHEN ISNULL(FL.Artist,'') = '' THEN TSCI.Artist ELSE FL.Artist END,
						TSCI.FileLibYear = CASE WHEN ISNULL(FL.FileLibYear,'') = '' THEN TSCI.FileLibYear ELSE FL.FileLibYear END,
						TSCI.FilePath = CASE WHEN ISNULL(FL.FolderPath,'') = '' THEN TSCI.FilePath ELSE FL.FolderPath END
					FROM DBO.TR_SoundClipInfo TSCI
					INNER JOIN #FileLibrary FL
						ON CONVERT(VARCHAR(12),TSCI.FileLibId) = LTRIM(RTRIM(FL.FileLibId))
					WHERE ISNULL(FL.FileLibId,'') <> ''  
					
					SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, FileLibId FROM #FileLibrary
				END
			END
			
			IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','GU'))
			BEGIN
				IF EXISTS
				(
					SELECT 1 FROM DBO.TR_Library TL INNER JOIN #FileLibrary FL
					ON TL.LibId = CONVERT(INT,FL.LibId) AND TL.CreatedBy = @UserId
				)
				BEGIN
					IF EXISTS(SELECT 1 FROM #FileLibrary WHERE ISNULL(FileLibId,'') = '')
					BEGIN
						 
						INSERT INTO DBO.TR_FileLibrary
						(LIBID, FileLibName, Category, [FileName], FileType, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						SELECT 
							CONVERT(INT,FL.LibId), LTRIM(RTRIM(TL.LibName)) AS FileLibName, CONVERT(INT,FL.Category), 
							FL.[FileName], REPLACE(FL.Extension,'.','') AS FileType, @UserId, GETDATE(), @UserId, GETDATE()
						FROM #FileLibrary FL
						INNER JOIN DBO.TR_Library TL
							ON CONVERT(INT,FL.LibId) = TL.LibId
						WHERE ISNULL(FL.FileLibId,'') = ''
					
						SET @FileLibId = @@IDENTITY

						INSERT INTO DBO.TR_SoundClipInfo
						(FileLibId, Title, Artist, FileLibYear, FilePath)
						SELECT 
							@FileLibId, LTRIM(RTRIM(Title)), LTRIM(RTRIM(Artist)), LTRIM(RTRIM(FileLibYear)), ''
						FROM #FileLibrary 
						WHERE ISNULL(FileLibId,'') = ''

						SELECT 
							CASE WHEN ISNULL(@FileLibId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
							CASE WHEN ISNULL(@FileLibId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
							@FileLibId AS FileLibId
					END
					ELSE
					BEGIN
						UPDATE TFL
						SET TFL.[FileName] = CASE WHEN ISNULL(FL.[FileName],'') = '' THEN TFL.[FileName] ELSE FL.[FileName] END,
							TFL.ModifiedBy = @UserId,
							TFL.ModifiedOn = GETDATE()
						FROM DBO.TR_FileLibrary TFL
						INNER JOIN #FileLibrary FL
							ON CONVERT(VARCHAR(12),TFL.FileLibId) = LTRIM(RTRIM(FL.FileLibId))
						WHERE ISNULL(FL.FileLibId,'') <> '' 
						
						UPDATE TSCI
						SET TSCI.Title = CASE WHEN ISNULL(FL.Title,'') = '' THEN TSCI.Title ELSE FL.Title END,
							TSCI.Artist = CASE WHEN ISNULL(FL.Artist,'') = '' THEN TSCI.Artist ELSE FL.Artist END,
							TSCI.FileLibYear = CASE WHEN ISNULL(FL.FileLibYear,'') = '' THEN TSCI.FileLibYear ELSE FL.FileLibYear END,
							TSCI.FilePath = CASE WHEN ISNULL(FL.FolderPath,'') = '' THEN TSCI.FilePath ELSE FL.FolderPath END
						FROM DBO.TR_SoundClipInfo TSCI
						INNER JOIN #FileLibrary FL
							ON CONVERT(VARCHAR(12),TSCI.FileLibId) = LTRIM(RTRIM(FL.FileLibId))
						WHERE ISNULL(FL.FileLibId,'') <> ''  
						
						SELECT 1 AS RetValue, 'Successfully Updated' AS Remark, FileLibId FROM #FileLibrary
					END
				END	
				ELSE
				BEGIN
					SELECT 0 AS RetValue, 'Acess Denied' AS Remark
				END
			END
		END
	END

	DROP TABLE #FileLibrary
		
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END