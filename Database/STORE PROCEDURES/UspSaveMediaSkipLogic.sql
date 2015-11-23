IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveMediaSkipLogic]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveMediaSkipLogic

GO  
/* 
--EXEC UspSaveMediaSkipLogic @XmlData='<?xml version="1.0" encoding="utf-16"?>
<SkipLogic>
  <TrueAction>13608</TrueAction>
  <FalseAction>13605</FalseAction>
  <QuestionId>13605</QuestionId>
  <Expressions>
    <SkiplogicExpression>
      <CheckQuestionId>13605</CheckQuestionId>
      <LogicExpression>Question(13605).Answer == Answer(1)</LogicExpression>
    </SkiplogicExpression>
  </Expressions>
</SkipLogic>'
*/

CREATE PROCEDURE DBO.UspSaveMediaSkipLogic
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @input XML = @XmlData
	
	CREATE TABLE #QuestionBranches
	(TrueAction VARCHAR(150), FalseAction VARCHAR(150), QuestionId INT)	
	INSERT INTO #QuestionBranches
	(TrueAction, FalseAction, QuestionId)	
	SELECT 
		Parent.Elm.value('(TrueAction)[1]','VARCHAR(250)') AS TrueAction,
		Parent.Elm.value('(FalseAction)[1]','VARCHAR(250)') AS FalseAction,
		Parent.Elm.value('(QuestionId )[1]','VARCHAR(20)') AS QuestionId
	FROM @input.nodes('/SkipLogic') AS Parent(Elm)
	
	CREATE TABLE #SkipLogic
	(LogicExpression  VARCHAR(1000), Conjunction VARCHAR(20), PreviousQuestionId INT)
	INSERT INTO #SkipLogic
	(LogicExpression, Conjunction, PreviousQuestionId)
	SELECT 
		Child1.Elm.value('(LogicExpression)[1]','VARCHAR(1000)') AS LogicExpression,
		Child1.Elm.value('(Conjunction )[1]','VARCHAR(20)') AS Conjunction,
		Child1.Elm.value('(PreviousQuestionId )[1]','VARCHAR(20)') AS PreviousQuestionId
	FROM @input.nodes('/SkipLogic') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Expressions') AS Child(Elm)
	CROSS APPLY	
		Child.Elm.nodes('SkiplogicExpression') AS Child1(Elm)
		
 	DELETE TMSL
	FROM DBO.TR_MediaSkipLogic TMSL 
	INNER JOIN DBO.MS_QuestionBranches MQB
		ON TMSL.BranchId = MQB.BranchId
		AND MQB.BranchType = 'Media'	
	INNER JOIN #QuestionBranches QB
		ON MQB.QuestionId = QB.QuestionId 
		
	DELETE MQB
	FROM DBO.MS_QuestionBranches MQB
	INNER JOIN #QuestionBranches QB
		ON MQB.QuestionId = QB.QuestionId 
		AND MQB.BranchType = 'Media'

	DECLARE @BranchId INT
	SET @BranchId = 0
		
	INSERT INTO DBO.MS_QuestionBranches
	(BranchType, TrueAction, FalseAction, SurveyId, QuestionId)
	SELECT 
		'Media' AS BranchType, QB.TrueAction, QB.FalseAction, TSQ.SurveyId, QB.QuestionId
	FROM #QuestionBranches QB
	LEFT OUTER JOIN DBO.TR_SurveyQuestions TSQ
		ON QB.QuestionId = TSQ.QuestionId
	
	SET @BranchId = @@IDENTITY
	
	IF @BranchId <> 0
	BEGIN
		INSERT INTO DBO.TR_MediaSkipLogic
		(LogicExpression, Conjunction, BranchId, PreviousQuestionId)
		SELECT 
			LogicExpression, Conjunction, @BranchId, PreviousQuestionId
		FROM #SkipLogic 
	END		
	
	SELECT CASE WHEN ISNULL(@BranchId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@BranchId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
	
	DROP TABLE #SkipLogic
	DROP TABLE #QuestionBranches
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
