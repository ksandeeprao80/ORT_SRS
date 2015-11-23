ALTER TABLE DBO.TR_Survey ADD PublishStatus VARCHAR(1) DEFAULT('U')
GO

UPDATE DBO.TR_Survey SET PublishStatus = 'U'

UPDATE TS
SET TS.PublishStatus = 'P'
FROM DBO.TR_Survey TS
INNER JOIN DBO.PB_TR_Survey PTS
ON TS.SurveyId = PTS.SurveyId
