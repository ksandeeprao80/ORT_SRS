ALTER TABLE TR_SurveyRequestDetails ADD RefereeId INT, Channel VARCHAR(100)
ALTER TABLE Audit_SurveyRequestDetails ADD RefereeId INT, Channel VARCHAR(100)

GO

UPDATE TR_SurveyRequestDetails SET RefereeId = 0
UPDATE Audit_SurveyRequestDetails SET RefereeId = 0

 