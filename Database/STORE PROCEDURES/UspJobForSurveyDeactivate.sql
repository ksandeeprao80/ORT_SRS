IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspJobForSurveyDeactivate]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspJobForSurveyDeactivate]

GO
-- EXEC UspJobForSurveyDeactivate 
CREATE PROCEDURE DBO.UspJobForSurveyDeactivate
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	SELECT 
		TS.SurveyId, TS.SurveyEndDate, 
		CASE WHEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''))),1)='-' THEN '-'
			 WHEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''))),1)='+' THEN '+'
			 ELSE '' END AS Flag,
		CONVERT(TIME,REPLACE(REPLACE(REPLACE(REPLACE(MTZ.TimeZone,'GMT',''),'hour',''),'-',''),'+','')) AS PlusMinusTime
	INTO #Survey	
	FROM TR_Survey TS
	INNER JOIN dbo.MS_Users MU
			ON TS.CreatedBy = MU.UserId	
		INNER JOIN MS_TimeZone MTZ 
			ON MU.TimeZone = MTZ.TimeZoneId 
	WHERE TS.SurveyEndDate < GETDATE()+ 2
		AND TS.StatusId <> 2 
		AND ISNULL(TS.SurveyEndDate,'1900-01-01') <> '1900-01-01'

	SELECT 
		SurveyId, SurveyEndDate, Flag, PlusMinusTime,
		CASE WHEN Flag = '-' THEN SurveyEndDate-PlusMinusTime
			 WHEN Flag = '+' THEN SurveyEndDate+PlusMinusTime
			 ELSE SurveyEndDate END AS ActualSentDateTime
	INTO #SurveyActInactiveData		 
	FROM #Survey
	
	UPDATE TS
	SET TS.StatusId = 2 /*0--Inactive,1--Active,2--Completed*/
	FROM #SurveyActInactiveData SA
	INNER JOIN DBO.TR_Survey TS
		ON SA.SurveyId = TS.SurveyId
	WHERE SA.ActualSentDateTime <= GETDATE()

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END