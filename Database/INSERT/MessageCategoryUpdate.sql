UPDATE TML
SET TML.CategoryId = TCL.CategoryId
FROM TR_MessageLibrary TML
INNER JOIN TR_LibraryCategory TCL
ON TML.LibId = TCL.LibId