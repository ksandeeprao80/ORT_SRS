IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSkipLogic]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSkipLogic]

GO

-- EXEC UspGetSkipLogic 1304
CREATE PROCEDURE DBO.UspGetSkipLogic
	@SurveyId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		LTRIM(RTRIM(ISNULL(TSL.LogicExpression,''))) AS LogicExpression, 
		LTRIM(RTRIM(ISNULL(TSL.Conjunction,''))) AS Conjunction, MQB.BranchId, MQB.QuestionId,
		ISNULL(TSL.PreviousQuestionId,0) AS PreviousQuestionId
	FROM DBO.PB_TR_SkipLogic TSL
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TSL.BranchId = MQB.BranchId AND MQB.SurveyId = @SurveyId AND MQB.BranchType = 'Skip'

	SELECT 
		SurveyId, LTRIM(RTRIM(ISNULL(TrueAction,''))) AS TrueAction, 
		LTRIM(RTRIM(ISNULL(FalseAction,''))) AS FalseAction, QuestionId, BranchId  
	FROM DBO.MS_QuestionBranches
	WHERE SurveyId = @SurveyId AND BranchType = 'Skip'

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END