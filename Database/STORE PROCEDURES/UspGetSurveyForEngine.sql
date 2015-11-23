IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyForEngine]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyForEngine]

GO
-- EXEC UspGetSurveyForEngine NULL,NULL 
CREATE PROCEDURE DBO.UspGetSurveyForEngine
	@SurveyId INT = NULL,
	@CustomerId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TS.SurveyId, TS.SurveyName, TS.CustomerId, ISNULL(TS.StarMarked,0) AS StarMarked, 
		TS.RewardEnabled, TS.CreatedBy, TS.CreatedDate, ISNULL(TS.ModifiedBy,0) AS ModifiedBy, 
		ISNULL(TS.ModifiedDate,'') AS ModifiedDate, TS.IsActive, TS.CategoryId, TS.LanguageId,
		CASE WHEN CONVERT(VARCHAR(10),TS.SurveyEndDate,101) = '01/01/1900' THEN '' 
			ELSE CONVERT(VARCHAR(10),TS.SurveyEndDate,121) END AS SurveyEndDate,
		ML.LangauageName AS LanguageDesc	
	FROM DBO.PB_TR_Survey TS
	INNER JOIN DBO.MS_Languages ML
	   ON TS.LanguageId = ML.LanguageId
	WHERE TS.SurveyId = ISNULL(@SurveyId,TS.SurveyId)
		AND TS.CustomerId = ISNULL(@CustomerId,TS.CustomerId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

