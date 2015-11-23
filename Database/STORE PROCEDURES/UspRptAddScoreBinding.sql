IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptAddScoreBinding]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptAddScoreBinding

GO   
  
--EXEC DBO.UspRptAddScoreBinding 

CREATE PROCEDURE DBO.UspRptAddScoreBinding
	@ReportId INT,
	@ScoreId INT  
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	INSERT INTO DBO.TR_ReportScoreMapped
	(ReportId, ScoreId)
	VALUES(@ReportId, @ScoreId)

	SELECT 1 AS RetValue, 'Successfully Inserted....' AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
