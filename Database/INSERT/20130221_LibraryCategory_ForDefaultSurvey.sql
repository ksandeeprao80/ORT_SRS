INSERT INTO DBO.TR_LibraryCategory
(CategoryName, LibId, CategoryDescription, CreatedOn, ModifiedOn)
SELECT A.* FROM 
(
	SELECT 
		'Weekly Chart Music Test' AS CategoryName, LibId, 'Weekly Chart Music Test' AS CategoryDescription, 
		GETDATE() AS CreatedOn,  GETDATE() AS ModifiedOn
	FROM TR_Library WHERE LibTypeId = 6 AND LibId IN (SELECT LibId FROM TR_LibraryCategory) 
	UNION
	SELECT 
		'Library Music Test' AS CategoryName, LibId, 'Library Music Test' AS CategoryDescription, 
		GETDATE() AS CreatedOn,  GETDATE() AS ModifiedOn
	FROM TR_Library WHERE LibTypeId = 6 AND LibId IN (SELECT LibId FROM TR_LibraryCategory) 
	UNION
	SELECT 
		'Perceptual Study' AS CategoryName, LibId, 'Perceptual Study'AS CategoryDescription, 
		GETDATE() AS CreatedOn,  GETDATE() AS ModifiedOn
	FROM TR_Library WHERE LibTypeId = 6 AND LibId IN (SELECT LibId FROM TR_LibraryCategory)  
) A 
ORDER BY A.LibId, A.CategoryName

