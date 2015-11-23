TRUNCATE TABLE DBO.PB_TR_MediaSkipLogic
INSERT INTO DBO.PB_TR_MediaSkipLogic
(LogicExpression,TrueAction,FalseAction,QuestionId)
SELECT LogicExpression,TrueAction,FalseAction,QuestionId FROM DBO.TR_MediaSkipLogic
----------------------------------------------------------------------------------
TRUNCATE TABLE DBO.PB_TR_QuestionQuota 
INSERT INTO DBO.PB_TR_QuestionQuota 
(QuotaId,QuestionId,LogicExpression,FalseAction)
SELECT QuotaId,QuestionId,LogicExpression,FalseAction FROM DBO.TR_QuestionQuota  
----------------------------------------------------------------------------------
TRUNCATE TABLE DBO.PB_TR_QuestionSettings
INSERT INTO DBO.PB_TR_QuestionSettings
(QuestionId,SettingId,Value)
SELECT QuestionId,SettingId,Value FROM DBO.TR_QuestionSettings  
----------------------------------------------------------------------------------
TRUNCATE TABLE DBO.PB_TR_SkipLogic
INSERT INTO DBO.PB_TR_SkipLogic 
(LogicExpression,TrueAction,FalseAction,SurveyId)
SELECT LogicExpression,TrueAction,FalseAction,SurveyId FROM DBO.TR_SkipLogic  
----------------------------------------------------------------------------------
TRUNCATE TABLE DBO.PB_TR_Survey
INSERT INTO DBO.PB_TR_Survey
(
	SurveyId,SurveyName,CustomerId,StarMarked,RewardEnabled,CreatedBy,CreatedDate,ModifiedBy,
	ModifiedDate,IsActive,StatusId,CategoryId,LanguageId,SurveyEndDate
)
SELECT  
	SurveyId,SurveyName,CustomerId,StarMarked,RewardEnabled,CreatedBy,CreatedDate,ModifiedBy,
	ModifiedDate,IsActive,StatusId,CategoryId,LanguageId,SurveyEndDate
FROM DBO.TR_Survey  
----------------------------------------------------------------------------------
TRUNCATE TABLE DBO.PB_TR_SurveyAnswers
INSERT INTO DBO.PB_TR_SurveyAnswers
(AnswerId,QuestionId,Answer,AnswerText)
SELECT AnswerId,QuestionId,Answer,AnswerText FROM DBO.TR_SurveyAnswers  
----------------------------------------------------------------------------------
TRUNCATE TABLE DBO.PB_TR_SurveyQuestions 
INSERT INTO DBO.PB_TR_SurveyQuestions 
(QuestionId,SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted,DefaultAnswerId,QuestionNo)
SELECT 
	QuestionId,SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted,DefaultAnswerId,QuestionNo
FROM DBO.TR_SurveyQuestions  
----------------------------------------------------------------------------------
TRUNCATE TABLE DBO.PB_TR_SurveyQuota
INSERT INTO DBO.PB_TR_SurveyQuota
(SurveyId,QuotaId,Limit)
SELECT SurveyId,QuotaId,Limit FROM DBO.TR_SurveyQuota  
----------------------------------------------------------------------------------
TRUNCATE TABLE DBO.PB_TR_SurveySettings
INSERT INTO DBO.PB_TR_SurveySettings 
(SurveyId,SettingId,CustomerId,Value)
SELECT SurveyId,SettingId,CustomerId,Value FROM DBO.TR_SurveySettings 
 
 
 