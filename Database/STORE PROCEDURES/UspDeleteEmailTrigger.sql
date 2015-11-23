IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteEmailTrigger]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteEmailTrigger]
GO

-- EXEC UspDeleteEmailTrigger 13065

CREATE PROCEDURE DBO.UspDeleteEmailTrigger
	@QuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DELETE TET
	FROM DBO.TR_EmailTrigger TET 
	INNER JOIN DBO.MS_QuestionBranches MQB 
		ON TET.BranchId = MQB.BranchId AND MQB.QuestionId = @QuestionId AND MQB.BranchType = 'Email'
		
	DELETE FROM DBO.MS_QuestionBranches WHERE QuestionId = @QuestionId AND BranchType = 'Email'	
	
	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
	
 	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END