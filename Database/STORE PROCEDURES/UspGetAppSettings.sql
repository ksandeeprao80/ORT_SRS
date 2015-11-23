IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetAppSettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetAppSettings]

GO

-- EXEC UspGetAppSettings
CREATE PROCEDURE DBO.UspGetAppSettings
	@SettingId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY
	SELECT  
		SettingId, ISNULL(ParamName,'') AS ParamName, ISNULL(ParamValue,'') AS ParamValue, 
		ISNULL(ParamType,'') AS ParamType
	FROM DBO.MS_AppSettings WITH(NOLOCK)
	WHERE SettingId = ISNULL(@SettingId,SettingId)
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
