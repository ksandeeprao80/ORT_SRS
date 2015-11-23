IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptRenameCrossTab]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptRenameCrossTab

GO

-- EXEC UspRptRenameCrossTab 451,'MALEOR27-Love it',0,'MALEOR27-Just OK' 
-- EXEC UspRptRenameCrossTab 447,'Female-Tired off',5,'JDTESTrepeat' 

CREATE PROCEDURE DBO.UspRptRenameCrossTab
	@ReportId INT,
	@MTBText NVARCHAR(100),
	@QuestionNo INT,
	@NewName NVARCHAR(150)
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  

	BEGIN TRAN 
	
	SET @MTBText = REPLACE(@MTBText,'$','''')
	
	DECLARE @MTBOptionName NVARCHAR(150)
	DECLARE @OptionDisplayText NVARCHAR(150)
	
	DECLARE @RowId INT
	SET @RowId = 0

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_TrendCrossTabs WHERE ReportId = @ReportId 
		AND LTRIM(RTRIM(OptionDisplayText)) = LTRIM(RTRIM(@NewName))
	)
	BEGIN
		SELECT 0 AS RetValue, 'Crosstab Column with same name already exists.' AS Remark
	END
	ELSE
	BEGIN
		IF ISNULL(@QuestionNo,0) = 0
		BEGIN
			SELECT @MTBOptionName = MTBOptionName, @OptionDisplayText = OptionDisplayText
			FROM DBO.TR_TrendCrossTabs TTCT
			LEFT JOIN DBO.TR_SurveyQuestions TSQ
				ON TTCT.BaseQuestionId = TSQ.QuestionId
			WHERE TTCT.ReportId = @ReportId
				AND LTRIM(RTRIM(REPLACE(MTBOptionName,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBText, ASCII(''''),'')))
		
			UPDATE TTCT 
			SET TTCT.OptionDisplayText = @NewName
			FROM DBO.TR_TrendCrossTabs TTCT
			LEFT JOIN DBO.TR_SurveyQuestions TSQ
				ON TTCT.BaseQuestionId = TSQ.QuestionId
			WHERE TTCT.ReportId = @ReportId
				AND LTRIM(RTRIM(REPLACE(MTBOptionName,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBText, ASCII(''''),'')))

			SET @RowId = @@ROWCOUNT	
		END
		ELSE
		BEGIN
			SELECT @MTBOptionName = MTBOptionName, @OptionDisplayText = OptionDisplayText
			FROM DBO.TR_TrendCrossTabs TTCT
			LEFT JOIN DBO.TR_SurveyQuestions TSQ
				ON TTCT.BaseQuestionId = TSQ.QuestionId
			WHERE TTCT.ReportId = @ReportId
				AND LTRIM(RTRIM(REPLACE(MTBOptionName,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBText, ASCII(''''),'')))
				AND TSQ.QuestionNo = @QuestionNo
			
			UPDATE TTCT 
			SET TTCT.OptionDisplayText = @NewName
			FROM DBO.TR_TrendCrossTabs TTCT
			LEFT JOIN DBO.TR_SurveyQuestions TSQ
				ON TTCT.BaseQuestionId = TSQ.QuestionId
			WHERE TTCT.ReportId = @ReportId
				AND LTRIM(RTRIM(REPLACE(MTBOptionName,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBText, ASCII(''''),'')))
				AND TSQ.QuestionNo = @QuestionNo

			SET @RowId = @@ROWCOUNT	
		END

		IF @RowId >=1
		BEGIN
			UPDATE DBO.TR_SongTrendReportColumn
			SET ColumnText = @NewName
			WHERE ReportId = @ReportId 
			AND LTRIM(RTRIM(REPLACE(ColumnText,ASCII(''''),''))) = LTRIM(RTRIM(REPLACE(@MTBText, ASCII(''''),'')))
			
			UPDATE DBO.TR_SongTrendReportColumn
			SET ColumnText = @NewName
			WHERE ReportId = @ReportId 
			AND LTRIM(RTRIM(ColumnText)) = LTRIM(RTRIM(ISNULL(@OptionDisplayText,@MTBOptionName)))
		END

		SELECT CASE WHEN @RowId = 0 THEN 0 ELSE 1 END AS RetValue,
		CASE WHEN @RowId = 0 THEN 'Update Failed' ELSE 'Successfully Updated' END AS Remark 
	END	

	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 




 

 