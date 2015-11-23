 DECLARE @SaveSongMetaData VARCHAR(50) 
 SET @SaveSongMetaData = 'SaveSongMetaData'
 
 IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = @SaveSongMetaData)
 BEGIN
 	SET IDENTITY_INSERT MS_UserAccess ON
	INSERT INTO MS_UserAccess
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 44,'Music', @SaveSongMetaData,'',1
	SET IDENTITY_INSERT MS_UserAccess OFF
	
	INSERT INTO DBO.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT RoleId, RoleType, 44, @SaveSongMetaData FROM MS_Roles
END
	
	
	