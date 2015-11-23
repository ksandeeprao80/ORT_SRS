IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuestionSettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetQuestionSettings

GO

-- EXEC UspGetQuestionSettings 3
-- EXEC UspGetQuestionSettings 
CREATE PROCEDURE DBO.UspGetQuestionSettings
	@SettingId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT  
		SettingId, ISNULL(SettingName,'') AS SettingName
	FROM DBO.MS_QuestionSettings WITH(NOLOCK)
	WHERE SettingId = ISNULL(@SettingId,SettingId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
