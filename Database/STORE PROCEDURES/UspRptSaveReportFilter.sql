IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptSaveReportFilter]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptSaveReportFilter]
GO
/*
--EXEC UspRptSaveReportFilter @XmlData='<?xml version="1.0" encoding="utf-16"?>
<FilterDataViewModel>
	<FilterName>Gender Filter</FilterName>
	<FilterId></FilterId>
	<SurveyId>1158</SurveyId>
	<QuestionId>11139</QuestionId>
	<Operator>in</Operator>
	<AnswerId>109875</AnswerId>
	<AnswerText></AnswerText>
	<FilterOperator></FilterOperator>
	<ReportType>P</ReportType>
</FilterDataViewModel>'
*/
CREATE PROCEDURE DBO.UspRptSaveReportFilter
	@XmlData NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	DECLARE @input XML = @XmlData 

	CREATE TABLE #ReportFilter
	(
		SurveyId VARCHAR(20), FilterId VARCHAR(20), FilterName VARCHAR(150), QuestionId VARCHAR(20), 
		Operator VARCHAR(30), AnswerId VARCHAR(20), AnswerText VARCHAR(150), FilterOperator VARCHAR(10),
		ReportType VARCHAR(1)
	) 
	INSERT INTO #ReportFilter
	(SurveyId, FilterId, FilterName, QuestionId, Operator, AnswerId, AnswerText, FilterOperator, ReportType) 
	SELECT
		Parent.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Parent.Elm.value('(FilterId)[1]','VARCHAR(20)') AS FilterId,
		Parent.Elm.value('(FilterName)[1]','VARCHAR(150)') AS FilterName,
		Parent.Elm.value('(QuestionId)[1]','VARCHAR(20)') AS QuestionId,
		Parent.Elm.value('(Operator)[1]','VARCHAR(30)') AS Operator,
		Parent.Elm.value('(AnswerId)[1]','VARCHAR(20)') AS AnswerId,
		Parent.Elm.value('(AnswerText)[1]','VARCHAR(30)') AS AnswerText,
		Parent.Elm.value('(FilterOperator)[1]','VARCHAR(10)') AS FilterOperator,
		Parent.Elm.value('(ReportType)[1]','VARCHAR(1)') AS ReportType
	FROM @input.nodes('/FilterDataViewModel') AS Parent(Elm)
	
	BEGIN TRAN

	IF EXISTS(SELECT 1 FROM #ReportFilter WHERE ISNULL(FilterId,'')<>'')
	BEGIN
		DELETE TRF 
		FROM DBO.TR_ReportFilter TRF 
		INNER JOIN #ReportFilter RF 
			ON CONVERT(VARCHAR(10),TRF.FilterId) = LTRIM(RTRIM(RF.FilterId)) 
		
		DECLARE @RowId INT
		SET @RowId = 0
		
		INSERT INTO DBO.TR_ReportFilter
		(FilterId, QuestionId, Operator, AnswerId, AnswerText, FilterOperator)
		SELECT 
			RF.FilterId, RF.QuestionId, RF.Operator, RF.AnswerId, AnswerText, FilterOperator
		FROM #ReportFilter RF
		
		SET @RowId = @@ROWCOUNT

		SELECT CASE WHEN @RowId = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN @RowId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, FilterId 
		FROM DBO.#ReportFilter 
	END
	ELSE
	BEGIN
		DECLARE @FilterId INT
		SET @FilterId = 0

		INSERT INTO DBO.MS_ReportFilter
		(FilterName, SurveyId, ReportType)
		SELECT FilterName, SurveyId, ISNULL(ReportType,'P') FROM #ReportFilter

		SET @FilterId = @@IDENTITY
		
		INSERT INTO DBO.TR_ReportFilter
		(FilterId, QuestionId, Operator, AnswerId, AnswerText, FilterOperator)
		SELECT 
			@FilterId, QuestionId, Operator, AnswerId, AnswerText, FilterOperator
		FROM #ReportFilter 
		
		SELECT CASE WHEN @FilterId = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN @FilterId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
			@FilterId AS FilterId
	END
		
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark, 0 AS RewardId
END CATCH 

SET NOCOUNT OFF
END