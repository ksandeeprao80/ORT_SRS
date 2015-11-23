INSERT INTO MS_RoleAccess
(RoleId,RoleType,AccessId,AccessModule)
SELECT 3,'SLU',12, 'GetLibraryCategories' UNION
SELECT 3,'SLU',11, 'GetLibraries' UNION
SELECT 3,'SLU',27, 'GetPanleLibrary' UNION
SELECT 3,'SLU',63, 'GetSurveyTemplates' UNION
SELECT 3,'SLU',32, 'MySurveys' 