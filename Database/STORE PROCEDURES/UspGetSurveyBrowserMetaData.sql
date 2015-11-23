IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyBrowserMetaData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyBrowserMetaData]

GO
-- UspGetSurveyBrowserMetaData 1276
CREATE PROCEDURE DBO.UspGetSurveyBrowserMetaData
	@SurveyId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

    SELECT 
		TSBMD.MetaDataId, TSBMD.SurveyId, TSBMD.RespondentId, TSBMD.RespondentSessionId, TSBMD.IpAddress, 
		TSBMD.Browser, TSBMD.BrowserVersion, TSBMD.OperatingSystem, TSBMD.ScreenResolution, TSBMD.FlashVersion, 
		TSBMD.JavaSupport, TSBMD.SupportCookies, TSBMD.UserAgent, ML.LangauageName AS LanguageDesc
	FROM DBO.TR_SurveyBrowserMetaData TSBMD
	INNER JOIN DBO.TR_Survey TS
		ON TSBMD.SurveyId = TS.SurveyId
	INNER JOIN DBO.MS_Languages ML
	   ON TS.LanguageId = ML.LanguageId
	WHERE TSBMD.SurveyId = @SurveyId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 