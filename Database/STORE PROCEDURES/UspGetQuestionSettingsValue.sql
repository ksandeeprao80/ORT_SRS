IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuestionSettingsValue]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetQuestionSettingsValue

GO

-- EXEC UspGetQuestionSettingsValue 10163,'ForceResponse'
 
CREATE PROCEDURE DBO.UspGetQuestionSettingsValue 
	@QuestionId INT,
	@SettingName VARCHAR(50)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT  
		ISNULL(TQS.Value,'') AS Value 
	FROM DBO.MS_QuestionSettings MQS WITH(NOLOCK)
	INNER JOIN DBO.TR_QuestionSettings TQS  WITH(NOLOCK)
		ON MQS.SettingId = TQS.SettingId
	WHERE TQS.QuestionId = @QuestionId
		AND LTRIM(RTRIM(MQS.SettingName)) = LTRIM(RTRIM(@SettingName))	

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
 