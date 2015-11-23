IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'ExportPanel' AND AccessName = 'Panel')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 105,'Panel','ExportPanel','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,105,'ExportPanel' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END 

 