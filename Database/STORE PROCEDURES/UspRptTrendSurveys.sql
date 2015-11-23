IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptTrendSurveys]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptTrendSurveys]

GO
-- EXEC UspRptTrendSurveys 533
-- EXEC UspRptTrendSurveys 2

CREATE PROCEDURE [dbo].[UspRptTrendSurveys] 
	@ReportId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY
 
	DECLARE @BaseSurveyName NVARCHAR(50) 
	DECLARE @BaseSurveyId INT
	SELECT 
		@BaseSurveyName = BaseSurveyName, @BaseSurveyId = BaseSurveyId FROM TR_Trends  
	WHERE ReportId = @ReportId

	CREATE TABLE #TR_Trends
	(
		SurveyName NVARCHAR(50), SurveyId INT, ReportId INT, IsBaseSurvey VARCHAR(5), IsCompareSurvey VARCHAR(5), 
		Options VARCHAR(50), TotalResponse VARCHAR(5), SortOrder INT
	)
	INSERT INTO #TR_Trends
	(SurveyName, SurveyId,ReportId, IsBaseSurvey,IsCompareSurvey,Options,TotalResponse)
	SELECT 
		@BaseSurveyName AS SurveyName, @BaseSurveyId AS SurveyId, @ReportId AS ReportId, 'true' AS IsBaseSurvey, 
		'false' AS IsCompareSurvey,' ' AS Options, '0' AS TotalResponse
		
	INSERT INTO #TR_Trends
	(SurveyName, SurveyId,ReportId, IsBaseSurvey,IsCompareSurvey,Options,TotalResponse, SortOrder)
	SELECT 
		SurveyName,SurveyId,ReportId, 'false' AS IsBaseSurvey, 'true' AS IsCompareSurvey,' ' AS Options, 
		'0' AS TotalResponse, SortOrder
	FROM TR_Trends WITH(NOLOCK) WHERE ReportId = @ReportId AND SurveyId IS NOT NULL
	
	CREATE TABLE #SurveyAnswers
	(
		SurveyId INT, AnswerText NVARCHAR(1000), OptionDisplayText NVARCHAR(1000), QuestionId INT, 
		QuestionNo VARCHAR(8), OptionQuestionNo INT, [Text] NVARCHAR(1000), IsPerceptFilter VARCHAR(5) 
	)

	INSERT INTO #SurveyAnswers
	(SurveyId, AnswerText, QuestionId, QuestionNo, OptionQuestionNo, [Text], IsPerceptFilter)
	SELECT 
		TSQ.SurveyId, 
		'[Q.'+CONVERT(VARCHAR(12),TSQ.QuestionNo)+']. '+TSA.AnswerText,
		TSA.QuestionId, '[Q.'+CONVERT(VARCHAR(12),TSQ.QuestionNo)+']. ' AS QuestionNo,
		TSQ.QuestionNo AS OptionQuestionNo, 
		'[Q.'+CONVERT(VARCHAR(12),TSQ.QuestionNo)+']. '+TSA.AnswerText AS [Text], 
		'false' AS IsPerceptFilter
	FROM DBO.TR_SurveyAnswers TSA WITH(NOLOCK)
	INNER JOIN 
	(
		SELECT TSQ.SurveyId, TSQ.QuestionId, TSQ.QuestionNo
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_QuestionSettings TQS WITH(NOLOCK)
		ON TSQ.QuestionId = TQS.QuestionId
		INNER JOIN #TR_Trends TT
		ON TSQ.SurveyId = TT.SurveyId
		WHERE TQS.SettingId = 4 -- IsMTBQuestion
		AND TQS.Value = 'False' 
	) TSQ
	ON TSA.QuestionId = TSQ.QuestionId

	INSERT INTO #SurveyAnswers
	(SurveyId, AnswerText, QuestionId, OptionQuestionNo, [Text], IsPerceptFilter)
	SELECT 
		DISTINCT 
		@BaseSurveyId, 
		'[Q.'+CONVERT(VARCHAR(10),TSQ.QuestionNo)+']. '+LEFT(TSQ.QuestionText,10)+
			CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TR.AnswerText AS AnswerText,
		TSQ.QuestionId, TSQ.QuestionNo,   
		LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TR.AnswerText AS [Text],
		'false' AS IsPerceptFilter
	FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C'
	WHERE TSQ.SurveyId = @BaseSurveyId AND TSQ.QuestionTypeId = 3/*TextInput*/
	
	INSERT INTO #SurveyAnswers
	(SurveyId, AnswerText, OptionQuestionNo, [Text], IsPerceptFilter)
	SELECT 
		DISTINCT @BaseSurveyId, MTPF.FilterName, 0 AS QuestionNo, MTPF.FilterName, 'true' AS IsPerceptFilter
	FROM DBO.MS_TrendPerceptFilter MTPF WITH(NOLOCK)
	INNER JOIN DBO.TR_TrendPerceptFilter TTPF WITH(NOLOCK)
		ON MTPF.FilterId = TTPF.FilterId AND MTPF.ReportId = @ReportId AND MTPF.SurveyId = @BaseSurveyId
		
	CREATE TABLE #ColumnHeaderCount
	(Answer NVARCHAR(150), ResCount INT)
	INSERT INTO #ColumnHeaderCount
	(Answer, ResCount)
	EXEC DBO.UspRptColumnHeaderCount @ReportId
	
	-- What is yo...:31 (99)
	
	UPDATE SA
	SET SA.OptionDisplayText = CHC.OptionDisplayText
	FROM #SurveyAnswers SA
	INNER JOIN
	(
		SELECT 
			REPLACE(A.Answer,'-'+B.Answer,'') AS Answer,
			REPLACE(A.Answer,'-'+B.Answer,'')+' ('+CONVERT(VARCHAR(12),A.ResCount)+')' AS OptionDisplayText 
		FROM #ColumnHeaderCount A
		INNER JOIN DBO.TR_MediaAnswers B WITH(NOLOCK)
			ON '-'+A.Answer LIKE '%'+'-'+B.Answer+'%' 
	) CHC
		ON SA.AnswerText = CHC.Answer	
	
	UPDATE SA
	SET SA.OptionDisplayText = CHC.OptionDisplayText
	FROM #SurveyAnswers SA
	INNER JOIN
	(
		SELECT 
			REPLACE(A.Answer,'-'+B.Answer,'') AS Answer,
			REPLACE(A.Answer,'-'+B.Answer,'')+' ('+CONVERT(VARCHAR(12),A.ResCount)+')' AS OptionDisplayText 
		FROM #ColumnHeaderCount A
		INNER JOIN DBO.TR_MediaAnswers B WITH(NOLOCK)
			ON '-'+A.Answer LIKE '%'+'-'+B.Answer+'%' 
	) CHC
		ON SUBSTRING(SA.AnswerText,PATINDEX('%|%',SA.AnswerText)+1,150) = CHC.Answer
	
	UPDATE #SurveyAnswers
	SET OptionDisplayText = AnswerText+' (1)'
	WHERE OptionDisplayText IS NULL
	
	UPDATE SA
	SET SA.OptionDisplayText =  SA.AnswerText+' ('+CONVERT(VARCHAR(12),CHC.ResCount)+')'
	FROM #SurveyAnswers SA 
	INNER JOIN #ColumnHeaderCount CHC
		ON SA.AnswerText = CHC.Answer
	
	-------------------------------------------------------------------

	DECLARE @xmlResult XML
	
	SET @XmlResult =
	(
		SELECT 
		(
			SELECT
			(
				SELECT 
				(
					SELECT  
						 TT.SurveyName, TT.SurveyId, TT.ReportId, TT.IsBaseSurvey, TT.IsCompareSurvey, TT.SortOrder, 
					(
						SELECT
						(
							 SELECT 
								SA.SurveyId, REPLACE(SA.[Text],ISNULL(SA.QuestionNo,''),'') AS [Text], 
								SA.OptionDisplayText, '' AS BaseSurveyId, '' AS BaseText, '' AS MtbOption, 
								'' AS MtbOptionName, SA.QuestionId AS BaseQuestionId, SA.OptionQuestionNo,
								SA.QuestionId AS OptionQuestionId, SA.IsPerceptFilter
							 FROM #SurveyAnswers SA
							 WHERE SA.SurveyId = TT.SurveyId AND RIGHT(SA.OptionDisplayText,1) = ')'
							 FOR XML PATH('Option'), TYPE 
						 )
						 FOR XML PATH('Options'), TYPE 
					),
						 TT.TotalResponse  
					FROM #TR_Trends TT
					FOR XML PATH('SurveySelection'), TYPE
				) 
				FOR XML PATH(''), TYPE 
			)
			FOR XML PATH(''), TYPE	
		)
		FOR XML PATH(''), ROOT('ArrayOfSurveySelection')
	)

	SELECT @XmlResult AS XmlResult
	
	DROP TABLE #ColumnHeaderCount
	DROP TABLE #TR_Trends
	DROP TABLE #SurveyAnswers
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


