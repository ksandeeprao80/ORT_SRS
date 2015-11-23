--SCRIPT 2

--BACKUP
--SELECT * INTO MS_UserAccess_20102012 FROM MS_UserAccess
--SELECT * INTO MS_RoleAccess_20102012 FROM MS_RoleAccess
--SELECT * FROM MS_UserAccess_20102012
--SELECT * FROM MS_RoleAccess_20102012
GO

TRUNCATE TABLE MS_USERACCESS
GO

INSERT INTO MS_USERACCESS(AccessName,AccessModule,AccessLink,IsActive)
SELECT AccessName,AccessModule,AccessLink,IsActive
FROM MS_USERACCESS_SANDEEP

GO

TRUNCATE TABLE MS_RoleAccess
GO

INSERT INTO MS_RoleAccess(RoleId,RoleType,AccessId,AccessModule)
SELECT RoleId,RoleType,AccessId,AccessModule
FROM MS_RoleAccess_Sandeep
GO

--VERIFY
--SELECT * FROM MS_USERACCESS
--SELECT * FROM MS_RoleAccess