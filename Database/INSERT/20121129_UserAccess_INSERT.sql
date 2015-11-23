DECLARE @ReplaceSongFile VARCHAR(50)
SET @ReplaceSongFile = 'ReplaceSongFile'


IF NOT EXISTS(SELECT 1 FROM MS_UserAccess WHERE AccessModule = @ReplaceSongFile)
BEGIN
	DECLARE @AccessId INT

	INSERT INTO DBO.MS_UserAccess	
	(AccessName,AccessModule,AccessLink,IsActive)
	SELECT 'Music',@ReplaceSongFile,'',1

	SET @AccessId = @@IDENTITY
	
	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)	
	SELECT RoleId,RoleType,@AccessId,@ReplaceSongFile FROM MS_Roles WHERE RoleType <> 'SLU'
END

