UPDATE TS
SET TS.CategoryId = TLC.CategoryId
FROM TR_Survey TS
INNER JOIN TR_Library TL
ON TS.CustomerId = TL.CustomerId
AND TL.LibTypeId = 6
AND TL.IsActive = 1
INNER JOIN TR_LibraryCategory TLC
ON TL.LibId = TLC.LibId
WHERE TS.CategoryId  = 0
AND TLC.CategoryName = 'Perceptual Study'