DECLARE @DownloadGraphic VARCHAR(30)
SET @DownloadGraphic = 'DownloadGraphic'

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = @DownloadGraphic)
BEGIN
	DECLARE @AccessId INT
	SET @AccessId = 0

	INSERT INTO MS_UserAccess  
	(AccessName,AccessModule,AccessLink,IsActive)
	SELECT 'Library',@DownloadGraphic,'',1

	SET @AccessId = @@IDENTITY
	
	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT RoleId,RoleType,@AccessId,@DownloadGraphic FROM MS_Roles WHERE RoleType <> 'SLU'
END


DECLARE @CopyGraphic VARCHAR(30)
SET @CopyGraphic = 'CopyGraphic'

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = @CopyGraphic)
BEGIN
	DECLARE @AccessId1 INT
	SET @AccessId1 = 0

	INSERT INTO MS_UserAccess  
	(AccessName,AccessModule,AccessLink,IsActive)
	SELECT 'Library',@CopyGraphic,'',1

	SET @AccessId1 = @@IDENTITY
	
	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT RoleId,RoleType,@AccessId1,@CopyGraphic FROM MS_Roles WHERE RoleType <> 'SLU'
END


DECLARE @AddSongIntoTestList VARCHAR(30)
SET @AddSongIntoTestList = 'AddSongIntoTestList'

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = @AddSongIntoTestList)
BEGIN
	DECLARE @AccessId4 INT
	SET @AccessId4 = 0

	INSERT INTO MS_UserAccess  
	(AccessName,AccessModule,AccessLink,IsActive)
	SELECT 'Library',@AddSongIntoTestList,'',1

	SET @AccessId4 = @@IDENTITY
	
	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT RoleId,RoleType,@AccessId4,@AddSongIntoTestList FROM MS_Roles WHERE RoleType <> 'SLU'
END



DECLARE @DownloadSongZipfile VARCHAR(30)
SET @DownloadSongZipfile = 'DownloadSongZipfile'

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = @DownloadSongZipfile)
BEGIN
	DECLARE @AccessId5 INT
	SET @AccessId5 = 0

	INSERT INTO MS_UserAccess  
	(AccessName,AccessModule,AccessLink,IsActive)
	SELECT 'Library',@DownloadSongZipfile,'',1

	SET @AccessId5 = @@IDENTITY
	
	INSERT INTO MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT RoleId,RoleType,@AccessId5,@DownloadSongZipfile FROM MS_Roles WHERE RoleType <> 'SLU'
END

