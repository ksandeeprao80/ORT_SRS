IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetState]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetState]

GO

--EXEC UspGetState 2
--EXEC UspGetState NULL
CREATE PROCEDURE DBO.UspGetState
	@CountryId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		StateId, StateCode, StateName, CountryId
	FROM DBO.MS_State WITH(NOLOCK)
	WHERE CountryId = ISNULL(@CountryId,CountryId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END