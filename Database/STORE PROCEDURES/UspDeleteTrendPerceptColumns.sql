IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteTrendPerceptColumns]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteTrendPerceptColumns]
GO
 
/*
EXEC UspDeleteTrendPerceptColumns  
*/
CREATE PROCEDURE DBO.UspDeleteTrendPerceptColumns
	@ReportId INT,
	@ColumnId INT --FilterId
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DELETE TTPF FROM TR_TrendPerceptFilter TTPF
	INNER JOIN MS_TrendPerceptFilter MTPF
		ON TTPF.FilterId = MTPF.FilterId
	WHERE MTPF.ReportId = @ReportId
		AND MTPF.FilterId = @ColumnId	
		
	DELETE TTCT FROM DBO.TR_TrendCrossTabs TTCT
	INNER JOIN MS_TrendPerceptFilter MTPF
		ON TTCT.BaseSurveyId = MTPF.SurveyId
		AND LTRIM(RTRIM(TTCT.BaseOptionName)) = LTRIM(RTRIM(MTPF.FilterName))
	WHERE MTPF.ReportId = @ReportId	
		
	DELETE FROM MS_TrendPerceptFilter WHERE ReportId = @ReportId AND FilterId = @ColumnId		

	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

