IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTranslations]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTranslations]

GO

-- EXEC UspGetTranslations 
CREATE PROCEDURE DBO.UspGetTranslations
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TT.SurveyId, TT.LanguageId, LTRIM(RTRIM(ISNULL(TT.EntityType,''))) AS EntityType,
		TT.EntityTypeId, LTRIM(RTRIM(ISNULL(TT.TransText,''))) AS TransText,
		LTRIM(RTRIM(ISNULL(TS.SurveyName,''))) AS SurveyName
	FROM DBO.TR_Translations TT
	INNER JOIN DBO.PB_TR_Survey TS
		ON TT.SurveyId = TS.SurveyId
		AND TT.SurveyId = ISNULL(@SurveyId,TT.SurveyId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END