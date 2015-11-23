DELETE FROM DBO.MS_RoleAccess WHERE RoleId = 3 AND AccessModule = 'SearchPanelList'
DELETE FROM dbo.MS_RoleAccess WHERE RoleId = 3 AND AccessModule = 'GetPanleLibrary'
DELETE FROM dbo.MS_RoleAccess WHERE RoleId = 3 AND AccessModule = 'GetCategory'

DECLARE @GetCompany VARCHAR(150)
SET @GetCompany = 'GetCompany'
IF NOT EXISTS(SELECT 1 FROM dbo.MS_RoleAccess WHERE RoleId = 1 AND AccessModule = @GetCompany)
BEGIN
	INSERT INTO dbo.MS_RoleAccess
	(RoleId,RoleType,AccessId,AccessModule)
	SELECT 1,'GU',AccessId,'GetCompany' FROM MS_UserAccess WHERE AccessModule = 'GetCompany' 
END

 