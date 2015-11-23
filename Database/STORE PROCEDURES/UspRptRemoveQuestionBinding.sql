IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptRemoveQuestionBinding]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptRemoveQuestionBinding

GO  
  
--EXEC DBO.UspRptRemoveQuestionBinding 26, NULL

CREATE PROCEDURE DBO.UspRptRemoveQuestionBinding
	@ReportId INT,
	@QuestionId INT  
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DELETE FROM DBO.TR_ReportQuestionMapped WHERE ReportId = @ReportId AND QuestionId = ISNULL(@QuestionId,QuestionId)
	
	DELETE TTOM 
	FROM DBO.TR_TrendOptionMapping TTOM 
	INNER JOIN DBO.TR_Trends TT ON TTOM.TrendId = TT.TrendId 
	WHERE TT.ReportId = @ReportId AND BaseQuestionId = ISNULL(@QuestionId,BaseQuestionId)

	DELETE TTPF
	FROM DBO.TR_TrendPerceptFilter TTPF
	INNER JOIN DBO.MS_TrendPerceptFilter MTPF ON TTPF.FilterId = MTPF.FilterId
	WHERE ReportId = @ReportId AND QuestionId = ISNULL(@QuestionId,QuestionId)
	
	DELETE FROM DBO.TR_TrendCrossTabs WHERE ReportId = ReportId AND BaseQuestionId = ISNULL(@QuestionId,BaseQuestionId) 	

	SELECT 1 AS RetValue, 'Successfully Deleted....' AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
