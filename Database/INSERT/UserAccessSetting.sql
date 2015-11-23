IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'PreViewMessage' AND AccessName = 'Library')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 100,'Library','PreViewMessage','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,100,'PreViewMessage' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 101,'Library','ShowPreViewMessage','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,101,'ShowPreViewMessage' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END 

