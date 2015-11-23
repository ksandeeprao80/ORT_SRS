IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveySettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveySettings]

GO

-- EXEC UspGetSurveySettings 3
-- EXEC UspGetSurveySettings 
CREATE PROCEDURE DBO.UspGetSurveySettings
	@SettingId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT  
		SettingId, ISNULL(SettingType,'') AS SettingType, ISNULL(SettingName,'') AS SettingName, 
		ISNULL(DisplayText,'') AS DisplayText
	FROM DBO.MS_SurveySettings WITH(NOLOCK)
	WHERE SettingId = ISNULL(@SettingId,SettingId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
