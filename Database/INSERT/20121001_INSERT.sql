INSERT INTO DBO.MS_LibraryType
(TypeName, IsActive)
SELECT 'PANEL',1

GO

INSERT INTO dbo.TR_Library
SELECT 7,'Nilesh Test',1,1 UNION 
SELECT 7,'SRS Test',1,1 

GO
DECLARE @LibId INT,
DECLARE @LibId1 INT

SELECT @LibId = LibId FROM TR_Library WHERE LibTypeId = 7 AND LibName = 'Nilesh Test'
SELECT @LibId1 = LibId FROM TR_Library WHERE LibTypeId = 7 AND LibName = 'SRS Test'

INSERT INTO DBO.TR_PanelCategory
SELECT 'NileshTest',@LibId UNION
SELECT 'JohnnyTest',@LibId1 UNION
SELECT 'SandeepTest',@LibId UNION 
SELECT 'GovindTest',@LibId1 

GO

UPDATE DBO.MS_PanelMembers 
SET LibId = (SELECT LibId FROM TR_Library WHERE LibTypeId = 7 AND LibName = 'Nilesh Test')

