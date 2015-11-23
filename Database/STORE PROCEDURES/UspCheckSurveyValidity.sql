IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCheckSurveyValidity]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspCheckSurveyValidity

GO
 
-- EXEC UspCheckSurveyValidity  1331 -- Invalid
-- EXEC UspCheckSurveyValidity  1118 -- Valid
-- EXEC UspCheckSurveyValidity  1238 -- Invalid

CREATE PROCEDURE DBO.UspCheckSurveyValidity
	@SurveyId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @AnsValid INT
	DECLARE @MTBValid INT
	DECLARE @MontageValid INT
	DECLARE @SkipValid INT
	SET @AnsValid = 0
	SET @MTBValid = 0
	SET @MontageValid = 0
	SET @SkipValid = 0

	CREATE TABLE #AnswerQuestions
	(QuestionId INT)
	CREATE TABLE #MTBQuestions
	(QuestionId INT)
	CREATE TABLE #MontageQuestions
	(QuestionId INT)
	CREATE TABLE #ErrorLog
	(QuestionId INT, Remark VARCHAR(150))
	CREATE TABLE #SkipLogic
	(QuestionId INT)
	
	INSERT INTO #AnswerQuestions
	(QuestionId)	
	SELECT TSQ.QuestionId/*,TSA.QuestionId, TSA.AnswerId*/ 
	FROM DBO.TR_SurveyQuestions TSQ INNER JOIN DBO.MS_QuestionTypes MQT
		ON TSQ.QuestionTypeId = MQT.QuestionTypeId AND MQT.QuestionCode IN('Boolean','SingleChoice','MultiChoice')
		AND TSQ.IsDeleted = 1 AND TSQ.SurveyId = @SurveyId
	LEFT OUTER JOIN DBO.TR_SurveyAnswers TSA ON TSQ.QuestionId = TSA.QuestionId
	WHERE TSA.QuestionId IS NULL
	
	IF EXISTS(SELECT 1 FROM #AnswerQuestions)
	BEGIN
		SET @AnsValid = 0 
		
		INSERT INTO #ErrorLog
		(QuestionId, Remark)
		SELECT DISTINCT QuestionId, 'Answer Not Exist' FROM #AnswerQuestions
	END
	ELSE
	BEGIN
		SET @AnsValid = 1 
	END

	IF @AnsValid = 1
	BEGIN
		INSERT INTO #MTBQuestions
		SELECT TSS.QuestionId/*TSQ.SurveyId, MSS.SettingId, MSS.SettingName, TSS.QuestionId, TSS.Value*/ 
		FROM MS_QuestionSettings MSS
		INNER JOIN TR_QuestionSettings TSS
			ON MSS.SettingId = TSS.SettingId
			AND MSS.SettingName = 'IsMTBQuestion' AND TSS.Value = 'True'
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TSS.QuestionId = TSQ.QuestionId
			AND TSQ.SurveyId = @SurveyId 
	 
		IF EXISTS(SELECT 1 FROM #MTBQuestions)
		BEGIN
			SELECT @MTBValid = COUNT(1) /*MSS.SettingId, MSS.SettingName, TSS.QuestionId, TSS.Value*/ 
			FROM MS_QuestionSettings MSS
			INNER JOIN TR_QuestionSettings TSS
				ON MSS.SettingId = TSS.SettingId
				AND MSS.SettingName = 'PlayListId' --AND ISNULL(TSS.Value,'') NOT IN('','0')
			INNER JOIN DBO.#MTBQuestions MTBQ
				ON TSS.QuestionId = MTBQ.QuestionId
			INNER JOIN DBO.TR_PlayList TPL
				ON TPL.PlayListId = CONVERT(INT,TSS.Value)	
		END
		ELSE
		BEGIN
			SET @MTBValid = 1 
		END
		
		IF ISNULL(@MTBValid,0) = 0
		BEGIN 
			INSERT INTO #ErrorLog
			(QuestionId, Remark)
			SELECT DISTINCT QuestionId, 'Playlist Id MisMatch or Not Exist in Question Setting' FROM #MTBQuestions
		END
	END		
 
	IF @AnsValid = 1
	BEGIN
		INSERT INTO #MontageQuestions
		SELECT TSS.QuestionId/*TSQ.SurveyId, MSS.SettingId, MSS.SettingName, TSS.QuestionId, TSS.Value*/ 
		FROM MS_QuestionSettings MSS
		INNER JOIN TR_QuestionSettings TSS
			ON MSS.SettingId = TSS.SettingId
			AND MSS.SettingName = 'HasMedia' AND TSS.Value = 'True'
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TSS.QuestionId = TSQ.QuestionId
			AND TSQ.SurveyId = @SurveyId 
	 
		IF EXISTS(SELECT 1 FROM #MontageQuestions)
		BEGIN
			SELECT @MontageValid = COUNT(1) /*MSS.SettingId, MSS.SettingName, TSS.QuestionId, TSS.Value*/ 
			FROM MS_QuestionSettings MSS
			INNER JOIN TR_QuestionSettings TSS
				ON MSS.SettingId = TSS.SettingId
				AND MSS.SettingName = 'SongFileLibId' --AND ISNULL(TSS.Value,'') NOT IN('','0')
			INNER JOIN DBO.#MontageQuestions MTBQ
				ON TSS.QuestionId = MTBQ.QuestionId
			INNER JOIN DBO.TR_FileLibrary TFL
				ON TFL.FileLibId = CONVERT(INT,TSS.Value)	
		END
		ELSE
		BEGIN
			SET @MontageValid = 1 
		END
		
		IF ISNULL(@MontageValid,0) = 0
		BEGIN 
			INSERT INTO #ErrorLog
			(QuestionId, Remark)
			SELECT DISTINCT QuestionId, 'File Lib Id MisMatch or Not Exist in Question Setting' FROM #MontageQuestions
		END
	END		

	IF @AnsValid = 1
	BEGIN
		INSERT INTO #SkipLogic
		(QuestionId)
		SELECT MQB.QuestionId FROM DBO.MS_QuestionBranches MQB
		LEFT OUTER JOIN TR_SurveyQuestions TSQ
			ON MQB.QuestionId = TSQ.QuestionId AND MQB.SurveyId = TSQ.SurveyId 
			AND MQB.SurveyId = @SurveyId AND MQB.BranchType NOT IN('Email')
		WHERE TSQ.QuestionId IS NULL 

		IF EXISTS(SELECT 1 FROM #SkipLogic)
		BEGIN
			INSERT INTO #ErrorLog 
			(QuestionId, Remark)
			SELECT DISTINCT QuestionId, 'Question Not Exist In Question Table' FROM #SkipLogic
		END
		ELSE
		BEGIN
			SET @SkipValid = 1
		END
		
		INSERT INTO #ErrorLog 
		(QuestionId, Remark)
		SELECT TSQ.QuestionId, 'Can Not Jump To Page Break' FROM DBO.MS_QuestionBranches MQB
		INNER JOIN TR_SurveyQuestions TSQ
			ON CONVERT(INT,MQB.TrueAction) = TSQ.QuestionId AND MQB.SurveyId = TSQ.SurveyId 
			AND MQB.SurveyId = @SurveyId AND MQB.BranchType NOT IN('Email')
			AND TSQ.QuestionTypeId = 4
	END
		
	
	IF (ISNULL(@AnsValid,0) = 1 AND ISNULL(@MTBValid,0) = 1 AND ISNULL(@MontageValid,0) = 1 AND ISNULL(@SkipValid,0) =1)
	BEGIN
		SELECT 1 AS RetValue, 'Valid Survey' AS Remark
	END
	ELSE
	BEGIN
		--SELECT 0 AS RetValue, 'Invalid Survey' AS Remark
		SELECT * FROM #ErrorLog
	END
	
	DROP TABLE #MTBQuestions
	DROP TABLE #MontageQuestions
	DROP TABLE #AnswerQuestions
	DROP TABLE #ErrorLog

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
	