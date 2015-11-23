IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptSaveTrendReport]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptSaveTrendReport

GO  
/*  
EXEC UspRptSaveTrendReport '<?xml version="1.0" encoding="utf-16"?>
<ArrayOfSurveySelection>
  <SurveySelection>
    <SurveyId>1210</SurveyId>
    <SurveyName>Wave1</SurveyName>
    <ReportId>102</ReportId>
    <IsBaseSurvey>true</IsBaseSurvey>
    <IsCompareSurvey>false</IsCompareSurvey>
    <SortOrder></SortOrder>
    <Options>
      <Option>
        <SurveyId>1210</SurveyId>
        <Text>Female</Text>
        <BaseSurveyId>1210</BaseSurveyId>
        <BaseText>Female</BaseText>
        <BaseQuestionId></BaseQuestionId>
        <OptionQuestionId></OptionQuestionId>
        <OptionDisplayText></OptionDisplayText>
        <MtbOption>
          <Id>0</Id>
          <Text />
        </MtbOption>
        <MtbOptionName />
      </Option>
      <Option>
        <SurveyId>1210</SurveyId>
        <Text>16 to 21</Text>
        <BaseSurveyId>1210</BaseSurveyId>
        <BaseText>16 to 21</BaseText>
        <BaseQuestionId></BaseQuestionId>
        <OptionQuestionId></OptionQuestionId>
        <OptionDisplayText></OptionDisplayText>
        <MtbOption>
          <Id>0</Id>
          <Text />
        </MtbOption>
        <MtbOptionName />
      </Option>
      <Option>
        <SurveyId>1210</SurveyId>
        <Text>22 to 30</Text>
        <BaseSurveyId>1210</BaseSurveyId>
        <BaseText>22 to 30</BaseText>
        <BaseQuestionId></BaseQuestionId>
        <OptionQuestionId></OptionQuestionId>
        <OptionDisplayText></OptionDisplayText>
        <MtbOption>
          <Id>0</Id>
          <Text />
        </MtbOption>
        <MtbOptionName />
      </Option>
     </Options>
     <SurveyQuestions>
		<Question>
			<QuestionId>17573</QuestionId>
			<IsSelectedForTrendReport>true</IsSelectedForTrendReport>
		</Question>	
     </SurveyQuestions>
	<MappedScores>
		<Answer>
			<AnswerId>2</AnswerId>
		</Answer>
		<Answer>
			<AnswerId>1</AnswerId>
		</Answer>
		<Answer>
			<AnswerId>4</AnswerId>
		</Answer>
	</MappedScores>
    <TotalResponse>0</TotalResponse>
  </SurveySelection>
</ArrayOfSurveySelection>', @UserId = 5
*/
CREATE PROCEDURE DBO.UspRptSaveTrendReport
	@XmlData AS NTEXT,
	@UserId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY
	BEGIN TRAN
	
	DECLARE @input XML = @XmlData

	CREATE TABLE #TrendReport
	(
		BaseSurveyId VARCHAR(20), SurveyName NVARCHAR(100), ReportId VARCHAR(20), IsBaseSurvey VARCHAR(20), 
		IsCompareSurvey VARCHAR(20), OptionSurveyId VARCHAR(20), OptionText NVARCHAR(100),
		OptionBaseSurveyId VARCHAR(20),  OptionBaseText NVARCHAR(100), MTBId VARCHAR(20),  
		MTBText NVARCHAR(100), MTBOptionName NVARCHAR(100), TrendType VARCHAR(10), SortOrder VARCHAR(12),
		BaseQuestionId VARCHAR(12), OptionQuestionId	VARCHAR(12), OptionDisplayText NVARCHAR(150)
	)
	INSERT INTO #TrendReport
	(
		BaseSurveyId, SurveyName, ReportId, IsBaseSurvey, IsCompareSurvey, OptionSurveyId, OptionText,
		OptionBaseSurveyId, OptionBaseText, MTBId, MTBText, MTBOptionName, TrendType, SortOrder,
		BaseQuestionId, OptionQuestionId, OptionDisplayText 
	)
	SELECT
		Child.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS BaseSurveyId, 
		Child.Elm.value('(SurveyName)[1]','NVARCHAR(100)') AS SurveyName,
		Child.Elm.value('(ReportId)[1]','VARCHAR(20)') AS ReportId,
		Child.Elm.value('(IsBaseSurvey)[1]','VARCHAR(20)') AS IsBaseSurvey,
		Child.Elm.value('(IsCompareSurvey)[1]','VARCHAR(20)') AS IsCompareSurvey,
		Child2.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS	OptionSurveyId,
		Child2.Elm.value('(Text)[1]','NVARCHAR(100)') AS OptionText,-- OptionName
		Child2.Elm.value('(BaseSurveyId)[1]','VARCHAR(20)') AS OptionBaseSurveyId,
		Child2.Elm.value('(BaseText)[1]','NVARCHAR(100)') AS OptionBaseText,-- BaseOptionName
		ISNULL(Child4.Elm.value('(Id)[1]','VARCHAR(20)'),'') AS MTBId,
		ISNULL(Child4.Elm.value('(Text)[1]','NVARCHAR(100)'),'') AS MTBText,
		ISNULL(Child4.Elm.value('(MtbOptionName)[1]','NVARCHAR(100)'),'') AS MTBOptionName,
		ISNULL(Child4.Elm.value('(TrendType)[1]','VARCHAR(10)'),'') AS TrendType,
		Child.Elm.value('(SortOrder)[1]','VARCHAR(20)') AS SortOrder,
		Child2.Elm.value('(BaseQuestionId)[1]','VARCHAR(12)') AS BaseQuestionId,
		Child2.Elm.value('(OptionQuestionId)[1]','VARCHAR(12)') AS OptionQuestionId,
		Child2.Elm.value('(OptionDisplayText)[1]','NVARCHAR(150)') AS OptionDisplayText
	FROM @input.nodes('/ArrayOfSurveySelection') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SurveySelection') AS Child(Elm)
	OUTER APPLY
	(
		Child.Elm.nodes('Options') AS Child1(Elm)
		CROSS APPLY
		Child1.Elm.nodes('Option') AS Child2(Elm)
	)
	OUTER APPLY
	(
		Child2.Elm.nodes('MtbOptions') AS Child3(Elm)
		CROSS APPLY
		Child3.Elm.nodes('MtbOption') AS Child4(Elm)
	)	
		
	CREATE TABLE #TrendReportWithoutMTB
	(
		BaseSurveyId VARCHAR(20), SurveyName NVARCHAR(100), ReportId VARCHAR(20), IsBaseSurvey VARCHAR(20), 
		IsCompareSurvey VARCHAR(20), OptionSurveyId VARCHAR(20), OptionText NVARCHAR(100),
		OptionBaseSurveyId VARCHAR(20),  OptionBaseText NVARCHAR(100), SortOrder VARCHAR(12)
	)
	INSERT INTO #TrendReportWithoutMTB
	(
		BaseSurveyId, SurveyName, ReportId, IsBaseSurvey, IsCompareSurvey, OptionSurveyId, OptionText,
		OptionBaseSurveyId, OptionBaseText, SortOrder
	)
	SELECT
		Child.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS BaseSurveyId, 
		Child.Elm.value('(SurveyName)[1]','NVARCHAR(100)') AS SurveyName,
		Child.Elm.value('(ReportId)[1]','VARCHAR(20)') AS ReportId,
		Child.Elm.value('(IsBaseSurvey)[1]','VARCHAR(20)') AS IsBaseSurvey,
		Child.Elm.value('(IsCompareSurvey)[1]','VARCHAR(20)') AS IsCompareSurvey,
		Child2.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS	OptionSurveyId,
		Child2.Elm.value('(Text)[1]','NVARCHAR(100)') AS OptionText,-- OptionName
		Child2.Elm.value('(BaseSurveyId)[1]','VARCHAR(20)') AS OptionBaseSurveyId,
		Child2.Elm.value('(BaseText)[1]','NVARCHAR(100)') AS OptionBaseText,
		Child.Elm.value('(SortOrder)[1]','VARCHAR(20)') AS SortOrder
	FROM @input.nodes('/ArrayOfSurveySelection') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SurveySelection') AS Child(Elm)
	OUTER APPLY
		(Child.Elm.nodes('Options') AS Child1(Elm)
	CROSS APPLY
		Child1.Elm.nodes('Option') AS Child2(Elm))
		
	CREATE TABLE #TR_ReportQuestionMapped	
	(ReportId INT, QuestionId INT)
	INSERT INTO #TR_ReportQuestionMapped
	(ReportId, QuestionId)
	SELECT
		Child.Elm.value('(ReportId)[1]','VARCHAR(20)') AS ReportId,
		Child2.Elm.value('(QuestionId)[1]','VARCHAR(20)') AS QuestionId
	FROM @input.nodes('/ArrayOfSurveySelection') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SurveySelection') AS Child(Elm)
	OUTER APPLY
		(Child.Elm.nodes('SurveyQuestions') AS Child1(Elm)
	CROSS APPLY
		Child1.Elm.nodes('Question') AS Child2(Elm))
	WHERE Child2.Elm.value('(IsSelectedForTrendReport)[1]','VARCHAR(20)') = 'True'	

	CREATE TABLE #TR_ReportScoreMapped	
	(ReportId INT, ScoreId INT)
	INSERT INTO #TR_ReportScoreMapped
	(ReportId, ScoreId)
	SELECT
		Child.Elm.value('(ReportId)[1]','VARCHAR(20)') AS ReportId,
		Child2.Elm.value('(AnswerId)[1]','VARCHAR(20)') AS ScoreId
	FROM @input.nodes('/ArrayOfSurveySelection') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SurveySelection') AS Child(Elm)
	OUTER APPLY
		(Child.Elm.nodes('MappedScores') AS Child1(Elm)
	CROSS APPLY
		Child1.Elm.nodes('Answer') AS Child2(Elm))

	DELETE TRQM
	FROM dbo.TR_ReportQuestionMapped TRQM
	INNER JOIN #TR_ReportQuestionMapped TRQM1
		ON TRQM.ReportId = TRQM1.ReportId
	
	INSERT INTO dbo.TR_ReportQuestionMapped
	(ReportId, QuestionId)
	SELECT ReportId, QuestionId FROM #TR_ReportQuestionMapped	
		
	DELETE TRWM
	FROM #TrendReportWithoutMTB TRWM
	INNER JOIN #TrendReport TR
		ON TRWM.BaseSurveyId = TR.BaseSurveyId AND TRWM.SurveyName = TR.SurveyName
		AND TRWM.ReportId = TR.ReportId AND TRWM.IsBaseSurvey = TR.IsBaseSurvey
		AND TRWM.IsCompareSurvey = TR.IsCompareSurvey AND TRWM.OptionSurveyId = TR.OptionSurveyId
		AND TRWM.OptionText = TR.OptionText AND TRWM.OptionBaseSurveyId = TR.OptionBaseSurveyId
		AND TRWM.OptionBaseText = TR.OptionBaseText

	INSERT INTO #TrendReport
	(
		BaseSurveyId, SurveyName, ReportId, IsBaseSurvey, IsCompareSurvey, OptionSurveyId, OptionText,
		OptionBaseSurveyId, OptionBaseText, MTBId, MTBText, MTBOptionName, TrendType, SortOrder 
	)
	SELECT 
		BaseSurveyId, SurveyName, ReportId, IsBaseSurvey, IsCompareSurvey, OptionSurveyId, OptionText,
		OptionBaseSurveyId, OptionBaseText, '0' AS MTBId,'' AS MTBText, '' AS MTBOptionName, 'False' AS TrendType, 
		SortOrder
	FROM #TrendReportWithoutMTB

	---Start If report id is exist its deleted and data added with new entry as per xml-------------------------
	IF EXISTS(SELECT 1 FROM DBO.TR_Trends TT INNER JOIN #TrendReport TR ON TT.ReportId = CONVERT(INT,TR.ReportId))
	BEGIN
		DELETE TSTRC 
		FROM DBO.TR_SongTrendReportColumn TSTRC INNER JOIN #TrendReport TR ON TSTRC.ReportId = CONVERT(INT,TR.ReportId)

		DELETE TTCT 
		FROM dbo.TR_TrendCrossTabs TTCT INNER JOIN #TrendReport TR ON TTCT.ReportId = CONVERT(INT,TR.ReportId)
		
		DELETE TTCT 
		FROM dbo.TR_TrendCrossTabsRanker TTCT INNER JOIN #TrendReport TR ON TTCT.ReportId = CONVERT(INT,TR.ReportId)
		 
		DELETE TTRC 
		FROM dbo.TR_TrendReportColumns TTRC INNER JOIN #TrendReport TR ON TTRC.ReportId = CONVERT(INT,TR.ReportId)	
		
		DELETE TTOM FROM DBO.TR_Trends TT 
		INNER JOIN #TrendReport TR ON TT.ReportId = CONVERT(INT,TR.ReportId)
		INNER JOIN DBO.TR_TrendOptionMapping TTOM ON TTOM.TrendId = TT.TrendId
		
		DELETE TT FROM DBO.TR_Trends TT INNER JOIN #TrendReport TR ON TT.ReportId = CONVERT(INT,TR.ReportId)
	END
	---End If report id is exist its deleted and data added with new entry as per xml-------------------------

	DECLARE @BaseSurveyId INT
	DECLARE @ReportId INT
	DECLARE @BaseSurveyName NVARCHAR(50)
	DECLARE @CurrentDate DATETIME
	SET @CurrentDate = GETDATE()

	CREATE TABLE #TrueBaseSurvey
	(BaseSurveyId VARCHAR(20), ReportId VARCHAR(20), BaseSurveyName NVARCHAR(50))
	INSERT INTO #TrueBaseSurvey
	(BaseSurveyId, ReportId, BaseSurveyName)
	SELECT 
		DISTINCT BaseSurveyId, ReportId, SurveyName 
	FROM #TrendReport WHERE IsCompareSurvey = 'False' AND IsBaseSurvey = 'True'
	
	SELECT 
		@BaseSurveyId = BaseSurveyId, @ReportId = ReportId, @BaseSurveyName = BaseSurveyName 
	FROM #TrueBaseSurvey 

	DECLARE @Count INT
	SET @Count = 0
	
	SELECT @Count = COUNT(1) FROM #TrendReport WHERE IsCompareSurvey = 'True' AND IsBaseSurvey = 'False'
	IF @Count = 0
	BEGIN
		INSERT INTO DBO.TR_Trends
		(
			ReportId, SurveyId, BaseSurveyId, StatusId, CreatedBy, CreatedOn, SurveyName, 
			BaseSurveyName, IsBaseSurvey, IsCompareSurvey, SortOrder
		)
		SELECT 
			DISTINCT @ReportId AS ReportId, NULL AS SurveyId, @BaseSurveyId AS BaseSurveyId, 1 AS StatusId, 
			@UserId AS CreatedBy, @CurrentDate, TR.SurveyName, @BaseSurveyName AS BaseSurveyName, 
			TR.IsBaseSurvey, TR.IsCompareSurvey, TR.SortOrder
		FROM #TrendReport TR
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TR_Trends
		(
			ReportId, SurveyId, BaseSurveyId, StatusId, CreatedBy, CreatedOn, SurveyName, 
			BaseSurveyName, IsBaseSurvey, IsCompareSurvey, SortOrder
		)
		SELECT 
			DISTINCT @ReportId AS ReportId, TR.BaseSurveyId AS SurveyId, @BaseSurveyId AS BaseSurveyId, 
			1 AS StatusId, @UserId AS CreatedBy, @CurrentDate, TR.SurveyName, @BaseSurveyName AS BaseSurveyName, 
			TR.IsBaseSurvey, TR.IsCompareSurvey, TR.SortOrder
		FROM #TrendReport TR
		WHERE TR.IsCompareSurvey = 'True' AND TR.IsBaseSurvey = 'False' 
	END

	-- Just a reminder that we need to have standard scores for the following (so the User would not need to create these)
	IF NOT EXISTS(SELECT 1 FROM DBO.TR_TrendReportColumns WHERE ReportId = @ReportId AND UPPER(LTRIM(RTRIM(ColumnName))) = 'POSITIVE')
	BEGIN
		INSERT INTO DBO.TR_TrendReportColumns
		(ReportId, ColumnName, Expression, ReportStatus, TrendType)
		SELECT @ReportId, 'Positive', '([Love it]+[Like it])', 1, 'True'
	END
	
	IF NOT EXISTS(SELECT 1 FROM DBO.TR_TrendReportColumns WHERE ReportId = @ReportId AND UPPER(LTRIM(RTRIM(ColumnName))) = 'NEGATIVE')
	BEGIN 
		INSERT INTO DBO.TR_TrendReportColumns
		(ReportId, ColumnName, Expression, ReportStatus, TrendType)
		SELECT @ReportId, 'Negative', '([Tired of]+[Hate it])', 1, 'False' 
	END 
	
	IF NOT EXISTS(SELECT 1 FROM DBO.TR_TrendReportColumns WHERE ReportId = @ReportId AND UPPER(LTRIM(RTRIM(ColumnName))) = 'NET SCORE')
	BEGIN
		INSERT INTO DBO.TR_TrendReportColumns
		(ReportId, ColumnName, Expression, ReportStatus, TrendType)
		SELECT @ReportId, 'Net Score', '([Love it]+[Like it])-([Tired of]+[Hate it])', 1, 'True'
	END
	
	INSERT INTO DBO.TR_SongTrendReportColumn
	(ReportId, ColumnText, Hidden, Tab)
	SELECT 
		TTRC.ReportId, TTRC.ColumnName, 'False', 'TrendOption'
	FROM DBO.TR_TrendReportColumns TTRC
	LEFT JOIN DBO.TR_SongTrendReportColumn TSTRC WITH(NOLOCK)
		ON TTRC.ReportId = TSTRC.ReportId
		AND LTRIM(RTRIM(TTRC.ColumnName)) = LTRIM(RTRIM(TSTRC.ColumnText))
	WHERE TTRC.ReportId = @ReportId AND TSTRC.ColumnText IS NULL
	
	
	INSERT INTO DBO.TR_SongTrendReportColumn
	(ReportId, ColumnText, Hidden, Tab)
	SELECT 
		TTRC.ReportId, TS.SurveyName, 'False' AS Hidden, 'TrendRanker' AS Tab
	FROM DBO.TR_Trends TTRC
	INNER JOIN DBO.TR_Survey TS
		ON TTRC.BaseSurveyId = TS.SurveyId 
	LEFT JOIN DBO.TR_SongTrendReportColumn TSTRC WITH(NOLOCK)
		ON TTRC.ReportId = TSTRC.ReportId
		AND LTRIM(RTRIM(TS.SurveyName)) = LTRIM(RTRIM(TSTRC.ColumnText))
	WHERE TTRC.ReportId = @ReportId AND TSTRC.ColumnText IS NULL
	UNION
	SELECT 
		TTRC.ReportId, TS.SurveyName, 'False' AS Hidden, 'TrendRanker' AS Tab
	FROM DBO.TR_Trends TTRC
	INNER JOIN DBO.TR_Survey TS
		ON TTRC.SurveyId = TS.SurveyId 
	LEFT JOIN DBO.TR_SongTrendReportColumn TSTRC WITH(NOLOCK)
		ON TTRC.ReportId = TSTRC.ReportId
		AND LTRIM(RTRIM(TS.SurveyName)) = LTRIM(RTRIM(TSTRC.ColumnText))
	WHERE TTRC.ReportId = @ReportId AND TSTRC.ColumnText IS NULL
	
	INSERT INTO DBO.TR_TrendOptionMapping
	(
		TrendId, OptionId, OptionName, BaseOptionId, BaseOptionName, StatusId, CreatedBy, 
		CreatedOn, BaseQuestionId, OptionQuestionId
	)
	SELECT 
		DISTINCT TT.TrendId, NULL, TR.OptionText, NULL, TR.OptionBaseText, 1, @UserId AS CreatedBy, 
		@CurrentDate, TR.BaseQuestionId, TR.OptionQuestionId 
	FROM #TrendReport TR
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
		ON TT.ReportId = TR.ReportId
		AND TR.OptionSurveyId = TT.SurveyId
		AND TR.OptionBaseSurveyId = TT.BaseSurveyId
	WHERE ISNULL(TR.OptionBaseText,'unassigned') <> 'unassigned'
		
	INSERT INTO DBO.TR_TrendCrossTabs
	(
		ReportId, BaseSurveyId, BaseOptionId, BaseOptionName, MTBId, MTBText, MTBOptionName, StatusId, 
		CreatedBy, CreatedOn, IsCalculated, TrendType, BaseQuestionId, OptionQuestionId 
	)
	SELECT 
		DISTINCT @ReportId, @BaseSurveyId, NULL, TR.OptionBaseText, TR.MTBId, TR.MTBText, 
		TR.MTBOptionName, 1, @UserId AS CreatedBy, @CurrentDate,
		CASE WHEN TR.MTBText = TMA.AnswerText THEN 0 ELSE 1 END AS IsCalculated, TR.TrendType,
		TR.BaseQuestionId, TR.OptionQuestionId 
	FROM #TrendReport TR
	LEFT OUTER JOIN DBO.TR_MediaAnswers TMA WITH(NOLOCK) 
		ON TR.MTBText = TMA.AnswerText
	WHERE ISNULL(TR.MTBId,0) <> 0
		AND TR.IsBaseSurvey = 'True'
		AND TR.IsCompareSurvey = 'False'	
		
	INSERT INTO DBO.TR_TrendCrossTabsRanker
	(
		ReportId, BaseSurveyId, BaseOptionId, BaseOptionName, MTBId, MTBText, MTBOptionName, StatusId, 
		CreatedBy, CreatedOn, IsCalculated, TrendType, BaseQuestionId, OptionQuestionId, OptionDisplayText 
	)
	SELECT 
		DISTINCT TR.ReportId, TT.BaseSurveyId, NULL, TR.OptionBaseText, TR.MTBId, TR.MTBText, 
		TR.MTBOptionName, 1, @UserId AS CreatedBy, @CurrentDate,
		CASE WHEN TR.MTBText = TMA.AnswerText THEN 0 ELSE 1 END AS IsCalculated, TR.TrendType,
		TR.BaseQuestionId, TR.OptionQuestionId, TT.BaseSurveyName + '-' + TR.MTBOptionName
	FROM #TrendReport TR
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
		ON TR.ReportId = TT.ReportId
		AND TR.ReportId = @ReportId
	LEFT OUTER JOIN DBO.TR_MediaAnswers TMA WITH(NOLOCK) 
		ON TR.MTBText = TMA.AnswerText
	WHERE ISNULL(TR.MTBId,0) <> 0
		AND TR.IsBaseSurvey = 'True'
		AND TR.IsCompareSurvey = 'False'	
		
	INSERT INTO DBO.TR_TrendCrossTabsRanker
	(
		ReportId, BaseSurveyId, BaseOptionId, BaseOptionName, MTBId, MTBText, MTBOptionName, StatusId, 
		CreatedBy, CreatedOn, IsCalculated, TrendType, BaseQuestionId, OptionQuestionId, OptionDisplayText 
	)
	SELECT 
		DISTINCT TR.ReportId, TT.SurveyId, NULL, TR.OptionBaseText, TR.MTBId, TR.MTBText, 
		TR.MTBOptionName, 1, @UserId AS CreatedBy, @CurrentDate,
		CASE WHEN TR.MTBText = TMA.AnswerText THEN 0 ELSE 1 END AS IsCalculated, TR.TrendType,
		TR.BaseQuestionId, TR.OptionQuestionId, TT.SurveyName  + '-' + TR.MTBOptionName
	FROM #TrendReport TR
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
		ON TR.ReportId = TT.ReportId
		AND TR.ReportId = @ReportId
	LEFT OUTER JOIN DBO.TR_MediaAnswers TMA WITH(NOLOCK) 
		ON TR.MTBText = TMA.AnswerText
	WHERE ISNULL(TR.MTBId,0) <> 0
		AND TR.IsBaseSurvey = 'False'
		AND TR.IsCompareSurvey = 'True'
		AND ISNULL(TT.SurveyId,0) <> 0	

	--SELECT TTCT1.Row, TTCT.* -- in case of Duplicate entry OptionDisplayText updated with next row
	UPDATE TTCT
	SET TTCT.OptionDisplayText = TTCT.MTBOptionName+'-'+CONVERT(VARCHAR(12),Row-1)
	FROM DBO.TR_TrendCrossTabs TTCT
	INNER JOIN 
	(
		SELECT TCTId, ReportId, MTBText, BaseOptionName, ROW_NUMBER() OVER (PARTITION BY ReportId, MTBText, BaseOptionName ORDER BY ReportId) AS Row
		FROM DBO.TR_TrendCrossTabs WITH(NOLOCK)
		WHERE Reportid = @ReportId  
	) TTCT1 
		ON TTCT.ReportId = TTCT1.ReportId
		AND TTCT.TCTId = TTCT1.TCTId
		AND TTCT.MTBText = TTCT1.MTBText  
		AND TTCT.BaseOptionName = TTCT1.BaseOptionName
	WHERE TTCT1.Row > 1
	
	UPDATE TTCT
	SET TTCT.OptionDisplayText = TTCT.MTBOptionName+'-'+CONVERT(VARCHAR(12),Row-1)
	FROM DBO.TR_TrendCrossTabsRanker TTCT
	INNER JOIN 
	(
		SELECT TCTId, ReportId, MTBText, BaseOptionName,BaseSurveyId, ROW_NUMBER() OVER (PARTITION BY ReportId, MTBText, BaseOptionName,BaseSurveyId
		ORDER BY ReportId) AS Row
		FROM DBO.TR_TrendCrossTabsRanker WITH(NOLOCK)
		WHERE Reportid = @ReportId  
	) TTCT1 
		ON TTCT.ReportId = TTCT1.ReportId
		AND TTCT.TCTId = TTCT1.TCTId
		AND TTCT.MTBText = TTCT1.MTBText  
		AND TTCT.BaseOptionName = TTCT1.BaseOptionName
		AND TTCT.BaseSurveyId = TTCT1.BaseSurveyId
	WHERE TTCT1.Row > 1
	
	INSERT INTO DBO.TR_SongTrendReportColumn
	(ReportId, ColumnText, Hidden, Tab)
	SELECT 
		TTCT.ReportId, ISNULL(TTCT.OptionDisplayText,TTCT.MTBOptionName), 'False', 'TrendOption'
	FROM DBO.TR_TrendCrossTabs TTCT WITH(NOLOCK)
	LEFT JOIN DBO.TR_SongTrendReportColumn TSTRC WITH(NOLOCK)
		ON TTCT.ReportId = TSTRC.ReportId
		AND LTRIM(RTRIM(TTCT.MTBOptionName)) = LTRIM(RTRIM(TSTRC.ColumnText))
	WHERE TTCT.ReportId = @ReportId AND TSTRC.ColumnText IS NULL
	
	INSERT INTO DBO.TR_SongTrendReportColumn
	(ReportId, ColumnText, Hidden, Tab)
	SELECT 
		TTCT.ReportId, ISNULL(TTCT.OptionDisplayText,TTCT.MTBOptionName), 'False', 'TrendRanker'
	FROM DBO.TR_TrendCrossTabsRanker TTCT WITH(NOLOCK)
	LEFT JOIN DBO.TR_SongTrendReportColumn TSTRC WITH(NOLOCK)
		ON TTCT.ReportId = TSTRC.ReportId
		AND LTRIM(RTRIM(TTCT.MTBOptionName)) = LTRIM(RTRIM(TSTRC.ColumnText))
	WHERE TTCT.ReportId = @ReportId --AND TSTRC.ColumnText IS NULL

	INSERT INTO DBO.TR_SongTrendReportColumn
	(ReportId, ColumnText, Hidden, Tab)
	SELECT 
		TMA.ReportId, TMA.ColumnText, 'False', 'TrendOption'
	FROM
	(
		SELECT 
			DISTINCT 
			TR.ReportId, TMA.Answer AS ColumnText
		FROM DBO.TR_MediaAnswers TMA WITH(NOLOCK)
		CROSS JOIN DBO.TR_Report TR WHERE TR.ReportId = @ReportId
	) TMA
	LEFT JOIN DBO.TR_SongTrendReportColumn TSTRC
		ON TMA.ReportId = TSTRC.ReportId
		AND LTRIM(RTRIM(TMA.ColumnText)) = LTRIM(RTRIM(TSTRC.ColumnText))
	WHERE TSTRC.ColumnText IS NULL
	
	INSERT INTO DBO.TR_SongTrendReportColumn
	(ReportId, ColumnText, Hidden, Tab)
	SELECT 
		TMA.ReportId, TMA.ColumnText, 'False', 'TrendRanker'
	FROM
	(
		SELECT 
			DISTINCT 
			TR.ReportId, TMA.Answer AS ColumnText
		FROM DBO.TR_MediaAnswers TMA WITH(NOLOCK)
		CROSS JOIN DBO.TR_Report TR WHERE TR.ReportId = @ReportId
	) TMA
	LEFT JOIN DBO.TR_SongTrendReportColumn TSTRC
		ON TMA.ReportId = TSTRC.ReportId
		AND LTRIM(RTRIM(TMA.ColumnText)) = LTRIM(RTRIM(TSTRC.ColumnText))
	WHERE TSTRC.ColumnText IS NULL
	
	DELETE TRSM 
	FROM DBO.TR_ReportScoreMapped TRSM
	INNER JOIN #TR_ReportScoreMapped TRSM1
	ON TRSM.ReportId = TRSM1.ReportId
	
	INSERT INTO DBO.TR_ReportScoreMapped
	(ReportId, ScoreId)
	SELECT ReportId, ScoreId FROM #TR_ReportScoreMapped WHERE ScoreId IS NOT NULL
	
	INSERT INTO DBO.TR_ReportScoreMapped
	(ReportId, ScoreId)
	SELECT ReportId, TRId FROM DBO.TR_TrendReportColumns WHERE ReportId = @ReportId
	
	IF NOT EXISTS
	(
		SELECT 1 FROM DBO.TR_ReportSettings WHERE ReportId = @ReportId AND SettingId IN(1,2)
	)
	BEGIN
		INSERT INTO DBO.TR_ReportSettings
		(ReportId,SettingId,Value)
		SELECT DISTINCT @ReportId AS ReportId, 1 AS SettingId, 'True' AS Value  
		UNION
		SELECT DISTINCT @ReportId AS ReportId, 2 AS SettingId, 'False' AS Value  
	END	
	
	---------------
	UPDATE DBO.TR_Report
	SET IsActive = 1
	WHERE ReportId = @ReportId
	-------------		
	
	SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark
	
	DROP TABLE #TrendReport
	DROP TABLE #TrendReportWithoutMTB

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
