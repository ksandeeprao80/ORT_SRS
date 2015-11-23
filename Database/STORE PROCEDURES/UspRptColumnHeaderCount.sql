IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptColumnHeaderCount]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptColumnHeaderCount 

GO  
-- EXEC DBO.UspRptColumnHeaderCount 502
CREATE PROCEDURE DBO.UspRptColumnHeaderCount
	@ReportId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY 	

	CREATE TABLE #CompareSurvey 
	(SurveyId INT,IsBaseSurvey INT)
	INSERT INTO #CompareSurvey
	(SurveyId, IsBaseSurvey)
	SELECT BaseSurveyId AS SurveyId, 1 FROM DBO.TR_Trends WITH(NOLOCK) WHERE ReportId = @ReportId
	UNION
	SELECT SurveyId, 0 FROM DBO.TR_Trends WITH(NOLOCK) WHERE ReportId = @ReportId AND SurveyId IS NOT NULL
	UNION
	SELECT SurveyId, 1 from DBO.TR_ReportDataSource WITH(NOLOCK) WHERE ReportId = @ReportId
	
	DECLARE @TotalRespondent INT
	SELECT 
		@TotalRespondent = COUNT(1) 
	FROM 
	(	
		SELECT 
			DISTINCT 
			TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS SessionId 
		FROM #CompareSurvey S
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		ON S.SurveyId = TSQ.SurveyId
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
		ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C'
	) A

	-------
	-- Base Survey
	CREATE TABLE #BaseAnswerCount 
	(Answer NVARCHAR(150), ResCount INT, QuestionNo INT, QuestionId INT) 
	INSERT INTO #BaseAnswerCount
	(Answer, ResCount, QuestionNo, QuestionId)
	SELECT 
		Answer, COUNT(1) AS ResCount, QuestionNo, QuestionId 
	FROM
	(
		SELECT 
			TR.RespondentId, TSA.Answer, COUNT(1) AS ResCount, TSQ.QuestionNo, TSQ.QuestionId, TR.SessionId
		FROM #CompareSurvey CS 
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON CS.SurveyId = TSQ.SurveyId AND CS.IsBaseSurvey = 1
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C' 
		INNER JOIN DBO.TR_SurveyAnswers TSA WITH(NOLOCK)
			ON TR.AnswerId = TSA.AnswerId	
		GROUP BY TR.RespondentId, TSA.Answer, TSQ.QuestionNo, TSQ.QuestionId, TR.SessionId
	) TR1
	GROUP BY Answer, QuestionNo, QuestionId		

 	INSERT INTO #BaseAnswerCount
	(Answer, ResCount, QuestionNo, QuestionId)
	SELECT 
		Answer, COUNT(1) AS ResCount, QuestionNo, QuestionId 
	FROM
	(
		SELECT 
			TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS RespondentId, TR.AnswerText AS Answer, 
			COUNT(1) AS ResCount, TSQ.QuestionNo, TSQ.QuestionId 
		FROM #CompareSurvey CS
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON CS.SurveyId = TSQ.SurveyId AND CS.IsBaseSurvey = 1
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C' 
			AND TR.SongId = 0 AND TR.AnswerId = 0
		GROUP BY TR.RespondentId, TR.AnswerText, TSQ.QuestionNo, TSQ.QuestionId, TR.SessionId
		
		UNION
		
		SELECT 
			TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS RespondentId,  
			(LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TR.AnswerText) AS Answer, 
			COUNT(1) AS ResCount, TSQ.QuestionNo, TSQ.QuestionId 
		FROM #CompareSurvey CS
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON CS.SurveyId = TSQ.SurveyId AND CS.IsBaseSurvey = 1
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C' 
			AND TR.SongId = 0 AND TR.AnswerId = 0
			AND ISNUMERIC(TR.AnswerText)= 1
		GROUP BY TR.RespondentId, TSQ.QuestionText, TR.AnswerText, TSQ.QuestionNo, TSQ.QuestionId, TR.SessionId
	) TR1
	GROUP BY Answer, QuestionNo, QuestionId	

	-- All Compare Survey
	CREATE TABLE #CompareAnswerCount 
	(Answer NVARCHAR(150), ResCount INT, QuestionNo INT, QuestionId INT) 
	INSERT INTO #CompareAnswerCount
	(Answer, ResCount, QuestionNo, QuestionId)
	SELECT 
		Answer, COUNT(1) AS ResCount, QuestionNo, QuestionId 
	FROM
	(
		SELECT 
			TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS RespondentId, TSA.Answer, COUNT(1) AS ResCount, 
			TSQ.QuestionNo, TSQ.QuestionId 
		FROM #CompareSurvey CS 
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON CS.SurveyId = TSQ.SurveyId AND CS.IsBaseSurvey = 0
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C' 
		INNER JOIN DBO.TR_SurveyAnswers TSA WITH(NOLOCK)
			ON TR.AnswerId = TSA.AnswerId	
		GROUP BY TR.RespondentId, TSA.Answer, TSQ.QuestionNo, TSQ.QuestionId, TR.SessionId
	) TR1
	GROUP BY Answer, QuestionNo, QuestionId 		
	
	INSERT INTO #CompareAnswerCount
	(Answer, ResCount, QuestionNo, QuestionId)
	SELECT 
		Answer, COUNT(1) AS ResCount, QuestionNo, QuestionId 
	FROM
	(
		SELECT 
			TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS RespondentId, TR.AnswerText AS Answer, 
			COUNT(1) AS ResCount, TSQ.QuestionNo, TSQ.QuestionId 
		FROM #CompareSurvey CS
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON CS.SurveyId = TSQ.SurveyId AND CS.IsBaseSurvey = 0
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) 
			ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C' 
			AND TR.SongId = 0 AND TR.AnswerId = 0
		GROUP BY TR.RespondentId, TR.AnswerText, TSQ.QuestionNo, TSQ.QuestionId, TR.SessionId
		
		UNION
		
		SELECT 
			TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS RespondentId,
			(LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TR.AnswerText) AS Answer, 
			COUNT(1) AS ResCount, TSQ.QuestionNo, TSQ.QuestionId 
		FROM #CompareSurvey CS
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON CS.SurveyId = TSQ.SurveyId AND CS.IsBaseSurvey = 0
		INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C' 
			AND TR.SongId = 0 AND TR.AnswerId = 0
			AND ISNUMERIC(TR.AnswerText)= 1
		GROUP BY TR.RespondentId, TSQ.QuestionText, TR.AnswerText, TSQ.QuestionNo, TSQ.QuestionId, TR.SessionId
	) TR1
	GROUP BY Answer, QuestionNo, QuestionId	

	UPDATE CAC
	SET CAC.Answer = CASE WHEN LTRIM(RTRIM(CAC.Answer)) = LTRIM(RTRIM(TTO1.OptionName)) THEN TTO1.BaseOptionName
						  ELSE CAC.Answer END
	FROM #CompareAnswerCount CAC
	LEFT JOIN 
	(
		SELECT TTO.BaseOptionName, TTO.OptionName, TTO.OptionQuestionId 
		FROM DBO.TR_Trends TT WITH(NOLOCK)
		INNER JOIN DBO.TR_TrendOptionMapping TTO WITH(NOLOCK) 
		ON TT.TrendId = TTO.TrendId AND TT.ReportId = @ReportId
		WHERE LTRIM(RTRIM(TTO.BaseOptionName)) <> LTRIM(RTRIM(TTO.OptionName))
	) TTO1
		ON LTRIM(RTRIM(CAC.Answer)) = LTRIM(RTRIM(TTO1.OptionName))
		AND CAC.QuestionId = TTO1.OptionQuestionId

	SELECT 
		DISTINCT
		CASE WHEN HdCnt.QuestionNo = 0 THEN HdCnt.Answer
			WHEN LTRIM(RTRIM(HdCnt.Answer)) = LTRIM(RTRIM(TMA.Answer)) THEN HdCnt.Answer
			ELSE '[Q.'+CONVERT(VARCHAR(12),HdCnt.QuestionNo)+']. '+HdCnt.Answer END AS Answer, 
		ResCount
	FROM
	(
		SELECT 
			TR2.Answer, @TotalRespondent AS ResCount, TR2.QuestionNo 
		FROM
		(
			SELECT 
				TR1.AnswerId, TR1.QuestionId, TMA.Answer, COUNT(1) AS ResCount, TR1.QuestionNo
			FROM
			(
				SELECT 
					TSQ.QuestionId, TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS RespondentId, 
					TR.AnswerId, COUNT(1) AS ResCount, TSQ.QuestionNo 
				FROM DBO.TR_Responses TR WITH(NOLOCK)
				INNER JOIN 
				(
					SELECT CS.SurveyId, TSQ.QuestionId, TSQ.QuestionNo 	
					FROM #CompareSurvey CS
					INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
					ON CS.SurveyId = TSQ.SurveyId
				) TSQ	
				ON TR.QuestionId = TSQ.QuestionId AND TR.[Status] = 'C'
				AND TR.SongId <> 0  AND ISNULL(TR.AnswerId,0) <> 0
				GROUP BY TR.RespondentId, TR.AnswerId, TSQ.QuestionId, TSQ.QuestionNo, TR.SessionId
			) TR1
			INNER JOIN DBO.TR_MediaAnswers TMA WITH(NOLOCK)
				ON TR1.AnswerId = TMA.AnswerId
			GROUP BY TR1.AnswerId, TR1.QuestionId, TMA.Answer, TR1.QuestionNo	
		) TR2
			GROUP BY TR2.AnswerId, TR2.Answer, TR2.QuestionNo
		
		UNION
		
		SELECT 
			ColumnName AS Answer, @TotalRespondent AS ResCount, 0 AS QuestionNo 
		FROM DBO.TR_TrendReportColumns WITH(NOLOCK) WHERE ReportId = @ReportId
		
		UNION 
		
		SELECT 
			FilterName AS Answer, COUNT(1) AS ResCount, 0 AS QuestionNo 
		FROM DBO.MS_TrendPerceptFilter WHERE ReportId = @ReportId GROUP BY FilterName
		
		UNION
		SELECT 
			A1.Answer+'-'+TMA.Answer AS Answer, A1.ResCount, A1.QuestionNo 
		FROM 
		(
			SELECT Answer FROM DBO.TR_MediaAnswers WITH(NOLOCK) 
			UNION
			SELECT MTBText AS Answer FROM TR_TrendCrossTabs WITH(NOLOCK) WHERE ReportId = @ReportId
		) TMA
		CROSS JOIN
		(
			SELECT Answer, SUM(ResCount) AS ResCount, QuestionNo
			FROM
			(
				SELECT Answer, ResCount, QuestionNo FROM #BaseAnswerCount
				UNION ALL
				SELECT Answer, ResCount, QuestionNo FROM #CompareAnswerCount
			) A
			GROUP BY Answer, QuestionNo
		) A1
	) HdCnt
	LEFT JOIN DBO.TR_MediaAnswers TMA WITH(NOLOCK)
		ON LTRIM(RTRIM(HdCnt.Answer)) = LTRIM(RTRIM(TMA.Answer))
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
