INSERT INTO MS_RoleAccess
(RoleId, RoleType,AccessId, AccessModule)
SELECT 4,'SU',AccessId, AccessModule FROM MS_UserAccess WHERE AccessName ='Panel' AND AccessId NOT IN(26,27,29)

INSERT INTO MS_MenuRoleAccess
(RoleId,ModuleId,AccessStatus)
SELECT 4,ModuleId,AccessStatus FROM MS_MenuRoleAccess WHERE ModuleId IN(52,53,54,55,56,57,58) AND RoleId = 1