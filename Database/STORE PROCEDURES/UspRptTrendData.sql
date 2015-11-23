IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptTrendData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspRptTrendData

GO  
-- EXEC UspRptTrendData @ReportId='317',@CompareSurveyId='0',@AnswerText='Positive',@SongId='0',@BaseDemo='Male'
-- UspRptTrendData 488,0,NULL,0, 'All'
-- UspRptTrendData 116,1213,'Love it',0

CREATE PROCEDURE [dbo].[UspRptTrendData]
	@ReportId INT,
	@CompareSurveyId INT,
	@AnswerText NVARCHAR(100),
	@SongId INT,
	@BaseDemo NVARCHAR(150)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SET @AnswerText = REPLACE(REPLACE(@AnswerText,'~N',''),'~Y','')

	DECLARE @xmlResult XML
	DECLARE @IsCal VARCHAR(1)

	IF EXISTS(SELECT 1 FROM DBO.TR_TrendReportColumns WHERE ReportId = @ReportId AND LTRIM(RTRIM(ColumnName)) = @AnswerText) 
	BEGIN
		SET @IsCal = 'Y'
	END
	ELSE
	BEGIN
		SET @IsCal = 'N'
	END

	-- 1st Step Get Base SurveId on Base of ReportId
	DECLARE @BaseSurveyId INT
	SELECT @BaseSurveyId = BaseSurveyId FROM DBO.TR_Trends WHERE ReportId = @ReportId
	
	-- 2nd Step Get Compare Survey Id on Base of ReportId and BaseSurveyId
	--------------------------------------------------------------------------------
	CREATE TABLE #CompareSurveyId
	(RowId INT IDENTITY(1,1), CompareSurveyId INT, CompareSurveyName NVARCHAR(50))
	INSERT INTO #CompareSurveyId
	(CompareSurveyId, CompareSurveyName)
	SELECT TT.SurveyId, TS.SurveyName 
	FROM DBO.TR_Trends TT 
	INNER JOIN DBO.TR_Survey TS
		ON TT.SurveyId = TS.SurveyId AND TT.ReportId = @ReportId AND TT.BaseSurveyId = @BaseSurveyId
		AND TT.SurveyId = CASE WHEN @CompareSurveyId = 0 THEN TT.SurveyId ELSE @CompareSurveyId END

	-- 3rd Step Get all Response data and its Media Response count of Base Survey Id in 2 diff. Hash Table
	--------------------------------------------------------------------------------
	CREATE TABLE #BaseSurveyResponse
	(
		SurveyId INT, Title VARCHAR(100), Artist VARCHAR(100), FileLibYear VARCHAR(4), QuestionId INT, 
		AnswerId INT, AnswerText NVARCHAR(100), RespondentId INT, SessionId VARCHAR(100), SongId INT
	)
	CREATE TABLE #BaseSong
	(SurveyId INT, SessionId VARCHAR(100))
		
	CREATE TABLE #BaseSplitQueAns
	(RowId INT, Value VARCHAR(1000))
	
	CREATE TABLE #BaseSurveyResponseCount
	(
		Title VARCHAR(100), Artist VARCHAR(100), FileLibYear VARCHAR(4), BaseResponseCount INT, 
		SongId INT, AnswerId INT, AnswerText NVARCHAR(100), BaseSurveyId INT
	)
		
	CREATE TABLE #CompareSurveyResponse
	(
		CompareSurveyId INT, CompareSurveyName NVARCHAR(100), QuestionId INT, AnswerId INT, AnswerText NVARCHAR(100),
		RespondentId INT, SessionId VARCHAR(100), SongId INT
	)	
	
	CREATE TABLE #CompareSong
	(SurveyId INT, SessionId VARCHAR(100))
	
	CREATE TABLE #CompareSplitQueAns
	(RowId INT, Value VARCHAR(1000))
	
	CREATE TABLE #CompareSurveyResponseCount
	(
		ResponseCount INT, CompareSurveyId INT, CompareSurveyName NVARCHAR(100), SongId INT, 
		AnswerId INT, AnswerText NVARCHAR(100)
	)
		
	CREATE TABLE #SongCount
	(
		[Rank] INT IDENTITY(1,1), SongId INT, BaseResponseCount INT, Title VARCHAR(100), Artist VARCHAR(100), FileLibYear VARCHAR(4)
	)
	
	CREATE TABLE #BaseSurveyResponseCount1
	(
		RowNo INT IDENTITY(1,1), Title VARCHAR(100), Artist VARCHAR(100), FileLibYear VARCHAR(4), BaseResponseCount INT, 
		SongId INT, AnswerId INT, AnswerText NVARCHAR(100), BaseSurveyId INT
	)

	IF ISNULL(@BaseDemo,'All') = 'All'
	BEGIN	
		INSERT INTO #BaseSurveyResponse
		(
			SurveyId, Title, Artist, FileLibYear, QuestionId, AnswerId, AnswerText, RespondentId, 
			SessionId, SongId	
		)
		SELECT 
			TSQ.SurveyId, TSCI.Title, TSCI.Artist, TSCI.FileLibYear, TR.QuestionId, TR.AnswerId, TMA.AnswerText,
			TR.RespondentId, TR.SessionId, TR.SongId
		FROM DBO.TR_Responses TR 
		INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId 
			AND TSQ.SurveyId = @BaseSurveyId AND TR.[Status] = 'C' 
		INNER JOIN DBO.TR_QuestionSettings TQS ON TSQ.QuestionId = TQS.QuestionId
		INNER JOIN DBO.MS_QuestionSettings MQS ON TQS.SettingId = MQS.SettingId
			AND MQS.SettingName IN('IsMTBQuestion','PlayListId','HasMedia') AND TQS.Value NOT IN ('False','','0')
		INNER JOIN DBO.TR_MediaAnswers TMA ON TR.AnswerId = TMA.AnswerId
		INNER JOIN DBO.TR_SoundClipInfo TSCI ON TSCI.FileLibId = TR.SongId
		GROUP BY TSQ.SurveyId, TSCI.Title, TSCI.Artist, TSCI.FileLibYear, TR.QuestionId,TR.AnswerId, TMA.AnswerText,TR.RespondentId,TR.SessionId,TR.SongId
		ORDER BY TR.SongId,TMA.AnswerText
	END
	ELSE
	BEGIN
		IF @BaseDemo LIKE '%~%'
		BEGIN
			INSERT INTO #BaseSplitQueAns
			(RowId, Value)
			SELECT * FROM [dbo].[Split] ('~',@BaseDemo)
			
			INSERT INTO #BaseSong
			(SurveyId, SessionId)
			SELECT 
				DISTINCT TSQ.SurveyId, TR.SessionId
			FROM DBO.TR_Responses TR 
			INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId 
				AND TSQ.SurveyId = @BaseSurveyId AND TR.Status = 'C'
			INNER JOIN 
			(
				SELECT Value AS QuestionId FROM #BaseSplitQueAns WHERE RowId = 1
			) SQ  
				ON CONVERT(VARCHAR(12),TR.QuestionId) = SQ.QuestionId
			INNER JOIN 
			(
				SELECT Value AS AnswerText FROM #BaseSplitQueAns WHERE RowId = 2
			) SA 
				ON LTRIM(RTRIM(TR.AnswerText)) = LTRIM(RTRIM(SA.AnswerText))
		END
		ELSE
		BEGIN
			INSERT INTO #BaseSong
			(SurveyId, SessionId)
			SELECT 
				DISTINCT TSQ.SurveyId, TR.SessionId
			FROM DBO.TR_Responses TR 
			INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId 
				AND TSQ.SurveyId = @BaseSurveyId AND TR.Status = 'C'
			INNER JOIN DBO.TR_SurveyAnswers TSA ON TR.QuestionId = TSA.QuestionId AND TR.AnswerId = TSA.AnswerId
			WHERE LTRIM(RTRIM(TSA.AnswerText)) = LTRIM(RTRIM(@BaseDemo))  	
		END
	
		INSERT INTO #BaseSurveyResponse
		(SurveyId, Title, Artist, FileLibYear, QuestionId, AnswerId, AnswerText, RespondentId, SessionId, SongId)
		SELECT 
			TSQ.SurveyId, TSCI.Title, TSCI.Artist, TSCI.FileLibYear, TR.QuestionId, TR.AnswerId, TMA.AnswerText,
			TR.RespondentId, TR.SessionId, TR.SongId
		FROM DBO.TR_Responses TR 
		INNER JOIN #BaseSong BS ON TR.SessionId = BS.SessionId AND TR.Status = 'C'
		INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @BaseSurveyId 
		INNER JOIN DBO.TR_QuestionSettings TQS ON TSQ.QuestionId = TQS.QuestionId
		INNER JOIN DBO.MS_QuestionSettings MQS ON TQS.SettingId = MQS.SettingId
			AND MQS.SettingName IN('IsMTBQuestion','PlayListId','HasMedia') AND TQS.Value NOT IN ('False','','0')
		INNER JOIN DBO.TR_MediaAnswers TMA ON TR.AnswerId = TMA.AnswerId
		INNER JOIN DBO.TR_SoundClipInfo TSCI ON TSCI.FileLibId = TR.SongId
		GROUP BY TSQ.SurveyId, TSCI.Title, TSCI.Artist, TSCI.FileLibYear, TR.QuestionId,TR.AnswerId, TMA.AnswerText,TR.RespondentId,TR.SessionId,TR.SongId
		ORDER BY TR.SongId,TMA.AnswerText
	END

	IF ISNULL(@IsCal,'N') = 'N'
	BEGIN
		--------------------------------------------------------------------------------
		INSERT INTO #BaseSurveyResponseCount
		(Title, Artist, FileLibYear, BaseResponseCount, SongId, AnswerId, AnswerText, BaseSurveyId)
		SELECT 
			Title, Artist, FileLibYear, COUNT(1) AS BaseResponseCount, SongId, AnswerId, 
			AnswerText, SurveyId AS BaseSurveyId
		FROM #BaseSurveyResponse 
		GROUP BY SurveyId, SongId, AnswerId, AnswerText, Title, Artist, FileLibYear

		-- 4th Step Get all Compare data and its Media Response count of Compare Survey Id in 2 diff. Hash Table
		--------------------------------------------------------------------------------
		IF ISNULL(@BaseDemo,'All') = 'All'
		BEGIN	
			INSERT INTO #CompareSurveyResponse
			(CompareSurveyId, CompareSurveyName, QuestionId, AnswerId, AnswerText, RespondentId, SessionId, SongId)
			SELECT 
				CSI.CompareSurveyId, CSI.CompareSurveyName, TR.QuestionId, TR.AnswerId, TMA.AnswerText,
				TR.RespondentId, TR.SessionId, TR.SongId
			FROM DBO.TR_Responses TR
			INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId AND TR.[Status] = 'C'
			INNER JOIN #CompareSurveyId CSI ON TSQ.SurveyId = CSI.CompareSurveyId
			INNER JOIN DBO.TR_QuestionSettings TQS ON TSQ.QuestionId = TQS.QuestionId
			INNER JOIN DBO.MS_QuestionSettings MQS ON TQS.SettingId = MQS.SettingId
				AND MQS.SettingName IN('IsMTBQuestion','PlayListId','HasMedia') AND TQS.Value NOT IN ('False','','0')
			INNER JOIN DBO.TR_MediaAnswers TMA ON TR.AnswerId = TMA.AnswerId
			WHERE CSI.CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CSI.CompareSurveyId ELSE @CompareSurveyId END
				AND TMA.AnswerText = CASE WHEN ISNULL(@AnswerText,'') = '' THEN TMA.AnswerText ELSE @AnswerText END
			GROUP BY CSI.CompareSurveyId, CSI.CompareSurveyName, TR.QuestionId,TR.AnswerId, TMA.AnswerText,TR.RespondentId,TR.SessionId,TR.SongId
			ORDER BY TR.SongId,TMA.AnswerText
		END
		ELSE
		BEGIN
			IF @BaseDemo LIKE '%~%'
			BEGIN
				INSERT INTO #CompareSplitQueAns
				(RowId, Value)
				SELECT * FROM [dbo].[Split] ('~',@BaseDemo)
				
				INSERT INTO #CompareSong
				(SurveyId, SessionId)
				SELECT 
					DISTINCT TSQ.SurveyId, TR.SessionId
				FROM DBO.TR_Responses TR 
				INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId AND TR.[Status] = 'C'
				INNER JOIN #CompareSurveyId CSI ON TSQ.SurveyId = CSI.CompareSurveyId 
				INNER JOIN 
				(
					SELECT Value AS QuestionId FROM #CompareSplitQueAns WHERE RowId = 1
				) SQ  
					ON CONVERT(VARCHAR(12),TR.QuestionId) = SQ.QuestionId
				INNER JOIN 
				(
					SELECT Value AS AnswerText FROM #CompareSplitQueAns WHERE RowId = 2
				) SA 
					ON LTRIM(RTRIM(TR.AnswerText)) = LTRIM(RTRIM(SA.AnswerText))
			END
			ELSE
			BEGIN
				INSERT INTO #CompareSong
				(SurveyId, SessionId)
				SELECT 
					DISTINCT CSI.CompareSurveyId, TR.SessionId
				FROM DBO.TR_Responses TR
				INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId AND TR.[Status] = 'C'
				INNER JOIN #CompareSurveyId CSI ON TSQ.SurveyId = CSI.CompareSurveyId
				INNER JOIN DBO.TR_SurveyAnswers TSA ON TR.QuestionId = TSA.QuestionId AND TR.AnswerId = TSA.AnswerId
				INNER JOIN DBO.TR_Trends TT ON TT.SurveyId = CSI.CompareSurveyId
				INNER JOIN DBO.TR_TrendOptionMapping TTOM ON TT.TrendId = TTOM.TrendId 
					AND LTRIM(RTRIM(TSA.AnswerText)) = LTRIM(RTRIM(TTOM.OptionName)) AND TTOM.BaseOptionName = @BaseDemo 
				WHERE CSI.CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CSI.CompareSurveyId ELSE @CompareSurveyId END
					--AND TSA.AnswerText = CASE WHEN ISNULL(@AnswerText,'') = '' THEN TSA.AnswerText ELSE @AnswerText END
					AND TT.ReportId = @ReportId
			END
		
			INSERT INTO #CompareSurveyResponse
			(CompareSurveyId, CompareSurveyName, QuestionId, AnswerId, AnswerText, RespondentId, SessionId, SongId)
			SELECT 
				CSI.CompareSurveyId, CSI.CompareSurveyName, TR.QuestionId, TR.AnswerId, TMA.AnswerText,
				TR.RespondentId, TR.SessionId, TR.SongId
			FROM DBO.TR_Responses TR
			INNER JOIN #CompareSong CS ON TR.SessionId = CS.SessionId AND TR.[Status] = 'C'
			INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId
			INNER JOIN #CompareSurveyId CSI ON TSQ.SurveyId = CSI.CompareSurveyId
			INNER JOIN DBO.TR_QuestionSettings TQS ON TSQ.QuestionId = TQS.QuestionId
			INNER JOIN DBO.MS_QuestionSettings MQS ON TQS.SettingId = MQS.SettingId
				AND MQS.SettingName IN('IsMTBQuestion','PlayListId','HasMedia') AND TQS.Value NOT IN ('False','','0')
			INNER JOIN DBO.TR_MediaAnswers TMA ON TR.AnswerId = TMA.AnswerId
			WHERE CSI.CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CSI.CompareSurveyId ELSE @CompareSurveyId END
				AND TMA.AnswerText = CASE WHEN ISNULL(@AnswerText,'') = '' THEN TMA.AnswerText ELSE @AnswerText END
			GROUP BY CSI.CompareSurveyId, CSI.CompareSurveyName, TR.QuestionId,TR.AnswerId, TMA.AnswerText,TR.RespondentId,TR.SessionId,TR.SongId
			ORDER BY TR.SongId,TMA.AnswerText
		END
		
		INSERT INTO #CompareSurveyResponseCount
		(ResponseCount, CompareSurveyId, CompareSurveyName, SongId, AnswerId, AnswerText)
		SELECT 
			COUNT(1) AS ResponseCount, CompareSurveyId, CompareSurveyName, SongId, AnswerId, AnswerText
		FROM #CompareSurveyResponse 
		WHERE CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CompareSurveyId ELSE @CompareSurveyId END
			AND AnswerText = CASE WHEN ISNULL(@AnswerText,'') = '' THEN AnswerText ELSE @AnswerText END
		GROUP BY CompareSurveyId, CompareSurveyName, SongId, AnswerId, AnswerText
		
		--------------------------------------------------------------------------------
 		
 		INSERT INTO #SongCount
 		(SongId, BaseResponseCount, Title, Artist, FileLibYear)
 		SELECT 
 			SongId, COUNT(BaseResponseCount) AS BaseResponseCount, 
 			ISNULL(Title,'') AS Title, ISNULL(Artist,'') AS Artist, 
 			CASE WHEN ISNULL(FileLibYear,'') = '' THEN '0000' ELSE FileLibYear END AS FileLibYear
		FROM #BaseSurveyResponseCount
		GROUP BY SongId, ISNULL(Title,''), ISNULL(Artist,''), FileLibYear  
		ORDER BY COUNT(BaseResponseCount) DESC
		
		--------------------------------------------------------------------------------
 		INSERT INTO #BaseSurveyResponseCount1
 		(
 			Title, Artist, FileLibYear, BaseResponseCount, SongId, AnswerId, AnswerText, BaseSurveyId
		)
 		SELECT  
			Title, Artist, FileLibYear, BaseResponseCount, SongId, AnswerId, AnswerText, BaseSurveyId
		FROM #BaseSurveyResponseCount 
		WHERE AnswerText = CASE WHEN ISNULL(@AnswerText,'') = '' THEN AnswerText ELSE @AnswerText END
		ORDER BY BaseResponseCount DESC, Title ASC

		SET @XmlResult =
		(
			SELECT 
			(
				SELECT
				(
					SELECT 
					(
						SELECT S.[Rank], S.SongId, S.Title, S.Artist, S.FileLibYear AS [Year], '' AS Category
						FOR XML PATH(''), TYPE
					),
					(
						SELECT
						(
							SELECT
							(
								SELECT 
								(
									SELECT BSRC.BaseSurveyId AS SurveyId, 'True' AS IsBase, BSRC.AnswerText AS MtbOption, MAX(BSRC.BaseResponseCount) AS [Count]
									FROM #BaseSurveyResponseCount1 BSRC
									WHERE BSRC.SongId = S.SongId
									    AND BSRC.BaseSurveyId = CASE WHEN @CompareSurveyId = 0 THEN BSRC.BaseSurveyId ELSE @CompareSurveyId END
										AND BSRC.AnswerText = CASE WHEN ISNULL(@AnswerText,'') = '' THEN BSRC.AnswerText ELSE @AnswerText END
									GROUP BY BSRC.BaseSurveyId, BSRC.AnswerText
									FOR XML PATH('MtbScore'), TYPE
								),
								(
									SELECT CSRC.CompareSurveyId AS SurveyId, 'False' AS IsBase, CSRC.AnswerText AS MtbOption, MAX(CSRC.ResponseCount) AS [Count]
									FROM #CompareSurveyResponseCount CSRC
									WHERE CSRC.SongId = S.SongId
										AND CSRC.CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CSRC.CompareSurveyId ELSE @CompareSurveyId END
										AND CSRC.AnswerText = CASE WHEN ISNULL(@AnswerText,'') = '' THEN CSRC.AnswerText ELSE @AnswerText END
									GROUP BY CSRC.CompareSurveyId, CSRC.AnswerText
									FOR XML PATH('MtbScore'), TYPE
								) 
								FOR XML PATH(''), TYPE
							)
						) 
						FOR XML PATH('Scores'), TYPE
					), 
					(
						SELECT 
						(
							SELECT 
								REPLACE(TTCT.BaseOptionName,'-','~')+'-'+TTCT.MTBText AS [Name],
								0 AS [Count], LOWER(TTCT.TrendType) AS TrendType,
								TTCT.BaseQuestionId AS QuestionId, TSQ.QuestionNo
							FROM DBO.TR_TrendCrossTabs TTCT
							LEFT JOIN DBO.TR_SurveyQuestions TSQ
								ON TTCT.BaseQuestionId = TSQ.QuestionId
							WHERE TTCT.ReportId = @ReportId
							FOR XML PATH('CrossTab'), TYPE
						)
						FOR XML PATH('CrossTabs'), TYPE
					)
					FOR XML PATH(''), TYPE
				) 
				FOR XML PATH('Song'), TYPE
			)	
			FROM #SongCount S
			WHERE S.SongId = CASE WHEN @SongId = 0 THEN S.SongId ELSE @SongId END 
			FOR XML PATH(''), ROOT('ArrayOfSong')
		)
		
		SELECT @XmlResult AS XmlResult
	END
	ELSE
	BEGIN
		DECLARE @Expression VARCHAR(1000), @Expression1 VARCHAR(1000)
		SELECT @Expression = Expression FROM DBO.TR_TrendReportColumns 
		WHERE ReportId = @ReportId AND LTRIM(RTRIM(ColumnName)) = LTRIM(RTRIM(@AnswerText))
		
		SET @Expression1 = REPLACE(REPLACE(@Expression,'[',''),']','')
		
		CREATE TABLE #AnswerExpression
		(ReportId INT, AnswerId INT, AnswerText NVARCHAR(100))
		INSERT INTO #AnswerExpression
		(ReportId, AnswerText)
		SELECT
			ReportId, AnswerText
		FROM
		(
			SELECT @ReportId AS ReportId, CASE WHEN @Expression1 LIKE '%Love it%' THEN 'Love it' ELSE '' END AS AnswerText
			UNION
			SELECT @ReportId AS ReportId, CASE WHEN @Expression1 LIKE '%Like it%' THEN 'Like it'  ELSE '' END AS AnswerText
			UNION
			SELECT @ReportId AS ReportId, CASE WHEN @Expression1 LIKE '%Just OK%' THEN 'Just OK'  ELSE '' END AS AnswerText
			UNION
			SELECT @ReportId AS ReportId, CASE WHEN @Expression1 LIKE '%Tired of%' THEN 'Tired of'  ELSE '' END AS AnswerText
			UNION
			SELECT @ReportId AS ReportId, CASE WHEN @Expression1 LIKE '%Hate it%' THEN 'Hate it'  ELSE '' END AS AnswerText
			UNION
			SELECT @ReportId AS ReportId, CASE WHEN @Expression1 LIKE '%I don''t know this song%' THEN 'I don''t know this song'  ELSE '' END AS AnswerText 
		) Ex
		WHERE AnswerText <> ''
			
		--------------------------------------------------------------------------------
		INSERT INTO #BaseSurveyResponseCount
		(Title, Artist, FileLibYear, BaseResponseCount, SongId, AnswerId, AnswerText, BaseSurveyId)
		SELECT 
			BSR.Title, BSR.Artist, BSR.FileLibYear, COUNT(1) AS BaseResponseCount, BSR.SongId, BSR.AnswerId, 
			BSR.AnswerText, BSR.SurveyId AS BaseSurveyId
		FROM #BaseSurveyResponse BSR
		INNER JOIN #AnswerExpression AE ON BSR.AnswerText = AE.AnswerText
		GROUP BY BSR.SurveyId, BSR.SongId, BSR.AnswerId, BSR.AnswerText, BSR.Title, BSR.Artist, BSR.FileLibYear

		-- 4th Step Get all Compare data and its Media Response count of Compare Survey Id in 2 diff. Hash Table
		--------------------------------------------------------------------------------
		IF ISNULL(@BaseDemo,'All') = 'All'
		BEGIN	
			INSERT INTO #CompareSurveyResponse
			(CompareSurveyId, CompareSurveyName, QuestionId, AnswerId, AnswerText, RespondentId, SessionId, SongId)
			SELECT 
				CSI.CompareSurveyId, CSI.CompareSurveyName, TR.QuestionId, TR.AnswerId, TMA.AnswerText,
				TR.RespondentId, TR.SessionId, TR.SongId
			FROM DBO.TR_Responses TR
			INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId AND TR.[Status] = 'C'
			INNER JOIN #CompareSurveyId CSI ON TSQ.SurveyId = CSI.CompareSurveyId
			INNER JOIN DBO.TR_QuestionSettings TQS ON TSQ.QuestionId = TQS.QuestionId
			INNER JOIN DBO.MS_QuestionSettings MQS ON TQS.SettingId = MQS.SettingId
				AND MQS.SettingName IN('IsMTBQuestion','PlayListId','HasMedia') AND TQS.Value NOT IN ('False','','0')
			INNER JOIN DBO.TR_MediaAnswers TMA ON TR.AnswerId = TMA.AnswerId
			INNER JOIN #AnswerExpression AE ON TMA.Answer = AE.AnswerText
			WHERE CSI.CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CSI.CompareSurveyId ELSE @CompareSurveyId END
			GROUP BY CSI.CompareSurveyId, CSI.CompareSurveyName, TR.QuestionId,TR.AnswerId, TMA.AnswerText,TR.RespondentId,TR.SessionId,TR.SongId
			ORDER BY TR.SongId,TMA.AnswerText
		END
		ELSE
		BEGIN
			IF @BaseDemo LIKE '%~%'
			BEGIN
				INSERT INTO #CompareSplitQueAns
				(RowId, Value)
				SELECT * FROM [dbo].[Split] ('~',@BaseDemo)
				
				INSERT INTO #CompareSong
				(SurveyId, SessionId)
				SELECT 
					DISTINCT TSQ.SurveyId, TR.SessionId
				FROM DBO.TR_Responses TR 
				INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId AND TR.[Status] = 'C'
				INNER JOIN #CompareSurveyId CSI ON TSQ.SurveyId = CSI.CompareSurveyId 
				INNER JOIN 
				(
					SELECT Value AS QuestionId FROM #CompareSplitQueAns WHERE RowId = 1
				) SQ  
					ON CONVERT(VARCHAR(12),TR.QuestionId) = SQ.QuestionId
				INNER JOIN 
				(
					SELECT Value AS AnswerText FROM #CompareSplitQueAns WHERE RowId = 2
				) SA 
					ON LTRIM(RTRIM(TR.AnswerText)) = LTRIM(RTRIM(SA.AnswerText))
			END
			ELSE
			BEGIN
				INSERT INTO #CompareSong
				(SurveyId, SessionId)
				SELECT 
					DISTINCT CSI.CompareSurveyId, TR.SessionId
				FROM DBO.TR_Responses TR
				INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId AND TR.[Status] = 'C'
				INNER JOIN #CompareSurveyId CSI ON TSQ.SurveyId = CSI.CompareSurveyId
				INNER JOIN DBO.TR_SurveyAnswers TSA ON TR.QuestionId = TSA.QuestionId AND TR.AnswerId = TSA.AnswerId
				INNER JOIN DBO.TR_Trends TT ON TT.SurveyId = CSI.CompareSurveyId
				INNER JOIN DBO.TR_TrendOptionMapping TTOM ON TT.TrendId = TTOM.TrendId 
					AND LTRIM(RTRIM(TSA.AnswerText)) = LTRIM(RTRIM(TTOM.OptionName)) AND TTOM.BaseOptionName = @BaseDemo 
				WHERE CSI.CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CSI.CompareSurveyId ELSE @CompareSurveyId END
					AND TT.ReportId = @ReportId
			END
		
			INSERT INTO #CompareSurveyResponse
			(CompareSurveyId, CompareSurveyName, QuestionId, AnswerId, AnswerText, RespondentId, SessionId, SongId)
			SELECT 
				CSI.CompareSurveyId, CSI.CompareSurveyName, TR.QuestionId, TR.AnswerId, TMA.AnswerText,
				TR.RespondentId, TR.SessionId, TR.SongId
			FROM DBO.TR_Responses TR
			INNER JOIN #CompareSong CS ON TR.SessionId = CS.SessionId AND TR.[Status] = 'C'
			INNER JOIN DBO.TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId
			INNER JOIN #CompareSurveyId CSI ON TSQ.SurveyId = CSI.CompareSurveyId
			INNER JOIN DBO.TR_QuestionSettings TQS ON TSQ.QuestionId = TQS.QuestionId
			INNER JOIN DBO.MS_QuestionSettings MQS ON TQS.SettingId = MQS.SettingId
				AND MQS.SettingName IN('IsMTBQuestion','PlayListId','HasMedia') AND TQS.Value NOT IN ('False','','0')
			INNER JOIN DBO.TR_MediaAnswers TMA ON TR.AnswerId = TMA.AnswerId
			INNER JOIN #AnswerExpression AE ON TMA.Answer = AE.AnswerText
			WHERE CSI.CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CSI.CompareSurveyId ELSE @CompareSurveyId END
			GROUP BY CSI.CompareSurveyId, CSI.CompareSurveyName, TR.QuestionId,TR.AnswerId, TMA.AnswerText,TR.RespondentId,TR.SessionId,TR.SongId
			ORDER BY TR.SongId,TMA.AnswerText
		END
		
		INSERT INTO #CompareSurveyResponseCount
		(ResponseCount, CompareSurveyId, CompareSurveyName, SongId, AnswerId, AnswerText)
		SELECT 
			COUNT(1) AS ResponseCount, CompareSurveyId, CompareSurveyName, SongId, AnswerId, AnswerText
		FROM #CompareSurveyResponse 
		WHERE CompareSurveyId = CASE WHEN @CompareSurveyId = 0 THEN CompareSurveyId ELSE @CompareSurveyId END
		GROUP BY CompareSurveyId, CompareSurveyName, SongId, AnswerId, AnswerText
		
		--------------------------------------------------------------------------------
 		
 		INSERT INTO #SongCount
 		(SongId, BaseResponseCount, Title, Artist, FileLibYear)
 		SELECT 
 			SongId, COUNT(BaseResponseCount) AS BaseResponseCount, 
 			ISNULL(Title,'') AS Title, ISNULL(Artist,'') AS Artist, 
 			CASE WHEN ISNULL(FileLibYear,'') = '' THEN '0000' ELSE FileLibYear END AS FileLibYear
		FROM #BaseSurveyResponseCount
		GROUP BY SongId, ISNULL(Title,''), ISNULL(Artist,''), FileLibYear  
		ORDER BY COUNT(BaseResponseCount) DESC
		
		--------------------------------------------------------------------------------
 		INSERT INTO #BaseSurveyResponseCount1
 		(
 			Title, Artist, FileLibYear, BaseResponseCount, SongId, AnswerId, AnswerText, BaseSurveyId
		)
 		SELECT  
			Title, Artist, FileLibYear, BaseResponseCount, SongId, AnswerId, AnswerText, BaseSurveyId
		FROM #BaseSurveyResponseCount 
		ORDER BY BaseResponseCount DESC, Title ASC

		--- Code for Calculation
		CREATE TABLE #BaseExpressionCount
		(
			RowId INT IDENTITY(1,1), SongId INT, SurveyId INT, IsBase VARCHAR(5), MtbOption NVARCHAR(100), 
			[Count] INT, Expression NVARCHAR(1000), ExpressionCount NVARCHAR(1000) 
		)
		CREATE TABLE #CompareExpressionCount
		(
			RowId INT IDENTITY(1,1), SongId INT, SurveyId INT, IsBase VARCHAR(5), MtbOption NVARCHAR(100), 
			[Count] INT, Expression NVARCHAR(1000), ExpressionCount NVARCHAR(1000) 
		)
		
		CREATE TABLE #CountAnswer
		(CountAnswer NVARCHAR(50))
		
		DECLARE @MinRow INT
		DECLARE @MaxRow INT
		DECLARE @BaseExpRowId INT
		DECLARE @AnsExpression NVARCHAR(1000)
		
		SET @MinRow = 1
		SELECT @MaxRow = MAX([Rank]) FROM #SongCount  
		
		WHILE @MinRow <= @MaxRow
		BEGIN
			INSERT INTO #BaseExpressionCount
			(SongId, SurveyId, IsBase, MtbOption, [Count], Expression, ExpressionCount)
			SELECT 
				DISTINCT SC.SongId, BSRC.BaseSurveyId, 'True' AS IsBase, @AnswerText, 0 AS [Count], 
				@Expression1, 'SELECT '+@Expression1 
			FROM #SongCount SC 
			INNER JOIN #BaseSurveyResponseCount1 BSRC
				ON SC.SongId = BSRC.SongId
			WHERE SC.[Rank] = @MinRow

			SET @BaseExpRowId = @@IDENTITY

			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Love it',CONVERT(VARCHAR(12),BSRC.BaseResponseCount))
			FROM #BaseExpressionCount BEC
			INNER JOIN #BaseSurveyResponseCount1 BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Love it'
			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Like it',CONVERT(VARCHAR(12),BSRC.BaseResponseCount))
			FROM #BaseExpressionCount BEC
			INNER JOIN #BaseSurveyResponseCount1 BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Like it'
			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Just OK',CONVERT(VARCHAR(12),BSRC.BaseResponseCount))
			FROM #BaseExpressionCount BEC
			INNER JOIN #BaseSurveyResponseCount1 BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Just OK'
			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Tired of',CONVERT(VARCHAR(12),BSRC.BaseResponseCount))
			FROM #BaseExpressionCount BEC
			INNER JOIN #BaseSurveyResponseCount1 BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Tired of'
			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Hate it',CONVERT(VARCHAR(12),BSRC.BaseResponseCount))
			FROM #BaseExpressionCount BEC
			INNER JOIN #BaseSurveyResponseCount1 BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Hate it'
 			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'I don''t know this song',CONVERT(VARCHAR(12),BSRC.BaseResponseCount))
			FROM #BaseExpressionCount BEC
			INNER JOIN #BaseSurveyResponseCount1 BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'I don''t know this song'
			
			SET @MinRow = @MinRow+1
		END		
		
		UPDATE #BaseExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Love it','0')
		UPDATE #BaseExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Like it','0')
		UPDATE #BaseExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Just OK','0')
		UPDATE #BaseExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Tired of','0')
		UPDATE #BaseExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Hate it','0')
		UPDATE #BaseExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'I don''t know this song','0')
		
		SET @MinRow = 1 
		SET @MaxRow = 0
		
		SELECT @MaxRow = MAX(RowId) FROM #BaseExpressionCount
		WHILE @MinRow <= @MaxRow
		BEGIN
			TRUNCATE TABLE #CountAnswer
			
			SELECT @AnsExpression = ExpressionCount FROM #BaseExpressionCount WHERE RowId = @MinRow
		
			INSERT INTO #CountAnswer
			(CountAnswer)	
			EXEC sp_executesql @AnsExpression
		
			SET @AnsExpression = NULL
			SELECT @AnsExpression = CountAnswer FROM #CountAnswer
			
			UPDATE #BaseExpressionCount 
			SET [Count] = @AnsExpression
			WHERE RowId = @MinRow
			
			SET @AnsExpression = NULL
		
			SET @MinRow = @MinRow+1
		END	
		
		SET @BaseExpRowId = 0
		SET @MinRow = 1
		 
		WHILE @MinRow <= @MaxRow
		BEGIN
			INSERT INTO #CompareExpressionCount
			(SongId, SurveyId, IsBase, MtbOption, [Count], Expression, ExpressionCount)
			SELECT 
				DISTINCT SC.SongId, BSRC.CompareSurveyId, 'False' AS IsBase, @AnswerText, 0 AS [Count], 
				@Expression1, 'SELECT '+@Expression1 
			FROM #SongCount SC 
			INNER JOIN #CompareSurveyResponseCount BSRC
				ON SC.SongId = BSRC.SongId
			WHERE SC.[Rank] = @MinRow

			SET @BaseExpRowId = @@IDENTITY

			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Love it',CONVERT(VARCHAR(12),BSRC.ResponseCount))
			FROM #CompareExpressionCount BEC
			INNER JOIN #CompareSurveyResponseCount BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Love it'
			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Like it',CONVERT(VARCHAR(12),BSRC.ResponseCount))
			FROM #CompareExpressionCount BEC
			INNER JOIN #CompareSurveyResponseCount BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Like it'
			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Just OK',CONVERT(VARCHAR(12),BSRC.ResponseCount))
			FROM #CompareExpressionCount BEC
			INNER JOIN #CompareSurveyResponseCount BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Just OK'
			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Tired of',CONVERT(VARCHAR(12),BSRC.ResponseCount))
			FROM #CompareExpressionCount BEC
			INNER JOIN #CompareSurveyResponseCount BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Tired of'
			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'Hate it',CONVERT(VARCHAR(12),BSRC.ResponseCount))
			FROM #CompareExpressionCount BEC
			INNER JOIN #CompareSurveyResponseCount BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'Hate it'
 			
			UPDATE BEC
			SET BEC.ExpressionCount = REPLACE(BEC.ExpressionCount,'I don''t know this song',CONVERT(VARCHAR(12),BSRC.ResponseCount))
			FROM #CompareExpressionCount BEC
			INNER JOIN #CompareSurveyResponseCount BSRC
				ON BEC.SongId = BSRC.SongId 
			WHERE BEC.RowId = @BaseExpRowId AND BSRC.AnswerText = 'I don''t know this song'
			
			SET @MinRow = @MinRow+1
		END		
		
		UPDATE #CompareExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Love it','0')
		UPDATE #CompareExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Like it','0')
		UPDATE #CompareExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Just OK','0')
		UPDATE #CompareExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Tired of','0')
		UPDATE #CompareExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'Hate it','0')
		UPDATE #CompareExpressionCount SET ExpressionCount = REPLACE(ExpressionCount,'I don''t know this song','0')
		
		SET @MinRow = 1 
		SET @MaxRow = 0
		
		SELECT @MaxRow = MAX(RowId) FROM #CompareExpressionCount
		WHILE @MinRow <= @MaxRow
		BEGIN
			TRUNCATE TABLE #CountAnswer
			
			SELECT @AnsExpression = ExpressionCount FROM #CompareExpressionCount WHERE RowId = @MinRow
		
			INSERT INTO #CountAnswer
			(CountAnswer)	
			EXEC sp_executesql @AnsExpression
		
			SET @AnsExpression = NULL
			SELECT @AnsExpression = CountAnswer FROM #CountAnswer
			
			UPDATE #CompareExpressionCount 
			SET [Count] = @AnsExpression
			WHERE RowId = @MinRow
			
			SET @AnsExpression = NULL
		
			SET @MinRow = @MinRow+1
		END	
	
		SET @XmlResult =
		(
			SELECT 
			(
				SELECT
				(
					SELECT 
					(
						SELECT S.[Rank], S.SongId, S.Title, S.Artist, S.FileLibYear AS [Year], '' AS Category
						FOR XML PATH(''), TYPE
					),
					(
						SELECT
						(
							SELECT
							(
								SELECT 
								(
									SELECT
										BSRC.SurveyId, BSRC.IsBase, BSRC.MtbOption, BSRC.[Count] 
									FROM #BaseExpressionCount BSRC
									WHERE BSRC.SongId = S.SongId
									    AND BSRC.SurveyId = CASE WHEN @CompareSurveyId = 0 THEN BSRC.SurveyId ELSE @CompareSurveyId END
									FOR XML PATH('MtbScore'), TYPE
								),
								(
									SELECT 
										CSRC.SurveyId, CSRC.IsBase, CSRC.MtbOption, CSRC.[Count] 
									FROM #CompareExpressionCount CSRC
									WHERE CSRC.SongId = S.SongId
										AND CSRC.SurveyId = CASE WHEN @CompareSurveyId = 0 THEN CSRC.SurveyId ELSE @CompareSurveyId END
									FOR XML PATH('MtbScore'), TYPE
								) 
								FOR XML PATH(''), TYPE
							)
						) 
						FOR XML PATH('Scores'), TYPE
					), 
					(
						SELECT 
						(
							SELECT 
								REPLACE(TTCT.BaseOptionName,'-','~')+'-'+TTCT.MTBText AS [Name],
								0 AS [Count], LOWER(TTCT.TrendType) AS TrendType,
								TTCT.BaseQuestionId AS QuestionId, TSQ.QuestionNo
							FROM DBO.TR_TrendCrossTabs TTCT
							LEFT JOIN DBO.TR_SurveyQuestions TSQ
								ON TTCT.BaseQuestionId = TSQ.QuestionId
							WHERE TTCT.ReportId = @ReportId
							FOR XML PATH('CrossTab'), TYPE
						)
						FOR XML PATH('CrossTabs'), TYPE
					)
					FOR XML PATH(''), TYPE
				) 
				FOR XML PATH('Song'), TYPE
			)	
			FROM #SongCount S
			WHERE S.SongId = CASE WHEN @SongId = 0 THEN S.SongId ELSE @SongId END 
			FOR XML PATH(''), ROOT('ArrayOfSong')
		)
		
		SELECT @XmlResult AS XmlResult
	END
	
END TRY  
 
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END


