IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveTrendPerceptFilter]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveTrendPerceptFilter]


GO
/*
EXEC UspSaveTrendPerceptFilter '<?xml version="1.0" encoding="utf-16"?>
<PereceptFilterModel>
  <FilterName>First Filter</FilterName>
  <SurveyId>1101</SurveyId>
  <ReportId>200</ReportId>
  <Expressions>
    <PerceptFilterExpressions>
      <QuestionId>15350</QuestionId>
      <AnswerText>25</AnswerText>
      <Operator>=</Operator>
    </PerceptFilterExpressions>
    <PerceptFilterExpressions>
      <QuestionId>15352</QuestionId>
      <Conjunction>and</Conjunction>
      <AnswerId>115191</AnswerId>
      <Operator>in</Operator>
    </PerceptFilterExpressions>
  </Expressions>
</PereceptFilterModel>'
*/
		
CREATE PROCEDURE DBO.UspSaveTrendPerceptFilter
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	
	SELECT
		Parent.Elm.value('(FilterName)[1]','NVARCHAR(50)') AS FilterName,
		Parent.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Parent.Elm.value('(ReportId)[1]','VARCHAR(30)') AS ReportId,
		Child1.Elm.value('(QuestionId)[1]','VARCHAR(30)') AS QuestionId,
		Child1.Elm.value('(Conjunction)[1]','VARCHAR(30)') AS Conjunction,
		Child1.Elm.value('(AnswerId)[1]','VARCHAR(20)') AS AnswerId,
		Child1.Elm.value('(AnswerText)[1]','VARCHAR(20)') AS AnswerText,
		Child1.Elm.value('(Operator)[1]','VARCHAR(20)') AS Operator
	INTO #TrendPerceptFilter
	FROM @input.nodes('/PereceptFilterModel') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Expressions') AS Child(Elm)
	CROSS APPLY
		Child.Elm.nodes('PerceptFilterExpressions') AS Child1(Elm)	

	DECLARE @FilterId INT
	SET @FilterId = 0
	
	IF EXISTS 
	(
		SELECT 1 FROM DBO.MS_TrendPerceptFilter MTPF
		INNER JOIN #TrendPerceptFilter TPF
		ON LTRIM(RTRIM(MTPF.FilterName)) = LTRIM(RTRIM(TPF.FilterName)) AND CONVERT(VARCHAR(12),MTPF.ReportId) = TPF.ReportId
	)
	BEGIN
		SELECT 0 AS RetValue, 'Already Exist In The System' AS Remark
	END
	ELSE
	BEGIN
		INSERT INTO DBO.MS_TrendPerceptFilter
		(
			FilterName, SurveyId, ReportId, CreatedOn
		)
		SELECT 	
			DISTINCT FilterName, SurveyId, ReportId, GETDATE()
		FROM #TrendPerceptFilter  
			
		SET @FilterId = @@IDENTITY
		
		INSERT INTO DBO.TR_TrendPerceptFilter
		(FilterId, QuestionId, Conjuction, AnswerId, AnswerText, Operator)
		SELECT 
			@FilterId, QuestionId, Conjunction, AnswerId, AnswerText, Operator
		FROM #TrendPerceptFilter
		
		SELECT 
			CASE WHEN ISNULL(@FilterId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@FilterId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
			ISNULL(@FilterId,0) AS FilterId
	END

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



