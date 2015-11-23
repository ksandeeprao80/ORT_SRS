IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGenerateEmailTriggerMails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE dbo.UspGenerateEmailTriggerMails

GO
/*
EXEC UspGenerateEmailTriggerMails @XMlData='<?xml version="1.0" encoding="utf-16"?>
<SurveyDetailsFromRequest>
  <SurveyId>1767</SurveyId>
  <RespondentId>0</RespondentId>
  <QuestionId>15915</QuestionId>
  <RespondentSessionId>thiceancckpn2p5533fetp45</RespondentSessionId>
</SurveyDetailsFromRequest>'
*/
CREATE PROCEDURE DBO.UspGenerateEmailTriggerMails 
	@XMlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	DECLARE @SurveyId INT 
	DECLARE @RespondentId INT 
	DECLARE @SessionId VARCHAR(100) 
	DECLARE @BranchId INT
	DECLARE @MinRow INT
	DECLARE @MaxRow INT
	DECLARE @ToEmailId VARCHAR(100)
	DECLARE @i INT  
	DECLARE @Count INT  
	DECLARE @TriggerExpression VARCHAR(150)
	DECLARE @Conjunction VARCHAR(20)
	DECLARE @Result INT  

	SET @MinRow = 1
	SET @i = 1
	SET @Count = 0
	SET @Result = 0
	
	CREATE TABLE #EmailTriggerMails
	(
		SurveyId INT, RespondentId INT, SessionId VARCHAR(100), QuestionId INT
	)
	INSERT INTO #EmailTriggerMails
	(
		SurveyId, RespondentId, SessionId, QuestionId
	)
	SELECT
		Parent.Elm.value('(SurveyId)[1]','VARCHAR(12)') AS SurveyId,
		Parent.Elm.value('(RespondentId)[1]','VARCHAR(12)') AS RespondentId,
		Parent.Elm.value('(RespondentSessionId)[1]','VARCHAR(100)') AS SessionId,
		Parent.Elm.value('(QuestionId)[1]','VARCHAR(12)') AS QuestionId
	FROM @input.nodes('/SurveyDetailsFromRequest') AS Parent(Elm)
	
	SELECT 
		@SurveyId = SurveyId, @RespondentId = ISNULL(RespondentId,0), @SessionId = SessionId 
	FROM #EmailTriggerMails
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.MS_QuestionBranches MQB WITH(NOLOCK) 
		INNER JOIN DBO.TR_EmailTrigger TET WITH(NOLOCK) ON MQB.BranchId = TET.BranchId
		WHERE MQB.SurveyId = @SurveyId 
	)
	BEGIN
		CREATE TABLE #Trg_MailData
		(RowNum INT IDENTITY(1,1), TriggerExpression VARCHAR(150), Conjunction VARCHAR(20), BranchId INT)
		
		CREATE TABLE #QuestionBranches
		(RowId INT IDENTITY(1,1), BranchId INT, TrueAction VARCHAR(150), SurveyId INT, QuestionId INT)
		INSERT INTO #QuestionBranches
		(BranchId, TrueAction, SurveyId, QuestionId)
		SELECT 
			BranchId, TrueAction, SurveyId, QuestionId
		FROM DBO.MS_QuestionBranches WITH(NOLOCK) WHERE SurveyId = @SurveyId AND BranchType = 'Email'
		
		CREATE TABLE #Responses
		(QuestionId INT, AnswerId INT, RespondentId INT, SessionId VARCHAR(100), AnswerText VARCHAR(250), QuestionTypeId INT)
		INSERT INTO #Responses
		(QuestionId, AnswerId, RespondentId, SessionId, AnswerText, QuestionTypeId)
		SELECT 
			DISTINCT
			TR.QuestionId, TR.AnswerId, TR.RespondentId, TR.SessionId, TR.AnswerText, TSQ.QuestionTypeId 
		FROM DBO.TR_Responses TR WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId	
		WHERE TSQ.SurveyId = @SurveyId
		AND ISNULL(TR.RespondentId,0) = ISNULL(@RespondentId,0)
		AND ISNULL(TR.SessionId,'') = ISNULL(@SessionId,'') 
		
		SELECT @MaxRow = COUNT(1) FROM #QuestionBranches  
		
		WHILE @MinRow <= @MaxRow
		BEGIN
			SELECT @BranchId = BranchId, @ToEmailId = TrueAction FROM #QuestionBranches WHERE RowId = @MinRow
			
			TRUNCATE TABLE #Trg_MailData
			
			INSERT INTO #Trg_MailData
			(TriggerExpression, Conjunction, BranchId)
			SELECT TriggerExpression, Conjunction, BranchId FROM DBO.TR_EmailTrigger WHERE BranchId = @BranchId
			
			SELECT @Count = COUNT(1) FROM #Trg_MailData  
			
			WHILE @i <= @Count
			BEGIN
				SELECT @TriggerExpression = TriggerExpression, @Conjunction = Conjunction FROM #Trg_MailData WHERE RowNum = @i 
				
				IF @TriggerExpression LIKE '%Answer ==%' 
				BEGIN
					IF @TriggerExpression NOT LIKE '%Answer == Answer(%'
					BEGIN
						SELECT @Result = CASE WHEN ISNULL(@Conjunction,'') = '' THEN COUNT(1)
										  WHEN ISNULL(@Conjunction,'') = 'and' THEN @Result * COUNT(1)
										  ELSE @Result + COUNT(1) END						  
						FROM #Responses 
						WHERE QuestionTypeId NOT IN(1,2) 
						AND 'Question('+CONVERT(VARCHAR(12),QuestionId)+').Answer =='+AnswerText = @TriggerExpression  
					END
				END
				
				IF @TriggerExpression LIKE '%Answer == Answer(%'
				BEGIN
					SELECT @Result = CASE WHEN ISNULL(@Conjunction,'') = '' THEN COUNT(1)
									  WHEN ISNULL(@Conjunction,'') = 'and' THEN @Result * COUNT(1)
									  ELSE @Result + COUNT(1) END						  
					FROM #Responses 
					WHERE QuestionTypeId IN(1,2) 
					AND 'Question('+CONVERT(VARCHAR(12),QuestionId)+').Answer == Answer('+CONVERT(VARCHAR(12),AnswerId)+')' = @TriggerExpression  
				END
				
				IF @TriggerExpression LIKE '%>%'
				BEGIN
					IF @TriggerExpression NOT LIKE '%>=%'
					BEGIN
						SELECT @Result = CASE WHEN ISNULL(@Conjunction,'') = '' THEN COUNT(1)
										  WHEN ISNULL(@Conjunction,'') = 'and' THEN @Result * COUNT(1)
										  ELSE @Result + COUNT(1) END						  
						FROM #Responses 
						WHERE QuestionTypeId NOT IN(1,2) 
						AND 'Question('+CONVERT(VARCHAR(12),QuestionId)+').Answer >'  = SUBSTRING(@TriggerExpression,1,CHARINDEX('>',@TriggerExpression)) 
						AND AnswerText > SUBSTRING(@TriggerExpression,CHARINDEX('>',@TriggerExpression)+1,100)
					END
				END
				
				IF @TriggerExpression LIKE '%>=%'
				BEGIN
					SELECT @Result = CASE WHEN ISNULL(@Conjunction,'') = '' THEN COUNT(1)
									  WHEN ISNULL(@Conjunction,'') = 'and' THEN @Result * COUNT(1)
									  ELSE @Result + COUNT(1) END						  
					FROM #Responses 
					WHERE QuestionTypeId NOT IN(1,2) 
					AND 'Question('+CONVERT(VARCHAR(12),QuestionId)+').Answer >=' = SUBSTRING(@TriggerExpression,1,CHARINDEX('=',@TriggerExpression)) 
					AND AnswerText > SUBSTRING(@TriggerExpression,CHARINDEX('=',@TriggerExpression)+1,100)
				END
				
				IF @TriggerExpression LIKE '%<%'
				BEGIN
					SELECT @Result = CASE WHEN ISNULL(@Conjunction,'') = '' THEN COUNT(1)
									  WHEN ISNULL(@Conjunction,'') = 'and' THEN @Result * COUNT(1)
									  ELSE @Result + COUNT(1) END						  
					FROM #Responses 
					WHERE QuestionTypeId NOT IN(1,2) 
					AND 'Question('+CONVERT(VARCHAR(12),QuestionId)+').Answer <' = SUBSTRING(@TriggerExpression,1,CHARINDEX('<',@TriggerExpression)) 
					AND AnswerText > SUBSTRING(@TriggerExpression,CHARINDEX('<',@TriggerExpression)+1,100)
				END
				
				IF @TriggerExpression LIKE '%!=%'
				BEGIN
					SELECT @Result = CASE WHEN ISNULL(@Conjunction,'') = '' THEN COUNT(1)
									  WHEN ISNULL(@Conjunction,'') = 'and' THEN @Result * COUNT(1)
									  ELSE @Result + COUNT(1) END						  
					FROM #Responses 
					WHERE QuestionTypeId IN(1,2) 
					AND QuestionId = REPLACE(SUBSTRING(@TriggerExpression,1,CHARINDEX(')',@TriggerExpression)-1),'Question(','')   
					AND AnswerId <> REPLACE(REPLACE(@TriggerExpression,'Question('+CONVERT(VARCHAR(12),QuestionId)+').Answer != Answer(',''),')','')
				END
						    
				SET @i = @i+1
			END

			IF @Result >= 1
			BEGIN
				INSERT INTO DBO.TR_EmailTriggerMails
				(ToEmailId, QuestionId, AnswerId, AnswerType, RespondentId)
				SELECT 
					MQB.TrueAction AS ToEmailId, TR.QuestionId, TR.AnswerId, 'ID' AS AnswerType, TR.RespondentId
				FROM #Trg_MailData ETM
				INNER JOIN #QuestionBranches MQB  
					ON ETM.BranchId = MQB.BranchId
				INNER JOIN #Responses TR  
					ON MQB.QuestionId = TR.QuestionId
					AND ETM.TriggerExpression = 'Question('+CONVERT(VARCHAR(12),TR.QuestionId)+').Answer == Answer('+CONVERT(VARCHAR(12),TR.AnswerId)+')' 
				UNION			
				SELECT 
					MQB.TrueAction AS ToEmailId, TR.QuestionId, TR.AnswerText, 'VALUE' AS AnswerType, TR.RespondentId
				FROM #Trg_MailData ETM
				INNER JOIN #QuestionBranches MQB  
					ON ETM.BranchId = MQB.BranchId
				INNER JOIN #Responses TR  
					ON MQB.QuestionId = TR.QuestionId
					AND ETM.TriggerExpression = 'Question('+CONVERT(VARCHAR(12),TR.QuestionId)+').Answer =='+TR.AnswerText 
				UNION
				SELECT 
					MQB.TrueAction AS ToEmailId, TR.QuestionId, TR.AnswerText, 'VALUE' AS AnswerType, TR.RespondentId
				FROM #Trg_MailData ETM
				INNER JOIN #QuestionBranches MQB  
					ON ETM.BranchId = MQB.BranchId
					AND ETM.TriggerExpression LIKE '%>%' AND ETM.TriggerExpression NOT LIKE '%>=%'
				INNER JOIN #Responses TR  
					ON MQB.QuestionId = TR.QuestionId
					AND SUBSTRING(ETM.TriggerExpression,1,CHARINDEX('>',ETM.TriggerExpression)) = 'Question('+CONVERT(VARCHAR(12),TR.QuestionId)+').Answer >' 
				WHERE TR.AnswerText > SUBSTRING(ETM.TriggerExpression,CHARINDEX('>',ETM.TriggerExpression)+1,100)
				UNION
				SELECT 
					MQB.TrueAction AS ToEmailId, TR.QuestionId, TR.AnswerText, 'VALUE' AS AnswerType, TR.RespondentId
				FROM #Trg_MailData ETM
				INNER JOIN #QuestionBranches MQB  
					ON ETM.BranchId = MQB.BranchId
					AND ETM.TriggerExpression LIKE '%>=%' 
				INNER JOIN #Responses TR  
					ON MQB.QuestionId = TR.QuestionId
					AND SUBSTRING(ETM.TriggerExpression,1,CHARINDEX('=',ETM.TriggerExpression)) = 'Question('+CONVERT(VARCHAR(12),TR.QuestionId)+').Answer >=' 
				WHERE TR.AnswerText > SUBSTRING(ETM.TriggerExpression,CHARINDEX('=',ETM.TriggerExpression)+1,100)	
				UNION
				SELECT 
					MQB.TrueAction AS ToEmailId, TR.QuestionId, TR.AnswerText, 'VALUE' AS AnswerType, TR.RespondentId
				FROM #Trg_MailData ETM
				INNER JOIN #QuestionBranches MQB  
					ON ETM.BranchId = MQB.BranchId
					AND ETM.TriggerExpression LIKE '%<%' 
				INNER JOIN #Responses TR  
					ON MQB.QuestionId = TR.QuestionId
					AND SUBSTRING(ETM.TriggerExpression,1,CHARINDEX('<',ETM.TriggerExpression)) = 'Question('+CONVERT(VARCHAR(12),TR.QuestionId)+').Answer <' 
				WHERE TR.AnswerText > SUBSTRING(ETM.TriggerExpression,CHARINDEX('<',ETM.TriggerExpression)+1,100)
				UNION
				SELECT 
					MQB.TrueAction AS ToEmailId, TR.QuestionId, TR.AnswerId, 'ID' AS AnswerType, TR.RespondentId
				FROM #Trg_MailData ETM
				INNER JOIN #QuestionBranches MQB  
					ON ETM.BranchId = MQB.BranchId
					AND ETM.TriggerExpression LIKE '%!=%' 
				INNER JOIN #Responses TR  
					ON MQB.QuestionId = TR.QuestionId
					AND REPLACE(SUBSTRING(ETM.TriggerExpression,1,CHARINDEX(')',ETM.TriggerExpression)-1),'Question(','') = TR.QuestionId 
				WHERE TR.AnswerId <> REPLACE(REPLACE(ETM.TriggerExpression,'Question('+CONVERT(VARCHAR(12),TR.QuestionId)+').Answer != Answer(',''),')','')	
			END
			
			SET @MinRow = @MinRow+1
		END

		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark
	END
	ELSE
	BEGIN
		SELECT 1 AS RetValue, 'No Mail Trigger Mapped' AS Remark
	END
	
	COMMIT TRAN
	
END TRY

BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

