IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyQuota]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyQuota]

GO

-- EXEC UspGetSurveyQuota 
CREATE PROCEDURE DBO.UspGetSurveyQuota
	@QuotaId INT = NULL,
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TSQ.SurveyId, TSQ.QuotaId, 
		LTRIM(RTRIM(ISNULL(MQT.QuotaName,''))) AS QuotaName, 
		LTRIM(RTRIM(ISNULL(TSQ.Limit,''))) AS Limit
	FROM DBO.PB_TR_SurveyQuota TSQ
	INNER JOIN MS_QuotaType MQT
		ON TSQ.QuotaId = MQT.QuotaId
		AND TSQ.QuotaId = ISNULL(@QuotaId,TSQ.QuotaId)
		AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END