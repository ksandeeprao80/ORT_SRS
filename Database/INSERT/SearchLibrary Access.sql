BEGIN
	DECLARE @AccessId INT
	SET @AccessId =0
	INSERT INTO MS_UserAccess
	(AccessName,AccessModule,AccessLink,IsActive)
	SELECT 'Library','SearchLibrary','www.google.co.in',1
	
	SET @AccessId = @@IDENTITY
	
	INSERT INTO MS_RoleAccess
	(RoleId, RoleType, AccessId, AccessModule)
	SELECT 2,'SA',@AccessId,'SearchLibrary'
END
