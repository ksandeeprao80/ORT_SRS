IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = 'CheckSurveyName' AND AccessName = 'Survey')
BEGIN
	SET IDENTITY_INSERT DBO.MS_UserAccess ON 
	INSERT INTO DBO.MS_UserAccess	
	(AccessId, AccessName,AccessModule,AccessLink,IsActive)
	SELECT 104,'Survey','CheckSurveyName','',1

	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,104,'CheckSurveyName' FROM MS_Roles WHERE RoleType <> 'SLU'
	
	SET IDENTITY_INSERT DBO.MS_UserAccess OFF
END 

 
