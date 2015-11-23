DECLARE @GetRoles VARCHAR(50)
SET @GetRoles = 'GetRoles'

IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = @GetRoles) 
BEGIN
	DECLARE @AccessId INT
	
	INSERT INTO MS_UserAccess
	(AccessName, AccessModule, AccessLink, IsActive)
	SELECT 'Master', @GetRoles,'',1
	
	SET @AccessId = @@IDENTITY
	
	INSERT INTO MS_RoleAccess
	(RoleId, RoleType, AccessId, AccessModule)
	SELECT 2,'SA',@AccessId, @GetRoles UNION 
	SELECT 1,'GU',@AccessId, @GetRoles  
END

 