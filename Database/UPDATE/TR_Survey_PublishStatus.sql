UPDATE dbo.TR_Survey SET PublishStatus = NULL 
GO
UPDATE TS
SET TS.PublishStatus = 'P'
FROM dbo.TR_Survey TS
INNER JOIN TR_SurveyRequestDetails TSRD
ON TS.SurveyId = TSRD.SurveyId 
WHERE TSRD.RenderMode = 'R'


