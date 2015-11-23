IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetReportQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetReportQuestions]

GO
-- EXEC UspGetReportQuestions  

CREATE PROCEDURE DBO.UspGetReportQuestions
	@RQId INT = NULL,
	@RDSId INT = NULL,
	@ReportId INT = NULL,
	@QuestionId INT = NULL,
	@StatusId  INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		RQId, RDSId, ReportId, QuestionId, StatusId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
	FROM dbo.TR_ReportQuestions
	WHERE RQId = ISNULL(@RQId,RQId)
		AND RDSId = ISNULL(@RDSId,RDSId)
		AND ReportId = ISNULL(@ReportId,ReportId)
		AND QuestionId = ISNULL(@QuestionId,QuestionId) 
		AND @StatusId  = ISNULL(@StatusId,StatusId) 
 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


