UPDATE DBO.MS_Roles SET Hierarchy = 1 WHERE RoleType = 'SA'
UPDATE DBO.MS_Roles SET Hierarchy = 2 WHERE RoleType = 'GU'
UPDATE DBO.MS_Roles SET Hierarchy = 3 WHERE RoleType = 'SU'
UPDATE DBO.MS_Roles SET Hierarchy = 4 WHERE RoleType = 'SLU'