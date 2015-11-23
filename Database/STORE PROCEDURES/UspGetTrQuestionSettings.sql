IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTrQuestionSettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetTrQuestionSettings

GO

-- EXEC UspGetTrQuestionSettings NULL,1090
CREATE PROCEDURE DBO.UspGetTrQuestionSettings
	@SettingId INT = NULL,
	@QuestionId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		ISNULL(TQS.QuestionId,'') AS QuestionId, MQS.SettingId, 
		LTRIM(RTRIM(ISNULL(MQS.SettingName,''))) AS SettingName, 
		LTRIM(RTRIM(ISNULL(TQS.Value,''))) AS Value
	FROM DBO.MS_QuestionSettings MQS
	LEFT OUTER JOIN 
	(
		SELECT * FROM DBO.PB_TR_QuestionSettings  
		WHERE SettingId = ISNULL(@SettingId,SettingId)
			AND QuestionId = ISNULL(@QuestionId,QuestionId)
	) TQS
		ON MQS.SettingId = TQS.SettingId
	ORDER BY SettingId ASC

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END