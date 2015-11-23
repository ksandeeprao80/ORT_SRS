IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetCountry]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetCountry]

GO

--EXEC UspGetCountry NULL
CREATE PROCEDURE DBO.UspGetCountry
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		CountryId, CountryCode, CountryName
	FROM DBO.MS_Country WITH(NOLOCK)
	ORDER BY CountryName ASC

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END