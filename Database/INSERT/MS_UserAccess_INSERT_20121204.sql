IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'DeleteSongInCloset') 
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 51,'Music','DeleteSongInCloset','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,51,'DeleteSongInCloset' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	INSERT INTO DBO.MS_UserAccess	
	(AccessId,AccessName,AccessModule,AccessLink,IsActive)
	SELECT 52,'Music','DeleteSongInPlayList','',1
	
	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,52,'DeleteSongInPlayList' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END
