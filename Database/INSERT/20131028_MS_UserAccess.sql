IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'CopyTestList' AND AccessName = 'Music')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 102,'Music','CopyTestList','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,102,'CopyTestList' FROM MS_Roles WHERE RoleType <> 'SLU'
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END 

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'GetWinnerDetails' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 103,'Survey','GetWinnerDetails','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,103,'GetWinnerDetails' FROM MS_Roles WHERE RoleType IN('GU','SA')
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END 