--SELECT 
--	DISTINCT TS.SurveyId, TS.CustomerId AS SurveyCustomer, TL.CustomerId AS LibCustomer 
UPDATE TS
SET TS.CustomerId = TL.CustomerId	
FROM TR_Survey TS
INNER JOIN TR_LibraryCategory TLC
	ON TS.CategoryId = TLC.CategoryId
INNER JOIN TR_Library TL
	ON TLC.LibId = TL.LibId
WHERE TS.CustomerId <> TL.CustomerId