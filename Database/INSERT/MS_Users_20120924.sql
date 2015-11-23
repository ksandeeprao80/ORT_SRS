UPDATE MS_Users SET ModifiedOn = CreatedOn WHERE ModifiedOn IS NULL
GO
UPDATE MS_Customers SET ModifiedOn = CreatedOn WHERE ModifiedOn IS NULL
GO
INSERT INTO MS_SurveySettings
VALUES('','PipingIn','Piping-in of data for a question') 
GO
INSERT INTO MS_SurveySettings 
VALUES('','PipingOut','Piping-out of data for a question') 
GO
INSERT INTO MS_SurveySettings
VALUES('','ValidationAnswerValues','Validation of answer values')  
GO
INSERT INTO MS_SurveySettings
VALUES('','CheckQuotas','Check quotas')  
GO
INSERT INTO MS_SurveySettings
VALUES('','NextBackTextLink','Display next/prev buttons/links')  
GO
INSERT INTO MS_SurveySettings
VALUES('','CheckSurveyEnd','Check if survey has ended')  
GO
INSERT INTO MS_SurveySettings
VALUES('','RewardSet','If rewards have been set on this survey?')  
GO
INSERT INTO MS_SurveySettings
VALUES('','FollowupMTBQue','Follow-up question on MTB question?')  
GO
INSERT INTO MS_SurveySettings
VALUES('','VerificationQuestion','Verification question?')  
GO
INSERT INTO MS_SurveySettings
VALUES('','2ndValidation','2nd Validation?')  
GO
INSERT INTO MS_SurveySettings
VALUES('','SkipLogic','Skip Logic?')  
GO
INSERT INTO MS_SurveySettings
VALUES('','QuestionAssociatedObject','Question with associated object?')  
