DECLARE @AccessId INT
SELECT @AccessId = AccessId FROM MS_UserAccess WHERE AccessModule = 'GetMaster'--19

IF NOT EXISTS(SELECT 1 FROM MS_RoleAccess WHERE RoleId = 4 AND AccessId = @AccessId)
BEGIN
	INSERT INTO MS_RoleAccess
	(RoleId, RoleType, AccessId, AccessModule)
	SELECT RoleId, RoleType, @AccessId, 'GetMaster' FROM MS_Roles WHERE RoleId = 4
END


IF NOT EXISTS(SELECT 1 FROM MS_RoleAccess WHERE RoleId = 3 AND AccessId = @AccessId)
BEGIN
	INSERT INTO MS_RoleAccess
	(RoleId, RoleType, AccessId, AccessModule)
	SELECT RoleId, RoleType, @AccessId, 'GetMaster' FROM MS_Roles WHERE RoleId = 3 
END
 
--------------------------------------------------------------------------

DECLARE @AccessId1 INT
SELECT @AccessId1 = AccessId FROM MS_UserAccess WHERE AccessModule = 'GetCompany'--18

IF NOT EXISTS(SELECT 1 FROM MS_RoleAccess WHERE RoleId = 4 AND AccessId = @AccessId1)
BEGIN
	INSERT INTO MS_RoleAccess
	(RoleId, RoleType, AccessId, AccessModule)
	SELECT RoleId, RoleType, @AccessId1, 'GetCompany' FROM MS_Roles WHERE RoleId = 4
END


IF NOT EXISTS(SELECT 1 FROM MS_RoleAccess WHERE RoleId = 3 AND AccessId = @AccessId1)
BEGIN
	INSERT INTO MS_RoleAccess
	(RoleId, RoleType, AccessId, AccessModule)
	SELECT RoleId, RoleType, @AccessId1, 'GetCompany' FROM MS_Roles WHERE RoleId = 3 
END
  