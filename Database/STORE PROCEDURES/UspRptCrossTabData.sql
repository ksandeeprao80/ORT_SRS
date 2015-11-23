IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptCrossTabData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptCrossTabData 

GO  
-- EXEC UspRptCrossTabData 307,NULL,1147,'Female'

CREATE PROCEDURE DBO.UspRptCrossTabData 
	@ReportId INT,
	@SurveyId INT = NULL,
	@SongId INT = NULL,
	@BaseOption NVARCHAR(500) = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	IF @SurveyId = '' SET @SurveyId = NULL
	IF @BaseOption = '' SET @BaseOption = NULL

	CREATE TABLE #TR_SurveyQuestions
	(
		QuestionId INT, SurveyId INT, CustomerId INT, QuestionTypeId INT, QuestionText NVARCHAR(2000), 
		IsDeleted BIT, DefaultAnswerId INT, QuestionNo INT, IsBaseSurvey INT
	)
	INSERT INTO #TR_SurveyQuestions
	(
		QuestionId, SurveyId, CustomerId, QuestionTypeId, QuestionText, IsDeleted, DefaultAnswerId, 
		QuestionNo, IsBaseSurvey 
	)
	SELECT 
		DISTINCT
		TSQ.QuestionId, TSQ.SurveyId, TSQ.CustomerId, TSQ.QuestionTypeId, TSQ.QuestionText, 
		TSQ.IsDeleted, TSQ.DefaultAnswerId, TSQ.QuestionNo, CS.IsBaseSurvey 
	FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	INNER JOIN 
	(
		SELECT SurveyId, IsBaseSurvey
		FROM
		(
			SELECT BaseSurveyId AS SurveyId, 1 AS IsBaseSurvey FROM DBO.TR_Trends WITH(NOLOCK) WHERE ReportId = @ReportId
			UNION ALL
			SELECT SurveyId, 0 AS IsBaseSurvey FROM DBO.TR_Trends WITH(NOLOCK) WHERE ReportId = @ReportId AND SurveyId IS NOT NULL
		) A
	) CS 
		ON TSQ.SurveyId = CS.SurveyId
	WHERE TSQ.QuestionNo <> 0	

	CREATE TABLE #TR_Responses
	(
		ResponseId INT, QuestionId INT, AnswerId INT, RespondentId INT, SessionId VARCHAR(100), [Status] CHAR(5), 
		AnswerText NVARCHAR(500), ResponseDate DATETIME, SongId INT, IpAddress VARCHAR(30),
		IsBaseSurvey INT, QuestionTypeId INT, QuestionNo INT, QuestionText NVARCHAR(2000)
	) 
	INSERT INTO #TR_Responses
	(
		ResponseId, QuestionId, AnswerId, RespondentId, SessionId, [Status], AnswerText, ResponseDate, 
		SongId, IpAddress, IsBaseSurvey, QuestionTypeId, QuestionNo, QuestionText
	)
	SELECT 
		TR.ResponseId, TR.QuestionId, TR.AnswerId, TR.RespondentId, TR.SessionId, TR.[Status], TR.AnswerText, 
		TR.ResponseDate, TR.SongId, TR.IpAddress, TSQ.IsBaseSurvey, TSQ.QuestionTypeId, TSQ.QuestionNo, 
		TSQ.QuestionText
	FROM #TR_SurveyQuestions TSQ
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
		ON TSQ.QuestionId = TR.QuestionId AND TR.[Status] = 'C'
	
	CREATE TABLE #TR_SurveyAnswers
	(AnswerId INT, QuestionId INT, Answer NVARCHAR(1000), AnswerText NVARCHAR(1000))
	INSERT INTO #TR_SurveyAnswers
	(AnswerId, QuestionId, Answer, AnswerText)
	SELECT 
		TSA.AnswerId, TSA.QuestionId, TSA.Answer, TSA.AnswerText
	FROM #TR_SurveyQuestions TSQ
	INNER JOIN DBO.TR_SurveyAnswers TSA WITH(NOLOCK)
		ON TSQ.QuestionId = TSA.QuestionId
	
	CREATE TABLE #TR_TrendCrossTabs
	(
		TCTId INT, ReportId INT, BaseSurveyId INT, BaseOptionId INT, MTBId INT, MTBText NVARCHAR(100),
		MTBOptionName NVARCHAR(500), StatusId INT, BaseOptionName NVARCHAR(500), IsCalculated INT,
		TrendType VARCHAR(10), MtbOptionId INT, BaseQuestionId INT, OptionQuestionId INT, QuestionNo INT,
		OptionDisplayText NVARCHAR(500), QuestionText NVARCHAR(2000), QuestionTypeId INT
	)
	INSERT INTO #TR_TrendCrossTabs
	(
		TCTId, ReportId, BaseSurveyId, BaseOptionId, MTBId, MTBText, MTBOptionName, StatusId, 
		BaseOptionName, IsCalculated, TrendType, MtbOptionId,BaseQuestionId,OptionQuestionId, QuestionNo,
		OptionDisplayText, QuestionText, QuestionTypeId
	)
	SELECT 
		TTCT.TCTId, TTCT.ReportId, TTCT.BaseSurveyId, TTCT.BaseOptionId, TTCT.MTBId, TTCT.MTBText, 
		TTCT.MTBOptionName, TTCT.StatusId, TTCT.BaseOptionName, TTCT.IsCalculated, TTCT.TrendType, 
		TTCT.MtbOptionId, ISNULL(TTCT.BaseQuestionId,0) AS BaseQuestionId, TTCT.OptionQuestionId, 
		TSQ.QuestionNo, TTCT.OptionDisplayText, TSQ.QuestionText, TSQ.QuestionTypeId 
	FROM DBO.TR_TrendCrossTabs TTCT WITH(NOLOCK)
	LEFT JOIN #TR_SurveyQuestions TSQ
		ON TTCT.BaseQuestionId = TSQ.QuestionId
	WHERE TTCT.ReportId = @ReportId
	
	CREATE TABLE #PerceptualResponses 
	(
		QuestionId INT, AnswerId INT, SessionId VARCHAR(100), [Status] CHAR(5), AnswerText NVARCHAR(250), 
		SongId INT, IsBaseSurvey INT, QuestionTypeId INT, QuestionNo INT, QuestionText NVARCHAR(2000),
		RespondentId INT
	)
	INSERT INTO #PerceptualResponses
	(
		QuestionId, AnswerId, SessionId, [Status], AnswerText, SongId, IsBaseSurvey, 
		QuestionTypeId, QuestionNo, QuestionText, RespondentId
	)
	SELECT 
		TR.QuestionId, TR.AnswerId, TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS SessionId, TR.[Status], 
		CASE WHEN TR.AnswerId = TSA.AnswerId THEN TSA.AnswerText ELSE TR.AnswerText END AS AnswerText, 
		TR.SongId, TR.IsBaseSurvey, TR.QuestionTypeId, TR.QuestionNo, TR.QuestionText, TR.RespondentId
	FROM #TR_Responses TR
	LEFT JOIN #TR_SurveyAnswers TSA ON TR.AnswerId = TSA.AnswerId
	WHERE TR.SongId = 0  
 
	CREATE TABLE #TR_TrendOptionMapping
	(
		TOMId INT, TrendId INT, OptionId INT, OptionName NVARCHAR(500), BaseOptionId INT,
		BaseOptionName NVARCHAR(500), StatusId INT, BaseQuestionId INT, OptionQuestionId INT
	)
	INSERT INTO #TR_TrendOptionMapping
	(
		TOMId, TrendId, OptionId, OptionName, BaseOptionId, BaseOptionName, StatusId,
		BaseQuestionId, OptionQuestionId
	)
	SELECT 
		TTO.TOMId, TTO.TrendId, TTO.OptionId, TTO.OptionName, TTO.BaseOptionId, TTO.BaseOptionName,
		TTO.StatusId, TTO.BaseQuestionId, TTO.OptionQuestionId
	FROM DBO.TR_Trends TT WITH(NOLOCK)
	INNER JOIN DBO.TR_TrendOptionMapping TTO WITH(NOLOCK)
		ON TT.TrendId = TTO.TrendId AND TT.ReportId = @ReportId

	CREATE TABLE #PerceptResponseCount 
	(SessionId VARCHAR(100), QuestionId INT, BaseOptionName NVARCHAR(500), QuestionNo INT, QuestionText NVARCHAR(2000))
	INSERT INTO #PerceptResponseCount
	(SessionId, QuestionId, BaseOptionName, QuestionNo, QuestionText)
	SELECT 
		DISTINCT 
		TR.SessionId, TR.QuestionId,
		CASE WHEN TR.AnswerId = TSA.AnswerId THEN TSA.AnswerText ELSE TR.AnswerText END AS AnswerText,
		TR.QuestionNo, TR.QuestionText
	FROM #TR_Responses TR
	LEFT JOIN #TR_SurveyAnswers TSA ON TR.AnswerId = TSA.AnswerId
	WHERE TR.SongId = 0  

	UPDATE A
	SET A.BaseOptionName  = CASE WHEN A.BaseOptionName = B.OptionName THEN B.BaseOptionName ELSE A.BaseOptionName END
	FROM #PerceptResponseCount A
	LEFT JOIN 
	(	
		SELECT 
			TTO.OptionName, TTO.BaseOptionName, TTCT.BaseQuestionId AS QuestionId 
		FROM #TR_TrendCrossTabs TTCT 
		INNER JOIN #TR_TrendOptionMapping TTO WITH(NOLOCK)
			ON TTCT.BaseOptionName = TTO.BaseOptionName 
			AND TTCT.BaseQuestionId = TTO.BaseQuestionId 
	) B 
		ON A.BaseOptionName = B.OptionName AND A.QuestionId = B.QuestionId

	CREATE TABLE #BasePerceptResponseCount 
	(BaseOptionName NVARCHAR(500), ResponseCount INT, QuestionId INT, QuestionNo INT, QuestionText NVARCHAR(2000))	
	INSERT INTO #BasePerceptResponseCount
	(BaseOptionName, ResponseCount, QuestionId, QuestionNo, QuestionText)
	SELECT 
		BaseOptionName, COUNT(1) AS ResponseCount, QuestionId, QuestionNo, QuestionText 
	FROM #PerceptResponseCount GROUP BY BaseOptionName, QuestionId, QuestionNo, QuestionText

	CREATE TABLE #MTBResponses  
	(
		QuestionId INT, AnswerId INT, SessionId NVARCHAR(100), [Status] CHAR(5), AnswerText NVARCHAR(250), 
		SongId INT, IsBaseSurvey INT, QuestionNo INT, QuestionText NVARCHAR(2000), RespondentId INT
	)
	INSERT INTO #MTBResponses
	(
		QuestionId, AnswerId, SessionId, [Status], AnswerText, SongId, IsBaseSurvey, QuestionNo, 
		QuestionText, RespondentId
	)
	SELECT 
		TR.QuestionId, TR.AnswerId, TR.SessionId+CONVERT(VARCHAR(12),TR.RespondentId) AS SessionId, TR.[Status], 
		TMA.AnswerText, TR.SongId, TR.IsBaseSurvey, TR.QuestionNo, TR.QuestionText, TR.RespondentId
	FROM #TR_Responses TR
	INNER JOIN DBO.TR_MediaAnswers TMA WITH(NOLOCK)
		ON TR.AnswerId = TMA.AnswerId
	WHERE TR.SongId > 0  
	ORDER BY TR.AnswerId

	CREATE TABLE #AllData 
	(
		PercepAnser INT, PerceAnserText NVARCHAR(500), MTBAnser INT, MTBAnserText NVARCHAR(100), SongId INT,
		AnswerText NVARCHAR(1000), SessionId VARCHAR(100), QuestionId INT, IsBaseSurvey INT, QuestionTypeId INT,
		QuestionNo INT, QuestionText NVARCHAR(2000), RespondentId INT
	)
	INSERT INTO #AllData
	(
		PercepAnser, PerceAnserText, MTBAnser, MTBAnserText, SongId, AnswerText, SessionId, QuestionId, 
		IsBaseSurvey, QuestionTypeId, QuestionNo, QuestionText, RespondentId
	)
	SELECT  
		P.AnswerId AS PercepAnser,
		CASE WHEN TTO.OptionName = P.AnswerText THEN TTO.BaseOptionName ELSE P.AnswerText END AS PerceAnserText, 
		M.AnswerId AS MTBAnser, M.AnswerText AS MTBAnserText, M.SongId, P.AnswerText, P.SessionId, 
		P.QuestionId, P.IsBaseSurvey, P.QuestionTypeId, P.QuestionNo, P.QuestionText, P.RespondentId
	FROM #PerceptualResponses P
	INNER JOIN #MTBResponses M 
		ON P.SessionId = M.SessionId
		AND P.RespondentId = M.RespondentId
		AND P.IsBaseSurvey = 0 AND M.IsBaseSurvey = 0
	INNER JOIN #TR_TrendOptionMapping TTO 
		ON TTO.OptionName = P.AnswerText
	WHERE P.QuestionTypeId NOT IN(3,6,9,16)
		
	INSERT INTO #AllData
	(
		PercepAnser, PerceAnserText, MTBAnser, MTBAnserText, SongId, AnswerText, SessionId, QuestionId, 
		IsBaseSurvey, QuestionTypeId, QuestionNo, QuestionText, RespondentId 
	)
	SELECT  
		P.AnswerId AS PercepAnser, TSA.AnswerText AS PerceAnserText, M.AnswerId AS MTBAnser, 
		M.AnswerText AS MTBAnserText, M.SongId, TSA.AnswerText, P.SessionId, P.QuestionId,
		P.IsBaseSurvey, P.QuestionTypeId, P.QuestionNo, P.QuestionText, P.RespondentId
	FROM #PerceptualResponses P
	INNER JOIN #MTBResponses M 
		ON P.SessionId = M.SessionId
		AND P.RespondentId = M.RespondentId
		AND P.IsBaseSurvey = 1 AND M.IsBaseSurvey = 1
	INNER JOIN #TR_SurveyAnswers TSA 
		ON P.AnswerId = TSA.AnswerId
	WHERE P.QuestionTypeId NOT IN(3,6,9,16)	
	
	INSERT INTO #AllData
	(
		PercepAnser, PerceAnserText, MTBAnser, MTBAnserText, SongId, AnswerText, SessionId, QuestionId, 
		IsBaseSurvey, QuestionTypeId, QuestionNo, QuestionText, RespondentId  
	)
	SELECT 
		P.AnswerId AS PercepAnser, TTO.OptionName AS PerceAnserText, M.AnswerId AS MTBAnser, 
		M.AnswerText AS MTBAnserText, M.SongId, P.AnswerText, P.SessionId, P.QuestionId,
		P.IsBaseSurvey, P.QuestionTypeId, P.QuestionNo, P.QuestionText, P.RespondentId
	FROM #PerceptualResponses P 
	INNER JOIN #MTBResponses M 
		ON P.SessionId = M.SessionId
		AND P.RespondentId = M.RespondentId
		AND P.IsBaseSurvey = 0 AND M.IsBaseSurvey = 0
	INNER JOIN #TR_TrendOptionMapping TTO 
		ON TTO.OptionName = (LEFT(P.QuestionText,10)+CASE WHEN LEN(P.QuestionText)>10 THEN '...:' ELSE ':' END+P.AnswerText)
	WHERE P.QuestionTypeId NOT IN(3,6,9,16)  AND ISNULL(P.AnswerText,'') <> '' 

	INSERT INTO #AllData
	(
		PercepAnser, PerceAnserText, MTBAnser, MTBAnserText, SongId, AnswerText, SessionId, QuestionId, 
		IsBaseSurvey, QuestionTypeId, QuestionNo, QuestionText, RespondentId 
	)
	SELECT 
		P.AnswerId AS PercepAnser,
		(LEFT(P.QuestionText,10)+CASE WHEN LEN(P.QuestionText)>10 THEN '...:' ELSE ':' END+P.AnswerText) AS PerceAnserText, 
		M.AnswerId AS MTBAnser, M.AnswerText AS MTBAnserText, M.SongId, P.AnswerText, P.SessionId,
		P.QuestionId, P.IsBaseSurvey, P.QuestionTypeId, P.QuestionNo, P.QuestionText, P.RespondentId
	FROM #PerceptualResponses P 
	INNER JOIN #MTBResponses M 
		ON P.SessionId = M.SessionId
		AND P.RespondentId = M.RespondentId  
	WHERE P.QuestionTypeId IN(3,6,9,16) AND ISNULL(P.AnswerText,'') <> ''
		
	CREATE TABLE #BaseTextQuestions 
	(
		PercepAnser INT, PerceAnserText NVARCHAR(500), MTBAnser INT, MTBAnserText NVARCHAR(100), SongId INT,
		AnswerText NVARCHAR(500), SessionId VARCHAR(100), QuestionId INT, IsBaseSurvey INT, QuestionTypeId INT,
		QuestionNo INT, QuestionText NVARCHAR(2000)
	)
	INSERT INTO #BaseTextQuestions
	(
		PercepAnser, PerceAnserText, MTBAnser, MTBAnserText, SongId, AnswerText, SessionId, QuestionId, 
		IsBaseSurvey, QuestionTypeId, QuestionNo, QuestionText	
	)
	SELECT 
		PercepAnser, PerceAnserText, MTBAnser, MTBAnserText, SongId, AnswerText, SessionId, QuestionId, 
		IsBaseSurvey, QuestionTypeId, QuestionNo, QuestionText 
	FROM #AllData WHERE QuestionTypeId = 3 AND IsBaseSurvey = 1
	
	UPDATE A 
	SET A.QuestionId = B.QuestionId
	FROM 
	(
		SELECT QuestionId, PerceAnserText FROM #AllData WHERE QuestionTypeId = 3 AND IsBaseSurvey = 0
	) A
	INNER JOIN #BaseTextQuestions B ON A.PerceAnserText = B.PerceAnserText
	
	CREATE TABLE #StableSet 
	(
		PerceAnserText NVARCHAR(500), MTBAnserText NVARCHAR(100), AnsCount INT, SongId INT, QuestionId INT, 
		QuestionNo INT, QuestionTypeId INT, QuestionText NVARCHAR(2000), AnswerText NVARCHAR(1000) 
	)
	INSERT INTO #StableSet
	(
		PerceAnserText, MTBAnserText, AnsCount, SongId, QuestionId, QuestionNo, 
		QuestionTypeId, QuestionText, AnswerText 
	)
	SELECT  
		PerceAnserText, MTBAnserText, COUNT(1) AS AnsCount, SongId, QuestionId, QuestionNo, 
		QuestionTypeId, QuestionText, AnswerText 
	FROM #AllData 
	GROUP BY PerceAnserText, SongId, MTBAnserText, QuestionId, QuestionNo, QuestionTypeId, QuestionText, AnswerText 
-- 0
	SELECT 
		SS.SongId AS SongId, SS.MTBAnserText AS MTBText, SS.AnsCount AS ResCount, SS.PerceAnserText AS BaseOptionName, 
		SS.QuestionId, SS.QuestionNo, SS.QuestionText, SS.AnswerText AS BaseOptionAnswer,
		TSQ.SurveyId, TSQ.IsBaseSurvey
	FROM #StableSet SS
	INNER JOIN #TR_SurveyQuestions TSQ ON SS.QuestionId = TSQ.QuestionId 
	WHERE SS.SongId = CASE WHEN ISNULL(@SongId,0) = 0 THEN SS.SongId ELSE @SongId END
		AND LTRIM(RTRIM(SS.AnswerText)) = LTRIM(RTRIM(ISNULL(@BaseOption,SS.AnswerText)))

	CREATE TABLE #BaseOptionNameCount 
	(
		BaseOptionName NVARCHAR(500), SessionId VARCHAR(100), QuestionId INT, QuestionNo INT, QuestionText NVARCHAR(2000)
	)
	INSERT INTO #BaseOptionNameCount
	(
		BaseOptionName, SessionId, QuestionId, QuestionNo, QuestionText
	)
	SELECT  
		P.AnswerText AS BaseOptionName, P.SessionId, P.QuestionId, P.QuestionNo, P.QuestionText
	FROM #PerceptualResponses P
	LEFT JOIN #TR_TrendOptionMapping TTO
		ON TTO.BaseOptionName = P.AnswerText AND P.QuestionId = TTO.BaseQuestionId
	WHERE P.QuestionTypeId NOT IN(3,6,9,16)	
	GROUP BY P.SessionId, P.AnswerText, P.QuestionId, P.QuestionNo, P.QuestionText 
	
	INSERT INTO #BaseOptionNameCount
	(
		BaseOptionName, SessionId, QuestionId, QuestionNo, QuestionText
	)
	SELECT  
		LEFT(P.QuestionText,10)+	CASE WHEN LEN(P.QuestionText)>10 THEN '...:' ELSE ':' END+P.AnswerText AS BaseOptionName, 
		P.SessionId, P.QuestionId, P.QuestionNo, P.QuestionText
	FROM #PerceptualResponses P
	LEFT JOIN #TR_TrendOptionMapping TTO 
		ON TTO.BaseOptionName = P.AnswerText AND P.QuestionId = TTO.BaseQuestionId
	WHERE P.QuestionTypeId IN(3,6,9,16)
	GROUP BY P.SessionId, P.AnswerText, P.QuestionId, P.QuestionNo, P.QuestionText 
	
	INSERT INTO #BaseOptionNameCount
	(
		BaseOptionName, SessionId, QuestionId, QuestionNo, QuestionText
	)
	SELECT  
		CASE WHEN TTO.OptionName = P.AnswerText THEN TTO.BaseOptionName ELSE P.AnswerText END AS BaseOptionName, 
		P.SessionId, P.QuestionId, P.QuestionNo, P.QuestionText
	FROM #PerceptualResponses P
	LEFT JOIN #TR_TrendOptionMapping TTO 
		ON TTO.OptionName = P.AnswerText AND P.QuestionId = TTO.BaseQuestionId		
	GROUP BY P.SessionId, TTO.OptionName, P.AnswerText, TTO.BaseOptionName, P.QuestionId, P.QuestionNo, P.QuestionText 

	CREATE TABLE #TotBaseCompOptionCount  
	(
		BaseOptionName NVARCHAR(500), MTBText NVARCHAR(200), MTBOptionName NVARCHAR(500), SongId INT, 
		ResCount INT, TotalBaseOptionCount INT, QuestionId INT, QuestionNo VARCHAR(12), QuestionText NVARCHAR(2000)
	)
	INSERT INTO #TotBaseCompOptionCount
	(
		BaseOptionName, MTBText, MTBOptionName, SongId, ResCount, TotalBaseOptionCount, QuestionId, QuestionNo,
		QuestionText
	)
	SELECT 
		DISTINCT
		BaseOptionName, MTBText, MTBOptionName, SongId, ResCount, TotalBaseOptionCount, QuestionId, QuestionNo,
		QuestionText
	FROM
	(
		SELECT 
			TC.BaseOptionName, TC.MTBText, 
			ISNULL(TC.OptionDisplayText,
				CASE WHEN S.QuestionNo = 0 THEN TC.MTBOptionName 
					ELSE '[Q.'+CONVERT(VARCHAR(12),S.QuestionNo)+']. '+TC.MTBOptionName END)  AS MTBOptionName,
			S.SongId, S.AnsCount AS ResCount, 
			ISNULL(TBOC.TotalBaseOptionCount,0) AS TotalBaseOptionCount, S.QuestionId, 
			CASE WHEN ISNULL(TC.OptionDisplayText,'') = '' THEN CONVERT(VARCHAR(12),S.QuestionNo) ELSE '' END AS QuestionNo,
			S.QuestionText
		FROM #StableSet S
		INNER JOIN #TR_TrendCrossTabs TC 
			ON S.PerceAnserText = TC.BaseOptionName 
			AND S.MTBAnserText = TC.MTBText AND S.QuestionId = TC.BaseQuestionId
		LEFT JOIN
		(
			SELECT 
				BaseOptionName, COUNT(1) AS TotalBaseOptionCount, QuestionId
			FROM
			(
				SELECT BaseOptionName, SessionId, QuestionId
				FROM #BaseOptionNameCount GROUP BY BaseOptionName, SessionId, QuestionId
			) A	
			GROUP BY BaseOptionName, QuestionId
		) TBOC
			ON TC.BaseOptionName = TBOC.BaseOptionName AND S.QuestionId = TBOC.QuestionId 
		WHERE S.QuestionTypeId NOT IN(3,6,9,16)
		UNION ALL
		SELECT 
			TC.BaseOptionName, TC.MTBText, 
			ISNULL(TC.OptionDisplayText,
				CASE WHEN S.QuestionNo = 0 THEN TC.MTBOptionName 
					ELSE '[Q.'+CONVERT(VARCHAR(12),S.QuestionNo)+']. '+TC.MTBOptionName END)  AS MTBOptionName,
			S.SongId, S.AnsCount AS ResCount, 
			ISNULL(TBOC.TotalBaseOptionCount,0) AS TotalBaseOptionCount, S.QuestionId, 
			CASE WHEN ISNULL(TC.OptionDisplayText,'') = '' THEN CONVERT(VARCHAR(12),S.QuestionNo) ELSE '' END AS QuestionNo,
			S.QuestionText
		FROM #StableSet S
		INNER JOIN #TR_TrendCrossTabs TC 
			ON '['+CONVERT(VARCHAR(12),S.QuestionNo)+']. '+S.PerceAnserText = TC.BaseOptionName 
			AND S.MTBAnserText = TC.MTBText AND TC.ReportId = @ReportId
			AND S.QuestionId = TC.BaseQuestionId
		LEFT JOIN
		(
			SELECT 
				BaseOptionName, COUNT(1) AS TotalBaseOptionCount, QuestionId
			FROM
			(
				SELECT BaseOptionName, SessionId, QuestionId
				FROM #BaseOptionNameCount GROUP BY BaseOptionName, SessionId, QuestionId
			) A	
			GROUP BY BaseOptionName, QuestionId
		) TBOC
			ON TC.BaseOptionName = TBOC.BaseOptionName AND S.QuestionId = TBOC.QuestionId
		WHERE S.QuestionTypeId IN(3,6,9,16)
		UNION ALL
		SELECT 
			TC.BaseOptionName, TC.MTBText, 
			ISNULL(TC.OptionDisplayText,
				CASE WHEN S.QuestionNo = 0 THEN TC.MTBOptionName 
					ELSE '[Q.'+CONVERT(VARCHAR(12),S.QuestionNo)+']. '+TC.MTBOptionName END)  AS MTBOptionName,
			S.SongId, S.AnsCount AS ResCount, ISNULL(TBOC.TotalBaseOptionCount,0) AS TotalBaseOptionCount, S.QuestionId, 
			CASE WHEN ISNULL(TC.OptionDisplayText,'') = '' THEN CONVERT(VARCHAR(12),S.QuestionNo) ELSE '' END AS QuestionNo,
			S.QuestionText
		FROM #StableSet S
		INNER JOIN #TR_TrendCrossTabs TC 
			ON S.PerceAnserText = TC.BaseOptionName 
			AND S.MTBAnserText = TC.MTBText AND S.QuestionId = TC.BaseQuestionId
		LEFT JOIN
		(
			SELECT 
				BaseOptionName, COUNT(1) AS TotalBaseOptionCount, QuestionId
			FROM
			(
				SELECT BaseOptionName, SessionId, QuestionId
				FROM #BaseOptionNameCount GROUP BY BaseOptionName, SessionId, QuestionId
			) A	
			GROUP BY BaseOptionName, QuestionId
		) TBOC
			ON TC.BaseOptionName = TBOC.BaseOptionName AND S.QuestionId = TBOC.QuestionId
		WHERE S.QuestionTypeId IN(3,6,9,16)
	) A
-- 1		
	SELECT * FROM #TotBaseCompOptionCount 

	CREATE TABLE #TrendPerceptFilter 
	(
		FilterId INT, FilterName NVARCHAR(100), SurveyId INT, ReportId INT, MTBText NVARCHAR(100),
		MTBOptionName NVARCHAR(500), Expression NVARCHAR(500), QuestionId INT, QuestionNo INT
	)
	INSERT INTO #TrendPerceptFilter
	(
		FilterId, FilterName, SurveyId, ReportId, MTBText, MTBOptionName, Expression, QuestionId, QuestionNo
	)
	SELECT 
		DISTINCT 
		MTPF.FilterId, MTPF.FilterName, MTPF.SurveyId, MTPF.ReportId, TTCT.MTBText, TTCT.MTBOptionName, 
		ISNULL(TRC.Expression,'') AS Expression, TTCT.BaseQuestionId, TTCT.QuestionNo
	FROM DBO.MS_TrendPerceptFilter MTPF WITH(NOLOCK)
	INNER JOIN #TR_TrendCrossTabs TTCT 
		ON MTPF.ReportId = TTCT.ReportId AND MTPF.FilterName = TTCT.BaseOptionName
	INNER JOIN DBO.TR_TrendReportColumns TRC WITH(NOLOCK)
		ON TTCT.MTBText = TRC.ColumnName AND MTPF.ReportId = TRC.ReportId 
	 
	CREATE TABLE #TotalBaseOptionCount 
	(
		BaseOptionName NVARCHAR(500), TotalBaseOptionCount INT, QuestionId INT, QuestionNo INT
	)
	INSERT INTO #TotalBaseOptionCount
	(
		BaseOptionName, TotalBaseOptionCount, QuestionId, QuestionNo 
	)
	SELECT 
		TTCT.BaseOptionName, COUNT(1) AS TotalBaseOptionCount, TTCT.BaseQuestionId, TTCT.QuestionNo
	FROM #TR_TrendCrossTabs TTCT
	INNER JOIN DBO.TR_TrendReportColumns TTRC WITH(NOLOCK)
		ON TTCT.ReportId = TTRC.ReportId AND TTCT.MTBText = TTRC.ColumnName
	LEFT JOIN #TrendPerceptFilter TPF 
		ON TTCT.MTBText = TPF.MTBText AND TTCT.MTBOptionName = TPF.MTBOptionName
	WHERE ISNULL(TPF.MTBOptionName,'') = ''
	GROUP BY TTCT.BaseOptionName, TTCT.BaseQuestionId, TTCT.QuestionNo
	
	CREATE TABLE #BaseCompOptionCount  
	(
		BaseSurveyId INT, MTBText NVARCHAR(200), MTBOptionName NVARCHAR(500), BaseOptionName  NVARCHAR(500), 
		Expression NVARCHAR(1000), TotalBaseOptionCount INT, QuestionId INT, QuestionNo INT, 
		QuestionText NVARCHAR(2000), TrendType VARCHAR(10), QuestionTypeId INT
	)
	INSERT INTO #BaseCompOptionCount
	(
		BaseSurveyId, MTBText, MTBOptionName, BaseOptionName, Expression, TotalBaseOptionCount,
		QuestionId, QuestionNo, QuestionText, TrendType, QuestionTypeId
	)
	SELECT 
		DISTINCT
		TTCT.BaseSurveyId, TTCT.MTBText, 
		CASE WHEN ISNULL(TTCT.QuestionNo,0) = 0 THEN ISNULL(TTCT.OptionDisplayText,REPLACE(TTCT.MTBOptionName,'-',':'))
			WHEN LEFT(TTCT.MTBOptionName,3) = '[Q.' THEN ISNULL(TTCT.OptionDisplayText,REPLACE(TTCT.MTBOptionName,'-',':')) 
			ELSE '[Q.'+CONVERT(VARCHAR(12),TTCT.QuestionNo)+']. ' 
				+ISNULL(TTCT.OptionDisplayText,REPLACE(TTCT.MTBOptionName,'-',':')) END AS MTBOptionName,
		TTCT.BaseOptionName, ISNULL(TTRC.Expression,'') AS Expression, 
		ISNULL(BPRC.ResponseCount,TBOC.TotalBaseOptionCount) AS TotalBaseOptionCount,
		TTCT.BaseQuestionId AS QuestionId, TTCT.QuestionNo, TTCT.QuestionText, TTRC.TrendType, 
		TTCT.QuestionTypeId
	FROM #TR_TrendCrossTabs TTCT
	INNER JOIN DBO.TR_TrendReportColumns TTRC WITH(NOLOCK)
		ON TTCT.ReportId = TTRC.ReportId AND TTCT.MTBText = TTRC.ColumnName
	LEFT JOIN #TotalBaseOptionCount TBOC 
		ON TTCT.BaseOptionName = TBOC.BaseOptionName AND TTCT.BaseQuestionId = TBOC.QuestionId
	LEFT JOIN #BasePerceptResponseCount BPRC 
		ON TTCT.BaseOptionName = BPRC.BaseOptionName AND TTCT.BaseQuestionId = BPRC.QuestionId
	LEFT JOIN #TrendPerceptFilter TPF 
		ON TTCT.MTBText = TPF.MTBText AND TTCT.MTBOptionName = TPF.MTBOptionName
	--LEFT JOIN #TR_SurveyQuestions TSQ
	--	ON TTCT.BaseQuestionId = TSQ.QuestionId
	WHERE ISNULL(TPF.MTBOptionName,'') = ''
	
	UPDATE BCOC
	SET BCOC.TotalBaseOptionCount = CHC.TotalBaseOptionCount
	FROM #BaseCompOptionCount BCOC
	INNER JOIN #TotBaseCompOptionCount CHC
		ON BCOC.BaseOptionName = CHC.BaseOptionName
	WHERE BCOC.QuestionTypeId IN(3,9)

-- 2			
	SELECT * FROM #BaseCompOptionCount
	
-- 3	
	SELECT DISTINCT SongId FROM #StableSet
	
	CREATE TABLE #PerceptFilterOptions
	(
		TPFId INT, FilterAnswer NVARCHAR(500), Conjuction VARCHAR(20), FilterName NVARCHAR(100), FilterId INT, 
		Operator VARCHAR(30), QuestionId INT, QuestionTypeId INT, QuestionNo INT, QuestionText NVARCHAR(2000),
		Answer NVARCHAR(1000) 
	)
	INSERT INTO #PerceptFilterOptions
	(
		TPFId, FilterAnswer, Conjuction, FilterName, FilterId, Operator, QuestionId, 
		QuestionTypeId, QuestionNo, QuestionText, Answer
	)
	SELECT 
		TP.TPFId,
		ISNULL(TSA.Answertext,(LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TP.AnswerText)) AS FilterAnswer, 
		TP.Conjuction, MF.FilterName, MF.FilterId, TP.Operator, TP.QuestionId, TSQ.QuestionTypeId,
		TSQ.QuestionNo, TSQ.QuestionText, ISNULL(TSA.Answertext,TP.AnswerText) AS Answer
	FROM DBO.MS_TrendPerceptFilter MF WITH(NOLOCK)
	INNER JOIN DBO.TR_TrendPerceptFilter TP WITH(NOLOCK)
		ON MF.FilterId = TP.FilterId
	LEFT JOIN #TR_SurveyQuestions TSQ 
		ON TP.QuestionId = TSQ.QuestionId
	LEFT JOIN #TR_SurveyAnswers TSA 
		ON TP.AnswerId = TSA.AnswerId
	WHERE MF.ReportId = @ReportId ORDER BY TP.TPFId

-- 4	
	SELECT  
		CD.QuestionId, CD.BaseOptionName, CD.MTBText, CD.SongId, CD.SessionId, CD.ResCount, CD.QuestionNo, 
		CD.QuestionText, CD.BaseOptionAnswer, CD.SurveyId
	FROM 
	(
		SELECT 
			DISTINCT
			CD.QuestionId, CD.PerceAnserText AS BaseOptionName, CD.MTBAnserText AS MTBText, CD.SongId, 
			CD.SessionId+CONVERT(VARCHAR(12),CD.RespondentId) AS SessionId, 1 AS ResCount, CD.QuestionNo, 
			CD.QuestionText, CD.AnswerText AS BaseOptionAnswer, TSQ.SurveyId, TSQ.IsBaseSurvey 
		FROM #AllData CD
		INNER JOIN #TR_SurveyQuestions TSQ
			ON CD.QuestionId = TSQ.QuestionId
	) CD		
	ORDER BY CD.IsBaseSurvey DESC
	
	CREATE TABLE #PerceptFilter 
	(
		FilterId INT, FilterName NVARCHAR(100), SurveyId INT, ReportId INT, MTBText NVARCHAR(50), 
		MTBOptionName NVARCHAR(500), QuestionId INT, QuestionNo INT, OptionDisplayText NVARCHAR(500),
		QuestionText NVARCHAR(2000)
	)
	INSERT INTO #PerceptFilter
	(
		FilterId, FilterName, SurveyId, ReportId, MTBText, MTBOptionName, QuestionId, QuestionNo, 
		OptionDisplayText, QuestionText
	)
	SELECT 
		DISTINCT 
		MTPF.FilterId, MTPF.FilterName, MTPF.SurveyId, MTPF.ReportId, TTCT.MTBText, 
		TTCT.MTBOptionName, TTCT.BaseQuestionId, TTCT.QuestionNo, TTCT.OptionDisplayText, TTCT.QuestionText
	FROM DBO.MS_TrendPerceptFilter MTPF WITH(NOLOCK) 
	INNER JOIN #TR_TrendCrossTabs TTCT 
		ON MTPF.ReportId = TTCT.ReportId 
		AND MTPF.FilterName = TTCT.BaseOptionName
	INNER JOIN DBO.TR_MediaAnswers TM WITH(NOLOCK)
		ON TM.AnswerText = TTCT.MTBText

-- 5
	SELECT 
		PF.FilterId, PF.FilterName, PF.SurveyId, PF.ReportId, PF.MTBText, 
		ISNULL(PF.OptionDisplayText,PF.MTBOptionName) AS MTBOptionName,
		ISNULL(PF1.TotalBaseOptionCount,0) AS TotalBaseOptionCount, PF.QuestionId, 
		ISNULL(PF.QuestionNo,0) AS QuestionNo, PF.QuestionText
	FROM #PerceptFilter PF
	INNER JOIN 
	(
		SELECT
			FilterName, FilterId, COUNT(1) AS TotalBaseOptionCount
		FROM
		(
			SELECT DISTINCT FilterName, FilterId FROM #PerceptFilter
		) A	
		GROUP BY FilterName, FilterId
	) PF1
		ON PF.FilterName = PF1.FilterName AND PF.FilterId = PF1.FilterId

-- 6
	SELECT 
		DISTINCT PFO.TPFId,
		PFO.QuestionId, PFO.QuestionTypeId, PFO.FilterAnswer, ISNULL(PFO.Conjuction,'') AS Conjuction, 
		PFO.Operator, PFO.FilterName, PFO.FilterId, ISNULL(PFO.QuestionNo,0) AS QuestionNo, QuestionText,
		PFO.Answer  
	FROM #PerceptFilterOptions PFO
	ORDER BY PFO.TPFId

-- 7
	SELECT 
		TPF.FilterId, TPF.FilterName, TPF.SurveyId, TPF.ReportId, TPF.MTBText, 
		ISNULL(TPF1.OptionDisplayText,TPF.MTBOptionName) AS MTBOptionName, 
		TPF.Expression, TPF.QuestionId, TPF1.TotalBaseOptionCount, ISNULL(TPF.QuestionNo,0) AS QuestionNo,
		TPF1.QuestionText, ISNULL(TRC.TrendType,'False') AS TrendType  
	FROM #TrendPerceptFilter TPF
	INNER JOIN 
	(
		SELECT 
			ReportId, BaseOptionName, FilterId, FilterName, COUNT(1) AS TotalBaseOptionCount, 
			BaseQuestionId, OptionDisplayText, QuestionText  
		FROM
		(
			SELECT DISTINCT
				MTPF.ReportId, TTCT.BaseOptionName, MTPF.FilterId, MTPF.FilterName, 
				ISNULL(TTCT.BaseQuestionId,0) AS BaseQuestionId, TTCT.OptionDisplayText, TTCT.QuestionText  
			FROM DBO.MS_TrendPerceptFilter MTPF WITH(NOLOCK)
			INNER JOIN #TR_TrendCrossTabs TTCT 
				ON MTPF.ReportId = TTCT.ReportId AND MTPF.FilterName = TTCT.BaseOptionName
			INNER JOIN DBO.TR_TrendReportColumns TRC WITH(NOLOCK)
				ON TTCT.MTBText = TRC.ColumnName AND MTPF.ReportId = TRC.ReportId 
		)	A
		GROUP BY ReportId, BaseOptionName, FilterId, FilterName, 
			BaseQuestionId, OptionDisplayText, QuestionText
	) TPF1
		ON TPF.ReportId = TPF1.ReportId AND TPF.FilterId = TPF1.FilterId
	LEFT JOIN DBO.TR_TrendReportColumns TRC WITH(NOLOCK)
		ON TPF.MTBText = TRC.ColumnName AND TPF.ReportId = TRC.ReportId  

-- 8	
	SELECT DISTINCT SurveyId FROM 
	(
		SELECT BaseSurveyId AS SurveyId FROM DBO.TR_Trends WITH(NOLOCK) WHERE ReportId = @ReportId
		UNION ALL
		SELECT SurveyId FROM DBO.TR_Trends WITH(NOLOCK) WHERE ReportId = @ReportId
	) Su
	WHERE SurveyId IS NOT NULL
			
	--DROP TABLE #TR_SurveyQuestions
	--DROP TABLE #TR_SurveyAnswers
	--DROP TABLE #TR_Responses
	--DROP TABLE #PerceptualResponses
	--DROP TABLE #PerceptResponseCount
	--DROP TABLE #BasePerceptResponseCount
	--DROP TABLE #MTBResponses  
	--DROP TABLE #AllData
	--DROP TABLE #BaseTextQuestions
	--DROP TABLE #TrendPerceptFilter
	--DROP TABLE #PerceptFilterOptions
	--DROP TABLE #StableSet
	--DROP TABLE #BaseOptionNameCount
	--DROP TABLE #TotalBaseOptionCount 
	--DROP TABLE #PerceptFilter 
	--DROP TABLE #TR_TrendCrossTabs
	--DROP TABLE #TR_TrendOptionMapping
	--DROP TABLE #TotBaseCompOptionCount  
	--DROP TABLE #BaseCompOptionCount 

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage,ERROR_LINE() as LineNum
END CATCH 

SET NOCOUNT OFF
END

