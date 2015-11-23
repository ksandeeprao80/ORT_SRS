declare @CustomerId INT

DECLARE custCursor CURSOR
for select CustomerId from MS_Customers WHERE CustomerId NOT IN (1,42)

OPEN custCursor
FETCH NEXT FROM custCursor  INTO @CustomerId
EXEC DBO.UspSaveDefaultSurveyCateogries @CustomerId
	

WHILE @@FETCH_STATUS = 0
 
BEGIN
    FETCH NEXT FROM custCursor INTO @CustomerId
    EXEC DBO.UspSaveDefaultSurveyCateogries @CustomerId
END

--select * from TR_Library where LibTypeId = 6

--SELECT * FROM TR_LibraryCategory WHERE LibId IN (select LibId from TR_Library where LibTypeId = 6)