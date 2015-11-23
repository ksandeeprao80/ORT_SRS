IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSkipLogic]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteSkipLogic]
GO

--EXEC UspDeleteSkipLogic 1242,12172

CREATE PROCEDURE DBO.UspDeleteSkipLogic
	@SurveyId INT,
	@QuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DELETE TSL 
	FROM DBO.TR_SkipLogic TSL 
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TSL.BranchId = MQB.BranchId
		AND MQB.SurveyId = @SurveyId 
		AND MQB.QuestionId = ISNULL(@QuestionId,MQB.QuestionId) AND MQB.BranchType = 'Skip'

	DELETE FROM DBO.MS_QuestionBranches 
	WHERE SurveyId = @SurveyId AND QuestionId = ISNULL(@QuestionId,QuestionId) AND BranchType = 'Skip'
	
	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
	
 	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END