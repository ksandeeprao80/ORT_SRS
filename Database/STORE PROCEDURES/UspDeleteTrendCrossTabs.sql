IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteTrendCrossTabs]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteTrendCrossTabs]

GO

--EXEC UspDeleteTrendCrossTabs 
-- exec UspDeleteTrendCrossTabs @ReportId=N'185',@MTBOptionName=N'31 to 45:I don$t know this song'
CREATE PROCEDURE DBO.UspDeleteTrendCrossTabs
	@ReportId INT,
	@MTBOptionName NVARCHAR(150),
	@QuestionNo INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	SET @MTBOptionName = REPLACE(@MTBOptionName,':','-')
	SET @MTBOptionName = REPLACE(@MTBOptionName,'$','''')
	--SET @MTBOptionName = REPLACE(@MTBOptionName, ASCII(''''),'')
	
	DECLARE @RowId INT
	SET @RowId = 0
	
	DECLARE @ColumnText NVARCHAR(150)

	IF ISNULL(@QuestionNo,0) = 0
	BEGIN
		SELECT @ColumnText = ISNULL(OptionDisplayText,MTBOptionName) FROM TR_TrendCrossTabs 
		WHERE ReportId = @ReportId 
			AND LTRIM(RTRIM(REPLACE(MTBOptionName,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBOptionName, ASCII(''''),''))) 
	
		DELETE 
		FROM DBO.TR_TrendCrossTabs 
		WHERE ReportId = @ReportId 
			AND LTRIM(RTRIM(REPLACE(MTBOptionName,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBOptionName, ASCII(''''),'')))
	
		SET @RowId = @@ROWCOUNT
		
		IF @RowId >=1
		BEGIN
			DELETE FROM	DBO.TR_SongTrendReportColumn 
			WHERE ReportId = @ReportId AND LTRIM(RTRIM(ColumnText)) = LTRIM(RTRIM(@ColumnText))	
		END
	END
	ELSE
	BEGIN
		SELECT @ColumnText = ISNULL(TTCT.OptionDisplayText,TTCT.MTBOptionName)
		FROM DBO.TR_TrendCrossTabs TTCT
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TTCT.BaseQuestionId = TSQ.QuestionId
		WHERE TTCT.ReportId = @ReportId  
			AND LTRIM(RTRIM(REPLACE(MTBOptionName,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBOptionName, ASCII(''''),'')))
			AND TSQ.QuestionNo = @QuestionNo
			
		DELETE TTCT 
		FROM DBO.TR_TrendCrossTabs TTCT
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TTCT.BaseQuestionId = TSQ.QuestionId
		WHERE TTCT.ReportId = @ReportId  
			AND LTRIM(RTRIM(REPLACE(MTBOptionName,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBOptionName, ASCII(''''),'')))
			AND TSQ.QuestionNo = @QuestionNo
		
		SET @RowId = @@ROWCOUNT	
		
		IF @RowId >=1
		BEGIN
			DELETE FROM	DBO.TR_SongTrendReportColumn 
			WHERE ReportId = @ReportId AND LTRIM(RTRIM(ColumnText)) = LTRIM(RTRIM(@ColumnText))	
		END
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

