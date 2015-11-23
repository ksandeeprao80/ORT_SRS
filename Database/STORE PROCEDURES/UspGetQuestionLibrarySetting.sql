IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuestionLibrarySetting]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetQuestionLibrarySetting]

GO

--EXEC UspGetQuestionLibrarySetting NULL,17

CREATE PROCEDURE DBO.UspGetQuestionLibrarySetting
	@SettingId INT = NULL,
	@QuestionLibId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TQLS.QuestionLibId, TQLS.SettingId, MQS.SettingName, TQLS.Value
	FROM DBO.TR_QuestionLibrarySetting TQLS 
	INNER JOIN DBO.MS_QuestionSettings MQS
		ON TQLS.SettingId = MQS.SettingId
		AND TQLS.QuestionLibId = ISNULL(@QuestionLibId,TQLS.QuestionLibId)
		AND TQLS.SettingId = ISNULL(@SettingId,TQLS.SettingId)
	ORDER BY TQLS.SettingId ASC  	
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 