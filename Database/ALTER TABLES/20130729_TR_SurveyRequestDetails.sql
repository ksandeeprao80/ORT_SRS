ALTER TABLE DBO.TR_SurveyRequestDetails ADD ResponseStatus VARCHAR(1)

UPDATE DBO.TR_SurveyRequestDetails SET ResponseStatus = 'C' WHERE RespondentId <> 0