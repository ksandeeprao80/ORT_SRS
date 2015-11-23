IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptUpdateQuestionStatus]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptUpdateQuestionStatus]

GO 
-- EXEC UspRptUpdateQuestionStatus 11617

CREATE PROCEDURE DBO.UspRptUpdateQuestionStatus
	@QuestionId INT,
	@ReportId INT		  
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	UPDATE DBO.TR_ReportQuestions
	SET StatusId = CASE WHEN StatusId = 0 THEN 1 ELSE 0 END 
	WHERE QuestionId = @QuestionId AND ReportId = @ReportId
	
	SELECT 1 AS RetValue, 'Successfully Updated' AS Remark

 	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END