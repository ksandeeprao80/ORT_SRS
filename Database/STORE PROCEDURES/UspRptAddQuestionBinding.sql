IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptAddQuestionBinding]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptAddQuestionBinding

GO  
  
--EXEC DBO.UspRptAddQuestionBinding 

CREATE PROCEDURE DBO.UspRptAddQuestionBinding
	@ReportId INT,
	@QuestionId INT  
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	INSERT INTO DBO.TR_ReportQuestionMapped
	(ReportId, QuestionId)
	VALUES(@ReportId,@QuestionId)

	SELECT 1 AS RetValue, 'Successfully Inserted....' AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
