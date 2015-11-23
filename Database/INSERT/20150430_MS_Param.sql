DECLARE @LibId INT
DECLARE @CategoryId INT

INSERT INTO dbo.TR_Library
(LibTypeId, LibName, CustomerId, IsActive, CreatedBy, CreatedOn)
SELECT 2,'Question Quota',1,1,1,GETDATE() 

SET @LibId = @@IDENTITY

INSERT INTO dbo.TR_LibraryCategory
(CategoryName, LibId, CategoryDescription, CreatedBy, CreatedOn)
SELECT 'Question Quota',@LibId,'Question Quota',1,GETDATE()

SET @CategoryId = @@IDENTITY

INSERT INTO DBO.TR_MessageLibrary
(LibId, MessageTypeId, MessageDescription, MessageText, IsActive, CategoryId, CreatedBy, CreatedOn)
SELECT @LibId,2,'Message Library For Question Quota','Question Quota',1,@CategoryId,1,GETDATE()

INSERT INTO DBO.MS_Param 
(ParamValue, ParamText, IsActive)
SELECT 'Survey <Surveyname>: Quota breached alert',
'Notification Alert: Quota of <quantity> on <perceptual field> breached for survey <surveyname>',1