IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetLanguages]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetLanguages]

GO

--EXEC UspGetLanguages 2
--EXEC UspGetLanguages NULL

CREATE PROCEDURE DBO.UspGetLanguages
	@LanguageId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		LanguageId, ISNULL(LangauageName,'') AS LangauageName, IsActive
	FROM DBO.MS_Languages WITH(NOLOCK)
	WHERE LanguageId = ISNULL(@LanguageId,LanguageId)
	   AND IsActive = 1

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END