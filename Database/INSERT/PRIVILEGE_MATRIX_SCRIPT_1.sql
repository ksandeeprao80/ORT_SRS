-- CLEAN TABLE FOR USER ACCESS MODULES
-- CLEAR TABLE FOR ROLE ACCESS

TRUNCATE TABLE MS_RoleAccess
GO

TRUNCATE TABLE DBO.MS_UserAccess
GO

--DO INDIVIDUAL INSERTS FOR USER ACCESS MODULES

INSERT INTO DBO.MS_UserAccess
(AccessName,AccessModule,AccessLink,IsActive)
SELECT 'Master','GetMaster',' ',1 UNION
SELECT 'Master','GetCompany',' ',1 UNION
SELECT 'Panel','GetPanleLibrary',' ',1 UNION
SELECT 'Panel','AddPanelibrary',' ',1 UNION
SELECT 'Panel','GetCategory',' ',1 UNION
SELECT 'Panel','AddPanelCatetory',' ',1 UNION
SELECT 'Library','GetLibraries',' ',1 UNION
SELECT 'Library','AddLibrary',' ',1 UNION
SELECT 'Library','UpdateLibraries',' ',1 UNION
SELECT 'Library','DeleteLibrary',' ',1 UNION
SELECT 'Library','GetLibraryCategories',' ',1 UNION
SELECT 'Library','AddLibraryCategory',' ',1 UNION
SELECT 'Library','UpdateLibraryCategories',' ',1 UNION
SELECT 'Library','DeleteLibraryCategory',' ',1 UNION
SELECT 'Survey','MySurveys',' ',1 UNION
SELECT 'Panel','SearchPanelList',' ',1 UNION
SELECT 'Panel','SearchPanelList',' ',1 UNION
SELECT 'Panel','AddPanel',' ',1 UNION
SELECT 'Panel','UpdatePanel',' ',1 UNION
SELECT 'Panel','DeletePanel',' ',1 UNION
SELECT 'Panel','AddMember',' ',1 UNION
SELECT 'Panel','UpdateMember',' ',1 UNION
SELECT 'Panel','DeleteMember',' ',1 UNION
SELECT 'Panel','Index',' ',1 UNION
SELECT 'User','SearchUsers',' ',1 UNION
SELECT 'User','GetUsers',' ',1 UNION
SELECT 'User','AddUser',' ',1 UNION
SELECT 'User','UpdateUser',' ',1 UNION
SELECT 'User','DeleteUser',' ',1 UNION
SELECT 'Customer','SearchCustomer',' ',1 UNION
SELECT 'Customer','AddCustomer',' ',1 UNION
SELECT 'Customer','UpdateCustomer',' ',1 UNION
SELECT 'Customer','DeleteCustomer',' ',1 UNION
SELECT 'Library','SearchLibrary',' ',1 UNION
SELECT 'Library','SaveLibraryDetails',' ',1 UNION
SELECT 'Library','SaveLibraryDetails',' ',1 UNION
SELECT 'Library','DeleteLibraryDetails',' ',1 UNION
SELECT 'Library','SearchLibrary',' ',1 UNION
SELECT 'Library','EditLibrary',' ',1 UNION
SELECT 'Library','SaveGraphicFile',' ',1 
GO


-- INSERT FRESH DATA

INSERT INTO MS_RoleAccess(RoleId,RoleType,AccessId,AccessModule)
SELECT '2','SA',AccessId,AccessModule FROM MS_UserAccess
GO

INSERT INTO MS_RoleAccess(RoleId,RoleType,AccessId,AccessModule)
SELECT '1','GU',AccessId,AccessModule FROM MS_UserAccess
WHERE AccessName  NOT IN ('Customer') AND AccessModule NOT IN ('GetCompany')
GO

INSERT INTO MS_RoleAccess(RoleId,RoleType,AccessId,AccessModule)
SELECT '4','SU',AccessId,AccessModule FROM MS_UserAccess
WHERE AccessName  NOT IN ('Customer','User','Panel') AND AccessModule NOT IN ('GetCompany','GetMaster')
UNION
SELECT '4','SU',AccessId,AccessModule FROM MS_UserAccess
WHERE AccessName = 'Panel' AND AccessModule IN ('GetPanleLibrary','SearchPanelList')
 
 GO
INSERT INTO MS_UserAccess
(AccessName,AccessModule,AccessLink,IsActive)
SELECT 'Music','SearchPlayList','',1 UNION
SELECT 'Music','AddPlayList','',1 UNION
SELECT 'Music','GetSongsInPlayList','',1 UNION
SELECT 'Music','SaveMusicFile','',1 
GO
 
INSERT INTO MS_RoleAccess(RoleId,RoleType,AccessId,AccessModule)
SELECT '2','SA',AccessId,AccessModule FROM MS_UserAccess WHERE AccessName = 'Music' UNION
SELECT '1','GU',AccessId,AccessModule FROM MS_UserAccess WHERE AccessName = 'Music' UNION
SELECT '4','SU',AccessId,AccessModule FROM MS_UserAccess WHERE AccessName = 'Music' UNION
SELECT '3','SLU',AccessId,AccessModule FROM MS_UserAccess WHERE AccessName = 'Music'  
