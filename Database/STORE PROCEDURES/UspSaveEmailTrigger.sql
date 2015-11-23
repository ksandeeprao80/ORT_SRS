IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveEmailTrigger]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveEmailTrigger]

GO

/*
EXEC UspSaveEmailTrigger @XMlData='<?xml version="1.0" encoding="utf-16"?>
<EmailTrigger>
  <Expressions>
    <EmailExpression>
      <Conjunction />
      <LogicExpression>Question(13154).Answer == Answer(114385)</LogicExpression>
      <PreviousQuestionId></PreviousQuestionId>
      <ComparisionTokens>
        <string>==</string>
        <string>&gt;=</string>
        <string>&gt;</string>
        <string>!=</string>
        <string>&lt;</string>
      </ComparisionTokens>
    </EmailExpression>
    <EmailExpression>
      <Conjunction>and</Conjunction>
      <LogicExpression>Question(13154).Answer == Answer(114385)</LogicExpression>
      <ComparisionTokens>
        <string>==</string>
        <string>&gt;=</string>
        <string>&gt;</string>
        <string>!=</string>
        <string>&lt;</string>
      </ComparisionTokens>
    </EmailExpression>
  </Expressions>
  <ToEmailId>sandeepr@wi.com</ToEmailId>
  <QuestionId>13154</QuestionId>
</EmailTrigger>'

*/
CREATE PROCEDURE DBO.UspSaveEmailTrigger
	@XmlData NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData 
	
	CREATE TABLE #QuestionBranches
	(TrueAction VARCHAR(150), QuestionId INT)	
	INSERT INTO #QuestionBranches
	(TrueAction, QuestionId)	
	SELECT
		Parent.Elm.value('(ToEmailId)[1]','VARCHAR(100)') AS TrueAction,
		Parent.Elm.value('(QuestionId)[1]','VARCHAR(20)') AS QuestionId
	FROM @input.nodes('/EmailTrigger') AS Parent(Elm)
	
	CREATE TABLE #EmailTrigger
	(TriggerExpression VARCHAR(150), Conjunction VARCHAR(20), PreviousQuestionId INT) 
	INSERT INTO #EmailTrigger
	(TriggerExpression, Conjunction, PreviousQuestionId) 
	SELECT
		Child1.Elm.value('(LogicExpression)[1]','VARCHAR(250)') AS TriggerExpression,
		Child1.Elm.value('(Conjunction)[1]','VARCHAR(20)') AS Conjunction,
		Child1.Elm.value('(PreviousQuestionId)[1]','VARCHAR(20)') AS PreviousQuestionId
	FROM @input.nodes('/EmailTrigger') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Expressions') AS Child(Elm)
	CROSS APPLY	
		Child.Elm.nodes('EmailExpression') AS Child1(Elm)

	DECLARE @BranchId INT
	SET @BranchId = 0
	
	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, TrueAction, SurveyId, QuestionId)
	SELECT 
		DISTINCT 'Email' AS BranchType, QB.TrueAction, TSQ.SurveyId, QB.QuestionId
	FROM #QuestionBranches QB
	LEFT OUTER JOIN DBO.TR_SurveyQuestions TSQ
		ON QB.QuestionId = TSQ.QuestionId
		
	SET @BranchId = @@IDENTITY
	
	IF @BranchId <> 0
	BEGIN
		INSERT INTO DBO.TR_EmailTrigger
		(TriggerExpression, Conjunction, BranchId, PreviousQuestionId)
		SELECT 
			TriggerExpression, Conjunction, @BranchId, PreviousQuestionId
		FROM #EmailTrigger
	END
	
	SELECT CASE WHEN @BranchId = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN @BranchId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END