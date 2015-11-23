IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspComboLibraryCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspComboLibraryCategory]

GO
--EXEC UspComboLibraryCategory 15
 
CREATE PROCEDURE DBO.UspComboLibraryCategory
	@LibId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT   
		TL.LibId, TLC.CategoryId, TLC.CategoryName, MLT.TypeName  
	FROM DBO.TR_Library TL 
	INNER JOIN DBO.MS_LibraryType MLT  
		ON TL.LibTypeId = MLT.LibTypeId  
	INNER JOIN DBO.TR_QuestionLibrary TQL  
		ON TL.LibId = TQL.LibId
	INNER JOIN DBO.TR_LibraryCategory TLC
 		ON TL.LibId = TLC.LibId  
	WHERE TL.LibId = @LibId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
