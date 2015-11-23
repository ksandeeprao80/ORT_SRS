INSERT INTO DBO.MS_RoleAccess
(RoleId, RoleType, AccessId, AccessModule)
SELECT 1,'GU',10,'DeleteUser' UNION
SELECT 1,'GU',11,'UpdateUser' UNION
SELECT 1,'GU',25,'GetUsers'  