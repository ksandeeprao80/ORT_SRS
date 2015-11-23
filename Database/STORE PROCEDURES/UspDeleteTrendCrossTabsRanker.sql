IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteTrendCrossTabsRanker]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspDeleteTrendCrossTabsRanker

GO
-- exec UspDeleteTrendCrossTabsRanker @ReportId=N'185',@MTBOptionName=N'31 to 45:I don$t know this song'

CREATE PROCEDURE DBO.UspDeleteTrendCrossTabsRanker
	@ReportId INT,
	@MTBOptionName NVARCHAR(150),
	@QuestionNo INT,
	@SurveyId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	SET @MTBOptionName = REPLACE(@MTBOptionName,':','-')
	SET @MTBOptionName = REPLACE(@MTBOptionName,'$','''')
	
	DECLARE @RowId INT
	SET @RowId = 0
	
	IF ISNULL(@QuestionNo,0) = 0
	BEGIN
		DELETE FROM DBO.TR_TrendCrossTabsRanker WHERE ReportId = @ReportId AND BaseSurveyId = @SurveyId
		AND LTRIM(RTRIM(REPLACE( ISNULL(OptionDisplayText,MTBOptionName),ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBOptionName, ASCII(''''),'')))
	
		SET @RowId = @@ROWCOUNT
	END
	ELSE
	BEGIN
		DELETE TTCT 
		FROM DBO.TR_TrendCrossTabsRanker TTCT
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON TTCT.BaseQuestionId = TSQ.QuestionId
		WHERE TTCT.ReportId = @ReportId AND BaseSurveyId = @SurveyId 
			AND LTRIM(RTRIM(REPLACE(ISNULL(TTCT.OptionDisplayText,TTCT.MTBOptionName),ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBOptionName, ASCII(''''),'')))
			AND TSQ.QuestionNo = @QuestionNo
		
		SET @RowId = @@ROWCOUNT	
	END 
		
	SELECT CASE WHEN @RowId = 0 THEN 0 ELSE 1 END AS RetValue,
		CASE WHEN @RowId = 0 THEN 'Delete Failed' ELSE 'Successfully Deleted' END AS Remark 
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END


