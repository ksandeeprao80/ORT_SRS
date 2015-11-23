IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTimeZone]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTimeZone]

GO

--EXEC UspGetTimeZone 5 
CREATE PROCEDURE DBO.UspGetTimeZone
	@TimeZoneId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		TimeZoneId, TimeZone, LocationName
	FROM DBO.MS_TimeZone WITH(NOLOCK)
	WHERE TimeZoneId = ISNULL(@TimeZoneId,TimeZoneId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 