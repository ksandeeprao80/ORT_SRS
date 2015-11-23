-- TR_Library
UPDATE TL1
SET TL1.CreatedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.CreatedOn = GETDATE(),
    TL1.ModifiedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.ModifiedOn = GETDATE()
FROM TR_Library TL1 
INNER JOIN 
(
	SELECT 
	DISTINCT MU.* FROM MS_Users MU
	INNER JOIN TR_Library TL 
	ON MU.CustomerId = TL.CustomerId
	WHERE MU.UserType = 'GU'
	AND MU.IsActive = 1
) MU1
ON TL1.CustomerId = MU1.CustomerId

GO

-- TR_LibraryCategory
UPDATE TL1
SET TL1.CreatedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.CreatedOn = GETDATE(),
    TL1.ModifiedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.ModifiedOn = GETDATE()
FROM TR_LibraryCategory TL1 
INNER JOIN 
(
	SELECT 
	DISTINCT TL.LibId, MU.* FROM MS_Users MU
	INNER JOIN TR_Library TL 
	ON MU.CustomerId = TL.CustomerId
	WHERE MU.UserType = 'GU'
	AND MU.IsActive = 1
) MU1
ON TL1.LibId = MU1.LibId

GO

-- TR_FileLibrary
UPDATE TL1
SET TL1.CreatedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.CreatedOn = GETDATE(),
    TL1.ModifiedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.ModifiedOn = GETDATE()
FROM TR_FileLibrary TL1 
INNER JOIN 
(
	SELECT 
	DISTINCT TL.LibId, MU.* FROM MS_Users MU
	INNER JOIN TR_Library TL 
	ON MU.CustomerId = TL.CustomerId
	WHERE MU.UserType = 'GU'
	AND MU.IsActive = 1
) MU1
ON TL1.LibId = MU1.LibId

GO

-- TR_MessageLibrary
UPDATE TL1
SET TL1.CreatedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.CreatedOn = GETDATE(),
    TL1.ModifiedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.ModifiedOn = GETDATE()
FROM TR_MessageLibrary TL1 
INNER JOIN 
(
	SELECT 
	DISTINCT TL.LibId, MU.* FROM MS_Users MU
	INNER JOIN TR_Library TL 
	ON MU.CustomerId = TL.CustomerId
	WHERE MU.UserType = 'GU'
	AND MU.IsActive = 1
) MU1
ON TL1.LibId = MU1.LibId

GO

-- TR_QuestionLibrary

UPDATE TL1
SET TL1.CreatedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.CreatedOn = GETDATE(),
    TL1.ModifiedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.ModifiedOn = GETDATE()
FROM TR_QuestionLibrary TL1 
INNER JOIN 
(
	SELECT 
	DISTINCT TL.LibId, MU.* FROM MS_Users MU
	INNER JOIN TR_Library TL 
	ON MU.CustomerId = TL.CustomerId
	WHERE MU.UserType = 'GU'
	AND MU.IsActive = 1
) MU1
ON TL1.LibId = MU1.LibId

GO

-- TR_SurveyLibrary

UPDATE TL1
SET TL1.CreatedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.CreatedOn = GETDATE(),
    TL1.ModifiedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.ModifiedOn = GETDATE()
FROM TR_SurveyLibrary TL1 
INNER JOIN 
(
	SELECT 
	DISTINCT TL.LibId, MU.* FROM MS_Users MU
	INNER JOIN TR_Library TL 
	ON MU.CustomerId = TL.CustomerId
	WHERE MU.UserType = 'GU'
	AND MU.IsActive = 1
) MU1
ON TL1.LibId = MU1.LibId

GO
-- MS_PlayList

UPDATE MPL
SET MPL.CustomerId = TFL.CustomerId
FROM DBO.MS_PlayList MPL
INNER JOIN dbo.TR_PlayList TPL
ON MPL.PlayListId = TPL.PlayListId
LEFT OUTER JOIN 
(
	SELECT TFL.FileLibId, TL.CustomerId 
	FROM TR_FileLibrary TFL
	INNER JOIN TR_Library TL
	ON TFL.LIBID = TL.LibId
) TFL
ON TPL.FileLibId = TFL.FileLibId

GO

UPDATE MS_PlayList
SET CustomerId = 1 
WHERE CustomerId IS NULL

GO

UPDATE TL1
SET TL1.CreatedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.CreatedOn = GETDATE(),
    TL1.ModifiedBy = CASE WHEN ISNULL(MU1.UserId,'') = '' THEN MU1.CreatedBy ELSE MU1.UserId END,
    TL1.ModifiedOn = GETDATE()
FROM MS_PlayList TL1 
INNER JOIN 
(
	SELECT 
	DISTINCT MU.* FROM MS_Users MU
	INNER JOIN TR_Library TL 
	ON MU.CustomerId = TL.CustomerId
	WHERE MU.UserType = 'GU'
	AND MU.IsActive = 1
) MU1
ON TL1.CustomerId = MU1.CustomerId