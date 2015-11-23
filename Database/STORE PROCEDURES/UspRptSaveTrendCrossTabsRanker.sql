IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptSaveTrendCrossTabsRanker]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptSaveTrendCrossTabsRanker]
GO
/*
-- EXEC UspRptSaveTrendCrossTabsRanker 
*/
CREATE PROCEDURE DBO.UspRptSaveTrendCrossTabsRanker
	@ReportId INT,
	@BaseSurveyId INT,
	@MTBId INT,
	@MTBText NVARCHAR(100),
	@MTBOptionName NVARCHAR(150),
	@BaseOptionName NVARCHAR(150),
	@UserId INT,
	@TrendType VARCHAR(10),
	@MtbOptionId INT,
	@BaseQuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @RowId INT
	SET @RowId = 0
	
	DECLARE @BaseSurveyName VARCHAR(100)
	SELECT @BaseSurveyName = SurveyName FROM DBO.TR_Survey WHERE SurveyId = @BaseSurveyId
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_TrendCrossTabsRanker WHERE ReportId = @ReportId 
		AND LTRIM(RTRIM(MTBOptionName)) = LTRIM(RTRIM(@MTBOptionName))
		AND OptionDisplayText = @BaseSurveyName 
	) 
	BEGIN
		SELECT 0 AS RetValue, 'Crosstab Column with same name already exists.' AS Remark
	END
	ELSE
	BEGIN
		DECLARE @IsCalculated INT
		SET @IsCalculated = 0
		
		SELECT @IsCalculated = COUNT(1) FROM DBO.TR_MediaAnswers WHERE LTRIM(RTRIM(AnswerText)) = LTRIM(RTRIM(@MTBText))
	
		INSERT INTO DBO.TR_TrendCrossTabsRanker
		(
			ReportId, BaseSurveyId, MTBId, MTBText, MTBOptionName, StatusId, CreatedBy, CreatedOn, 
			BaseOptionName, IsCalculated, TrendType, MtbOptionId, BaseQuestionId, OptionDisplayText 
		)
		SELECT 
			@ReportId, @BaseSurveyId, @MTBId, @MTBText, @MTBOptionName, 1 AS StatusId, @UserId, GETDATE(), 
			@BaseOptionName, ISNULL(@IsCalculated,0), @TrendType, @MtbOptionId, @BaseQuestionId,
			@BaseSurveyName + '-' + @MTBOptionName
			
		SET @RowId = @@IDENTITY
		
		IF @RowId >= 1
		BEGIN
			--SELECT TTCT1.Row, TTCT.* -- in case of Duplicate entry OptionDisplayText updated with next row
			UPDATE TTCT
			SET TTCT.OptionDisplayText = TTCT.OptionDisplayText+'-'+CONVERT(VARCHAR(12),Row-1)
			FROM DBO.TR_TrendCrossTabsRanker TTCT
			INNER JOIN 
			(
				SELECT TCTId, ReportId, MTBText, BaseOptionName, OptionDisplayText, BaseSurveyId,
					ROW_NUMBER() OVER (PARTITION BY ReportId, MTBText, BaseOptionName, OptionDisplayText,BaseSurveyId ORDER BY ReportId) AS Row
				FROM DBO.TR_TrendCrossTabsRanker
				WHERE Reportid = @ReportId  
			) TTCT1 
				ON TTCT.ReportId = TTCT1.ReportId
				AND TTCT.TCTId = TTCT1.TCTId
				AND TTCT.MTBText = TTCT1.MTBText  
				AND TTCT.BaseOptionName = TTCT1.BaseOptionName
				AND TTCT.OptionDisplayText = TTCT1.OptionDisplayText
				AND TTCT.BaseSurveyId = TTCT1.BaseSurveyId
			WHERE TTCT1.Row > 1

			INSERT INTO DBO.TR_SongTrendReportColumn
			(ReportId, ColumnText, Hidden, Tab)
			SELECT 
				@ReportId, ISNULL(OptionDisplayText,MTBOptionName), 'False', 'TrendRanker' 
			FROM DBO.TR_TrendCrossTabsRanker
			WHERE TCTId = @RowId
		END	
		
		SELECT CASE WHEN @RowId = 0 THEN 0 ELSE 1 END AS RetValue, 
			   CASE WHEN @RowId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
	END
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark, 0 AS RewardId
END CATCH 

SET NOCOUNT OFF
END