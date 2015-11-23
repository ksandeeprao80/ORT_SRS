IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteQuestionQuota]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteQuestionQuota]
GO

-- EXEC UspDeleteQuestionQuota 12990

CREATE PROCEDURE DBO.UspDeleteQuestionQuota
	@QuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DELETE TQQ
	FROM DBO.TR_QuestionQuota TQQ 
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TQQ.BranchId = MQB.BranchId AND MQB.QuestionId = @QuestionId AND MQB.BranchType = 'Quota' 

	DELETE FROM DBO.MS_QuestionBranches   
	WHERE QuestionId = @QuestionId AND BranchType = 'Quota'

	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
	
 	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END