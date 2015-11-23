IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTrendSelectedScore]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTrendSelectedScore]

GO
-- EXEC UspGetTrendSelectedScore 26

CREATE PROCEDURE DBO.UspGetTrendSelectedScore
	@ReportId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT DISTINCT ScoreId FROM DBO.TR_ReportScoreMapped WHERE ReportId = @ReportId
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END



 





