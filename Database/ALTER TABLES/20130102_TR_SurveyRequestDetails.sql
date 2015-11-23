ALTER TABLE DBO.TR_SurveyRequestDetails ADD RenderMode CHAR(1) 

GO

UPDATE DBO.TR_SurveyRequestDetails SET RenderMode = 'R'