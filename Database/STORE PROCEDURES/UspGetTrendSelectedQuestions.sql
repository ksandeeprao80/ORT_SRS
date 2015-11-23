IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTrendSelectedQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTrendSelectedQuestions]

GO
-- EXEC UspGetTrendSelectedQuestions 26

CREATE PROCEDURE DBO.UspGetTrendSelectedQuestions
	@ReportId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT DISTINCT QuestionId FROM DBO.TR_ReportQuestionMapped WHERE ReportId = @ReportId
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END









