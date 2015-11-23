IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetEmailTriggerMail]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetEmailTriggerMail]

GO

--EXEC UspGetEmailTriggerMail  
CREATE PROCEDURE DBO.UspGetEmailTriggerMail
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @SplitAnserId TABLE
	(RowId INT IDENTITY(1,1), TrgId INT, AnswerId VARCHAR(1000))

	DECLARE @MultipleAnswers TABLE
	(TrgId INT, AnswerId VARCHAR(12))
	
	DECLARE @AnswerText TABLE
	(TrgId INT, AnswerText VARCHAR(1000))


	DECLARE @Count INT
	DECLARE @MinRow INT
	DECLARE @MaxRow INT
	DECLARE @AnswerId VARCHAR(1000)
	DECLARE @TrgId INT
	DECLARE @ColesceColumn VARCHAR(1000)
	
	SET @Count = 0
	SET @MinRow = 1
	SET @ColesceColumn = ''
	
	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_EmailTriggerMails TETM INNER JOIN TR_SurveyQuestions TSQ
			ON TETM.QuestionId = TSQ.QuestionId AND TETM.SentDate IS NULL 
			AND TETM.AnswerId LIKE '%,%'
	)
	BEGIN
		INSERT INTO @SplitAnserId
		(TrgId, AnswerId)
		SELECT TrgId, AnswerId FROM DBO.TR_EmailTriggerMails TETM INNER JOIN TR_SurveyQuestions TSQ
			ON TETM.QuestionId = TSQ.QuestionId AND TETM.SentDate IS NULL 
			AND TETM.AnswerId LIKE '%,%'

		SELECT @MaxRow = MAX(RowId) FROM @SplitAnserId
		
		WHILE @MinRow <= @MaxRow
		BEGIN
			SELECT @TrgId = TrgId, @AnswerId = AnswerId FROM @SplitAnserId WHERE RowId = @MinRow
			
			INSERT INTO @MultipleAnswers
			(TrgId, AnswerId)
			SELECT @TrgId, Value AS AnswerId FROM [dbo].[Split](',',@AnswerId)

			SELECT 
				@ColesceColumn = COALESCE(@ColesceColumn,'','')+Answer+',' 
			FROM @MultipleAnswers MA 
			INNER JOIN DBO.TR_SurveyAnswers TSA
				ON LTRIM(RTRIM(MA.AnswerId)) = CONVERT(VARCHAR(12),TSA.AnswerId)

			INSERT INTO @AnswerText
			(TrgId, AnswerText)
			VALUES(@TrgId, LEFT(@ColesceColumn,LEN(@ColesceColumn)-1))

			SET @ColesceColumn = ''
			SET @MinRow = @MinRow+1
		END		
	END

	SELECT 
		TETM.TrgId, TETM.ToEmailId, TETM.QuestionId, TETM.QuestionText, TETM.AnswerId, TETM.AnswerType, TETM.Answer,
		MR.EmailId, MR.FirstName, MR.LastName, MR.BirthDate, MR.Age, 
		CASE WHEN MR.Gender = 'M' THEN 'Male' 
			 WHEN MR.Gender = 'F' THEN 'Female' ELSE MR.Gender END AS Gender, MR.Town,
		TS.SurveyName	 
	FROM
	(
		SELECT 
			TETM.TrgId, TETM.ToEmailId, TETM.QuestionId, TSQ.QuestionText, TETM.AnswerId, TETM.AnswerType,
			CASE WHEN TETM.AnswerType = 'ID' THEN TSA.Answer ELSE TETM.AnswerId END AS Answer, TETM.RespondentId
		FROM DBO.TR_EmailTriggerMails TETM
		INNER JOIN TR_SurveyQuestions TSQ
			ON TETM.QuestionId = TSQ.QuestionId
		LEFT OUTER JOIN TR_SurveyAnswers TSA
			ON LTRIM(RTRIM(TETM.AnswerId)) = CONVERT(VARCHAR(12),TSA.AnswerId) 
		WHERE TETM.SentDate IS NULL AND TETM.AnswerId NOT LIKE '%,%'
		
		UNION
		
		SELECT 
			TETM.TrgId, TETM.ToEmailId, TETM.QuestionId, TSQ.QuestionText, TETM.AnswerId, TETM.AnswerType,
			CASE WHEN TETM.AnswerType = 'ID' THEN AT.AnswerText ELSE TETM.AnswerId END AS Answer, TETM.RespondentId
		FROM DBO.TR_EmailTriggerMails TETM
		INNER JOIN @AnswerText AT
			ON TETM.TrgId = AT.TrgId
		INNER JOIN TR_SurveyQuestions TSQ
			ON TETM.QuestionId = TSQ.QuestionId
		WHERE TETM.SentDate IS NULL AND TETM.AnswerId LIKE '%,%'
	) TETM
	INNER JOIN dbo.TR_SurveyQuestions TSQ
		ON TETM.QuestionId = TSQ.QuestionId
	INNER JOIN dbo.TR_Survey TS	
		ON TSQ.SurveyId = TS.SurveyId
	LEFT JOIN DBO.MS_Respondent MR
		ON TETM.RespondentId = MR.RespondentId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END