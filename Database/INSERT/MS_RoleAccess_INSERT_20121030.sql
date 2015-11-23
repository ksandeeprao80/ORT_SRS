INSERT INTO DBO.MS_RoleAccess
(RoleId, RoleType, AccessId, AccessModule)
INSERT INTO DBO.MS_RoleAccess
(RoleId, RoleType, AccessId, AccessModule)
SELECT 4,'SU',AccessId,AccessModule FROM MS_UserAccess WHERE AccessModule = 'GetCategory'
UNION
SELECT 3,'SLU',AccessId,AccessModule FROM MS_UserAccess WHERE AccessModule = 'GetCategory'
UNION
SELECT 3,'SLU',AccessId,AccessModule FROM MS_UserAccess WHERE AccessModule = 'GetPanleLibrary'
UNION
SELECT 3,'SLU',AccessId,AccessModule FROM MS_UserAccess WHERE AccessModule = 'SearchPanelList'