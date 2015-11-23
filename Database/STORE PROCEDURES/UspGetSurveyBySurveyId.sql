IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyBySurveyId]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyBySurveyId]

GO
-- EXEC UspGetSurveyBySurveyId 1241
CREATE PROCEDURE DBO.UspGetSurveyBySurveyId
	@SurveyId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TS.SurveyId, TS.SurveyName, TS.CustomerId, ISNULL(TS.StarMarked,0) AS StarMarked, 
		TS.RewardEnabled, TS.CreatedBy, CONVERT(VARCHAR(10),TS.CreatedDate,101) AS CreatedDate, 
		ISNULL(TS.ModifiedBy,0) AS ModifiedBy, 
		CASE WHEN ISNULL(CONVERT(VARCHAR(10),TS.ModifiedDate,101),'01/01/1900') = '01/01/1900' THEN '' 
			ELSE CONVERT(VARCHAR(10),TS.ModifiedDate,101) END AS ModifiedDate,
		ISNULL(TS.IsActive,0) AS IsActive, TS.CategoryId, TS.LanguageId,
		CASE WHEN ISNULL(CONVERT(VARCHAR(10),TS.SurveyEndDate,101),'01/01/1900') = '01/01/1900' THEN '' 
		     ELSE CONVERT(VARCHAR(10),TS.SurveyEndDate,121) END AS SurveyEndDate,
		ML.LangauageName AS LanguageDesc
	FROM DBO.TR_Survey TS
	INNER JOIN DBO.MS_Languages ML
	   ON TS.LanguageId = ML.LanguageId
	WHERE TS.SurveyId = @SurveyId
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END