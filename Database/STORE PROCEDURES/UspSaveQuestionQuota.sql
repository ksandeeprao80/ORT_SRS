IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveQuestionQuota]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveQuestionQuota]

GO
/*
EXEC UspSaveQuestionQuota '<?xml version="1.0" encoding="utf-16"?>
<Quota>
  <FalseAction>13154</FalseAction>
  <QuestionId>13154</QuestionId>
  <Expressions>
    <QuotaExpression>
      <Conjunction />
      <LogicExpression>Count(AnswerId(114355)) == 3</LogicExpression>
      <PreviousQuestionId></PreviousQuestionId>
      <ComparisionTokens>
        <string>==</string>
        <string>&gt;=</string>
        <string>&gt;</string>
        <string>!=</string>
        <string>&lt;</string>
      </ComparisionTokens>
    </QuotaExpression>
    <QuotaExpression>
      <Conjunction>and</Conjunction>
      <LogicExpression>Count(AnswerId(114356)) == 5</LogicExpression>
      <ComparisionTokens>
        <string>==</string>
        <string>&gt;=</string>
        <string>&gt;</string>
        <string>!=</string>
        <string>&lt;</string>
      </ComparisionTokens>
    </QuotaExpression>
    <QuotaExpression>
      <Conjunction>and</Conjunction>
      <LogicExpression>Count(AnswerId(114371)) == 7</LogicExpression>
      <ComparisionTokens>
        <string>==</string>
        <string>&gt;=</string>
        <string>&gt;</string>
        <string>!=</string>
        <string>&lt;</string>
      </ComparisionTokens>
    </QuotaExpression>
  </Expressions>
</Quota>'
*/

CREATE PROCEDURE DBO.UspSaveQuestionQuota
	 @XmlData NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	
	CREATE TABLE #QuestionBranches
	(FalseAction VARCHAR(150), QuestionId INT)	
	INSERT INTO #QuestionBranches
	(FalseAction, QuestionId)	
	SELECT
		Parent.Elm.value('(FalseAction)[1]','VARCHAR(100)') AS FalseAction,
		Parent.Elm.value('(QuestionId)[1]','VARCHAR(20)') AS QuestionId
	FROM @input.nodes('/Quota') AS Parent(Elm)
	
	CREATE TABLE #QuestionQuota
	(LogicExpression VARCHAR(250), Conjunction VARCHAR(20), PreviousQuestionId INT) 
	INSERT INTO #QuestionQuota
	(LogicExpression, Conjunction, PreviousQuestionId) 
	SELECT
		Child1.Elm.value('(LogicExpression)[1]','VARCHAR(250)') AS LogicExpression,
		Child1.Elm.value('(Conjunction)[1]','VARCHAR(20)') AS Conjunction,
		Child1.Elm.value('(PreviousQuestionId)[1]','VARCHAR(20)') AS PreviousQuestionId
	FROM @input.nodes('/Quota') AS Parent(Elm)
		CROSS APPLY
		Parent.Elm.nodes('Expressions') AS Child(Elm)
	CROSS APPLY	
		Child.Elm.nodes('QuotaExpression') AS Child1(Elm)
		
	DECLARE @BranchId INT
	SET @BranchId = 0
	
	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, SurveyId, QuestionId)
	SELECT 
		DISTINCT 'Quota' AS BranchType, TSQ.SurveyId, QB.QuestionId
	FROM #QuestionBranches QB
	LEFT OUTER JOIN TR_SurveyQuestions TSQ
		ON QB.QuestionId = TSQ.QuestionId
		
	SET @BranchId = @@IDENTITY

	IF @BranchId <> 0
	BEGIN
		UPDATE TSS SET TSS.Value = 'True'
		FROM MS_QuestionSettings MSS 
		INNER JOIN TR_QuestionSettings TSS
			ON MSS.SettingId = TSS.SettingId
			AND MSS.SettingName = 'CheckQuota'
		INNER JOIN DBO.MS_QuestionBranches MQB
			ON TSS.QuestionId = MQB.QuestionId	
			AND MQB.BranchType = 'Quota'
		
		INSERT INTO DBO.TR_QuestionQuota
		(LogicExpression, Conjunction, BranchId, PreviousQuestionId) 
		SELECT LogicExpression, Conjunction, @BranchId, PreviousQuestionId FROM #QuestionQuota
	END		
	
	SELECT CASE WHEN ISNULL(@BranchId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@BranchId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark

	DROP TABLE #QuestionQuota
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
