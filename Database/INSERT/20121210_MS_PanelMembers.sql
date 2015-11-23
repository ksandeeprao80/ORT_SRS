DECLARE @LibId INT, @CategoryId INT 
SELECT @LibId = LibId FROM TR_Library WHERE LibName = 'Click Seattle Modern Pop' AND CustomerId = 1
SELECT @CategoryId = CategoryId FROM TR_LibraryCategory WHERE LibId = @LibId AND CategoryName = 'KLCK1'

------SELECT @LibId,@CategoryId 
INSERT INTO DBO.MS_PanelMembers
(PanelistName,CustomerId,LastUsed,IsActive,LibId,CategoryId)
SELECT 'Hal Rood',1,GETDATE(),1,@LibId,@CategoryId UNION
SELECT 'Merrie Farley',1,GETDATE(),1,@LibId,@CategoryId 
 

