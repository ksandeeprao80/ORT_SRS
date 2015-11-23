UPDATE DBO.MS_RoleAccess SET RoleId = 4 WHERE RoleType = 'SU'
GO
INSERT INTO DBO.MS_RoleAccess
(RoleId, RoleType, AccessId, AccessModule)
SELECT 4,'SU',10,'DeleteUser' UNION
SELECT 4,'SU',11,'UpdateUser' UNION
SELECT 4,'SU',25,'GetUsers'  
