ALTER TABLE TR_Skiplogic DROP CONSTRAINT FK_TR_Skip_Logic_TR_Survey_Questions
GO
ALTER TABLE TR_Skiplogic DROP COLUMN QuestionId 
GO
ALTER TABLE TR_Skiplogic ADD SurveyId INT
GO
ALTER TABLE TR_Skiplogic ADD CONSTRAINT FK_TR_SkipLogic_TR_Survey FOREIGN KEY (SurveyId) REFERENCES TR_Survey(SurveyId) 
GO
ALTER TABLE DBO.TR_Responses ADD ResponseDate DATETIME 
