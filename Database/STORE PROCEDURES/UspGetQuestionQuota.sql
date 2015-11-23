IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuestionQuota]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetQuestionQuota]

GO
-- UspGetQuestionQuota 
CREATE PROCEDURE DBO.UspGetQuestionQuota
	@QuestionId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TQQ.QuotaId, MQB.QuestionId, TQQ.LogicExpression, TQQ.Conjunction, TQQ.BranchId, 
		ISNULL(TQQ.PreviousQuestionId,0) AS PreviousQuestionId
	FROM DBO.PB_TR_QuestionQuota TQQ
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TQQ.BranchId = MQB.BranchId AND MQB.QuestionId = @QuestionId AND MQB.BranchType = 'Quota'
		
	SELECT 
		SurveyId, LTRIM(RTRIM(ISNULL(TrueAction,''))) AS TrueAction, 
		LTRIM(RTRIM(ISNULL(FalseAction,''))) AS FalseAction, QuestionId, BranchId  
	FROM DBO.MS_QuestionBranches
	WHERE QuestionId = @QuestionId AND BranchType = 'Quota'	
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END