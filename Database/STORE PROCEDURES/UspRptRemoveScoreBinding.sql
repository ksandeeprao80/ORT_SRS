IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptRemoveScoreBinding]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptRemoveScoreBinding

GO  
  
--EXEC DBO.UspRptRemoveScoreBinding 26, NULL

CREATE PROCEDURE DBO.UspRptRemoveScoreBinding
	@ReportId INT,
	@ScoreId INT  
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DELETE TTCT
	FROM DBO.TR_TrendCrossTabs TTCT
	INNER JOIN 
	(
		SELECT TMA.Answer AS MTBText, TRSM.ReportId
		FROM DBO.TR_ReportScoreMapped TRSM
		INNER JOIN DBO.TR_MediaAnswers TMA
		ON TRSM.ScoreId = TMA.AnswerId 
		WHERE TRSM.ReportId = @ReportId AND ScoreId = ISNULL(@ScoreId,ScoreId)
	) TRSM
		ON TTCT.ReportId = TRSM.ReportId AND LTRIM(RTRIM(TTCT.MTBText)) =  LTRIM(RTRIM(TRSM.MTBText)) 	

	DELETE TTRC
	FROM DBO.TR_TrendReportColumns TTRC
	INNER JOIN DBO.TR_ReportScoreMapped TRSM
	ON TTRC.TRId = TRSM.ScoreId 
	WHERE TRSM.ReportId = @ReportId AND ScoreId = ISNULL(@ScoreId,ScoreId)	

	DELETE FROM DBO.TR_ReportScoreMapped WHERE ReportId = @ReportId AND ScoreId = ISNULL(@ScoreId,ScoreId)

	SELECT 1 AS RetValue, 'Successfully Deleted....' AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
