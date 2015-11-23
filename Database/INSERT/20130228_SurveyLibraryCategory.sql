SELECT * INTO TR_Library_Backup_20130228 FROM TR_Library
SELECT * INTO TR_LibraryCategory_Backup_20130228 FROM TR_LibraryCategory
 

DECLARE @CurrentDate DATETIME
SET @CurrentDate = GETDATE()

INSERT INTO TR_Library
(LibTypeId,LibName,CustomerId,IsActive,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
SELECT 6,'Default',CustomerId,IsActive,CreatedBy,CreatedOn,ModifiedBy,@CurrentDate 
FROM MS_Customers WHERE CustomerId NOT IN(SELECT CustomerId FROM TR_Library WHERE LibTypeId =6)

INSERT INTO TR_LibraryCategory
(CategoryName,LibId,CategoryDescription,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
SELECT 'Weekly Chart Music Test',LibId,'Weekly Chart Music Test',CreatedBy,CreatedOn,ModifiedBy,ModifiedOn  FROM TR_Library WHERE LibTypeId = 6 AND LibId NOT IN
(SELECT A.LibId FROM TR_LibraryCategory A INNER JOIN TR_Library B ON A.LibId = B.LibId WHERE B.LibTypeId = 6)
UNION
SELECT 'Library Music Test',LibId,'Library Music Test',CreatedBy,CreatedOn,ModifiedBy,ModifiedOn FROM TR_Library WHERE LibTypeId = 6 AND LibId NOT IN
(SELECT A.LibId FROM TR_LibraryCategory A INNER JOIN TR_Library B ON A.LibId = B.LibId WHERE B.LibTypeId = 6)
UNION
SELECT 'Perceptual Study',LibId,'Perceptual Study',CreatedBy,CreatedOn,ModifiedBy,ModifiedOn FROM TR_Library WHERE LibTypeId = 6 AND LibId NOT IN
(SELECT A.LibId FROM TR_LibraryCategory A INNER JOIN TR_Library B ON A.LibId = B.LibId WHERE B.LibTypeId = 6)
