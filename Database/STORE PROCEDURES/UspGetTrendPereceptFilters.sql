IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTrendPereceptFilters]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTrendPereceptFilters]

GO
-- EXEC UspGetTrendPereceptFilters 200

CREATE PROCEDURE DBO.UspGetTrendPereceptFilters
	@ReportId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @Filter TABLE
	(FilterId INT, SurveyId INT, QuestionId INT, Expression NVARCHAR(1000), FilterName NVARCHAR(100), Conjuction VARCHAR(20))
	INSERT INTO @Filter
	(FilterId, SurveyId, QuestionId, Expression, FilterName, Conjuction)
	SELECT 
		MTPF.FilterId, MTPF.SurveyId, TTPF.QuestionId,
		' '+ISNULL(TTPF.Conjuction,'')+' '+LEFT(TSQ.QuestionText,20)+CASE WHEN LEN(TSQ.QuestionText)>20 THEN '...' ELSE '' END+
		CASE WHEN TTPF.Operator = 'IN' THEN '=' 
			 WHEN TTPF.Operator = 'NOT IN' THEN '<>' ELSE TTPF.Operator END  
		+' '+
		CASE WHEN TTPF.AnswerId IS NULL THEN TTPF.AnswerText
			 ELSE (LEFT(TSA.AnswerText,20)+CASE WHEN LEN(TSA.AnswerText)>20 THEN '...' ELSE '' END) END
			AS Expression, MTPF.FilterName, Conjuction
	FROM DBO.MS_TrendPerceptFilter MTPF
	INNER JOIN DBO.TR_TrendPerceptFilter TTPF
		ON MTPF.FilterId = TTPF.FilterId
	INNER JOIN DBO.TR_SurveyQuestions TSQ	
		ON TTPF.QuestionId = TSQ.QuestionId  
	LEFT OUTER JOIN DBO.TR_SurveyAnswers TSA
		ON TTPF.AnswerId = TSA.AnswerId		
	WHERE MTPF.ReportId = @ReportId
	
	DECLARE @DistinctQuestionId TABLE
	(RowId INT IDENTITY(1,1), FilterId INT)
	INSERT INTO @DistinctQuestionId
	(FilterId)
	SELECT DISTINCT FilterId FROM @Filter  
	
	DECLARE @FilterExpression TABLE
	(FilterId INT, FilterName NVARCHAR(100), Expression NVARCHAR(1000))

	DECLARE @ListStr VARCHAR(8000)
	DECLARE @MinRow INT
	DECLARE @MaxRow INT
	SET @MinRow = 1
	SELECT @MaxRow = MAX(RowId) FROM @DistinctQuestionId
	
	WHILE @MinRow <= @MaxRow
	BEGIN 
		SELECT @ListStr = COALESCE(@ListStr+'','') + Expression 
		FROM @Filter A
		INNER JOIN @DistinctQuestionId B
			ON A.FilterId = B.FilterId
		WHERE B.RowId = @MinRow
	
		INSERT INTO @FilterExpression
		(FilterId, FilterName, Expression)
		SELECT 
			DISTINCT A.FilterId, A.FilterName, @ListStr
		FROM @Filter A
		INNER JOIN @DistinctQuestionId B
			ON A.FilterId = B.FilterId
		WHERE B.RowId = @MinRow
		
		SET @ListStr = ''
	
		SET @MinRow = @MinRow+1	
	END
	
	SELECT * FROM @FilterExpression
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 