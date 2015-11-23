IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetCity]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetCity]

GO

--EXEC UspGetCity 4
--EXEC UspGetCity NULL
CREATE PROCEDURE DBO.UspGetCity
	@StateId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		CityId, CityCode, CityName, StateId
	FROM DBO.MS_City WITH(NOLOCK)
	WHERE StateId = ISNULL(@StateId,StateId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 