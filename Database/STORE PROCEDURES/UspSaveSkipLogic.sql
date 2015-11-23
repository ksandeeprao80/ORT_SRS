IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSkipLogic]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSkipLogic]
GO
/*
EXEC UspSaveSkipLogic @XmlData='<?xml version="1.0" encoding="utf-16"?>
<SkipLogic>
  <TrueAction>13158</TrueAction>
  <FalseAction>13154</FalseAction>
  <QuestionId>13154</QuestionId>
  <Expressions>
    <SkiplogicExpression>
      <Conjunction />
      <LogicExpression>Question(13154).Answer == 20</LogicExpression>
      <ComparisionTokens>
        <string>==</string>
        <string>&gt;=</string>
        <string>&gt;</string>
        <string>!=</string>
        <string>&lt;</string>
      </ComparisionTokens>
    </SkiplogicExpression>
    <SkiplogicExpression>
      <Conjunction>and</Conjunction>
      <LogicExpression>Question(13154).Answer == 40</LogicExpression>
      <ComparisionTokens>
        <string>==</string>
        <string>&gt;=</string>
        <string>&gt;</string>
        <string>!=</string>
        <string>&lt;</string>
      </ComparisionTokens>
    </SkiplogicExpression>
    <SkiplogicExpression>
      <Conjunction>and</Conjunction>
      <LogicExpression>Question(13154).Answer == 30</LogicExpression>
      <PreviousQuestionId></PreviousQuestionId>
      <ComparisionTokens>
        <string>==</string>
        <string>&gt;=</string>
        <string>&gt;</string>
        <string>!=</string>
        <string>&lt;</string>
      </ComparisionTokens>
    </SkiplogicExpression>
  </Expressions>
  <SurveyId>1306</SurveyId>
</SkipLogic>'
 -- Note : CheckQuestionId is actually Survey Id
 uspGetEditSkipLogic 1308
 
*/
CREATE PROCEDURE DBO.UspSaveSkipLogic
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @input XML = @XmlData

	CREATE TABLE #QuestionBranches
	(TrueAction VARCHAR(150), FalseAction VARCHAR(150), SurveyId INT, QuestionId INT)	
	INSERT INTO #QuestionBranches
	(TrueAction, FalseAction, SurveyId, QuestionId)	
	SELECT 
		Parent.Elm.value('(TrueAction)[1]','VARCHAR(250)') AS TrueAction,
		Parent.Elm.value('(FalseAction)[1]','VARCHAR(250)') AS FalseAction,
		Parent.Elm.value('(SurveyId)[1]','VARCHAR(20)') AS SurveyId,
		Parent.Elm.value('(QuestionId)[1]','VARCHAR(20)') AS QuestionId
	FROM @input.nodes('/SkipLogic') AS Parent(Elm)

	CREATE TABLE #SkipLogic
	(LogicExpression  VARCHAR(1000), Conjunction VARCHAR(20), PreviousQuestionId INT)
	INSERT INTO #SkipLogic
	(LogicExpression, Conjunction, PreviousQuestionId)
	SELECT 
		Child1.Elm.value('(LogicExpression)[1]','VARCHAR(1000)') AS LogicExpression,
		Child1.Elm.value('(Conjunction)[1]','VARCHAR(20)') AS Conjunction,
		Child1.Elm.value('(PreviousQuestionId)[1]','VARCHAR(20)') AS PreviousQuestionId
	FROM @input.nodes('/SkipLogic') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Expressions') AS Child(Elm)
	CROSS APPLY	
		Child.Elm.nodes('SkiplogicExpression') AS Child1(Elm)
		
	DECLARE @BranchId INT
	SET @BranchId = 0

	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, TrueAction, FalseAction, SurveyId, QuestionId)
	SELECT 
		'Skip' AS BranchType, TrueAction, FalseAction, SurveyId, QuestionId
	FROM #QuestionBranches
	
	SET @BranchId = @@IDENTITY
	
	IF @BranchId <> 0
	BEGIN
		INSERT INTO DBO.TR_SkipLogic
		(LogicExpression, Conjunction, BranchId, PreviousQuestionId)
		SELECT 
			LogicExpression, Conjunction, @BranchId, PreviousQuestionId
		FROM #SkipLogic 
		
		UPDATE TSS 
		SET TSS.Value = 'True'
		FROM DBO.TR_SurveySettings TSS
		INNER JOIN DBO.MS_QuestionBranches MQB
			ON TSS.SurveyId = MQB.SurveyId
			AND MQB.BranchId = @BranchId  
		INNER JOIN MS_SurveySettings MSS
			ON MSS.SettingId = TSS.SettingId
			AND MSS.SettingName = 'VerifySkipLogic'
	END		
		
	SELECT CASE WHEN ISNULL(@BranchId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@BranchId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark

 	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END