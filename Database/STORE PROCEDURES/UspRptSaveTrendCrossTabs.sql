IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptSaveTrendCrossTabs]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptSaveTrendCrossTabs]
GO
/*
-- EXEC UspRptSaveTrendCrossTabs 
*/
CREATE PROCEDURE DBO.UspRptSaveTrendCrossTabs
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

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_TrendCrossTabs WHERE ReportId = @ReportId 
		AND LTRIM(RTRIM(ISNULL(OptionDisplayText,MTBOptionName))) = LTRIM(RTRIM(@MTBOptionName))
	) 
	BEGIN
		SELECT 0 AS RetValue, 'Crosstab Column with same name already exists.' AS Remark
	END
	ELSE
	BEGIN
	
		DECLARE @IsCalculated INT
		SET @IsCalculated = 0
		
		SELECT @IsCalculated = COUNT(1) FROM DBO.TR_MediaAnswers WHERE LTRIM(RTRIM(AnswerText)) = LTRIM(RTRIM(@MTBText))
	
		INSERT INTO DBO.TR_TrendCrossTabs
		(
			ReportId, BaseSurveyId, MTBId, MTBText, MTBOptionName, StatusId, CreatedBy, CreatedOn, 
			BaseOptionName, IsCalculated, TrendType, MtbOptionId, BaseQuestionId
		)
		SELECT 
			@ReportId, @BaseSurveyId, @MTBId, @MTBText, @MTBOptionName, 1 AS StatusId, @UserId, GETDATE(), 
			@BaseOptionName, ISNULL(@IsCalculated,0), @TrendType, @MtbOptionId, @BaseQuestionId
			
		SET @RowId = @@IDENTITY
		
		IF @RowId >= 1
		BEGIN
			INSERT INTO DBO.TR_SongTrendReportColumn
			(ReportId, ColumnText, Hidden)
			SELECT 
				@ReportId, ISNULL(OptionDisplayText,MTBOptionName), 'False' 
			FROM DBO.TR_TrendCrossTabs
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

