IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetEmailTrigger]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetEmailTrigger]

GO

-- EXEC UspGetEmailTrigger 13065
CREATE PROCEDURE DBO.UspGetEmailTrigger
	@QuestionId INT = NULL,
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		MQB.QuestionId, LTRIM(RTRIM(TET.TriggerExpression)) AS TriggerExpression, TET.Conjunction, TET.BranchId,
		ISNULL(TET.PreviousQuestionId,0) AS PreviousQuestionId
	FROM DBO.PB_TR_EmailTrigger TET
 	INNER JOIN DBO.MS_QuestionBranches MQB
 		ON TET.BranchId = MQB.BranchId
 		AND MQB.QuestionId = ISNULL(@QuestionId,MQB.QuestionId)
		AND MQB.SurveyId = ISNULL(@SurveyId,MQB.SurveyId)
		AND MQB.BranchType = 'Email' 
 	INNER JOIN TR_SurveyQuestions TSQ
 		ON MQB.QuestionId = TSQ.QuestionId	
 		AND TSQ.IsDeleted = 1	
 		
 	SELECT 
		SurveyId, LTRIM(RTRIM(ISNULL(TrueAction,''))) AS TrueAction, QuestionId, BranchId, 
		SendAtEnd, MessageLibId, EmailDetailId  
	FROM DBO.MS_QuestionBranches
	WHERE QuestionId = ISNULL(@QuestionId,QuestionId)
		AND SurveyId = ISNULL(@SurveyId,SurveyId)
		AND BranchType = 'Email'

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

