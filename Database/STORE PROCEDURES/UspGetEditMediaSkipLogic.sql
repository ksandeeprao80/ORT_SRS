IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetEditMediaSkipLogic]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetEditMediaSkipLogic]

GO

-- EXEC UspGetEditMediaSkipLogic 8991
CREATE PROCEDURE DBO.UspGetEditMediaSkipLogic
	@QuestionId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		MQB.QuestionId, LTRIM(RTRIM(ISNULL(TMSL.LogicExpression,''))) AS LogicExpression, 
		TMSL.Conjunction, TMSL.BranchId, ISNULL(TMSL.PreviousQuestionId,0) AS PreviousQuestionId
	FROM DBO.TR_MediaSkipLogic TMSL
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TMSL.BranchId = MQB.BranchId AND MQB.QuestionId = @QuestionId AND MQB.BranchType = 'Media'
		
	SELECT 
		SurveyId, LTRIM(RTRIM(ISNULL(TrueAction,''))) AS TrueAction, 
		LTRIM(RTRIM(ISNULL(FalseAction,''))) AS FalseAction, QuestionId, BranchId  
	FROM DBO.MS_QuestionBranches
	WHERE QuestionId = @QuestionId AND BranchType = 'Media'	

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END