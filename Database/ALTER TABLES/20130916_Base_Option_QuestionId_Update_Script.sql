-------------------- START TR_TrendCrossTabs -------------------- 
	-- 1st Trend Cross Tab  
	UPDATE TTCT
	SET TTCT.BaseQuestionId = TSQ.QuestionId  
	FROM DBO.TR_TrendCrossTabs TTCT  WITH(NOLOCK)
	INNER JOIN DBO.TR_Trends TT  WITH(NOLOCK) 
	ON TTCT.ReportId = TT.ReportId
	INNER JOIN 
	(
		SELECT TSQ.SurveyId, TSQ.QuestionId, TSA.Answer 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyAnswers TSA  WITH(NOLOCK) 
		ON TSQ.QuestionId = TSA.QuestionId
	 ) TSQ
		ON TT.BaseSurveyId = TSQ.SurveyId
		AND LTRIM(RTRIM(TTCT.BaseOptionName)) = LTRIM(RTRIM(TSQ.Answer))
	WHERE TTCT.BaseQuestionId IS NULL
		
	-- 1st Trend Cross Tab Text Input 
	UPDATE TTCT
	SET TTCT.BaseQuestionId = TSQ.QuestionId 
	FROM DBO.TR_TrendCrossTabs TTCT  WITH(NOLOCK)
	INNER JOIN DBO.TR_Trends TT  WITH(NOLOCK) 
	ON TTCT.ReportId = TT.ReportId
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	ON TT.BaseSurveyId = TSQ.SurveyId AND TSQ.QuestionTypeId = 3
	AND TTCT.BaseOptionName LIKE '%'+LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+'%'
	WHERE TTCT.BaseQuestionId IS NULL
	
	-- 1st Trend Cross Tab Number Input 
	UPDATE TTCT
	SET TTCT.BaseQuestionId = TSQ.QuestionId 
	FROM DBO.TR_TrendCrossTabs TTCT  WITH(NOLOCK)
	INNER JOIN DBO.TR_Trends TT  WITH(NOLOCK) 
	ON TTCT.ReportId = TT.ReportId
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	ON TT.BaseSurveyId = TSQ.SurveyId AND TSQ.QuestionTypeId = 9
	AND TTCT.BaseOptionName LIKE '%'+LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+'%'
	WHERE TTCT.BaseQuestionId IS NULL

-------------------- END TR_TrendCrossTabs -------------------- 	

----****************************************************************---

-------------------- START TR_TrendOptionMapping -------------------- 
	-- BASE SURVEY BASE OPTION QUESTION ID --

	-- 1st Trend Option Mapping   
	UPDATE TTOM
	SET TTOM.BaseQuestionId = TSQ.QuestionId  
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN 
	(
		SELECT TSQ.SurveyId, TSQ.QuestionId, TSA.Answer 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyAnswers TSA  WITH(NOLOCK) 
		ON TSQ.QuestionId = TSA.QuestionId
	 ) TSQ
		ON TT.BaseSurveyId = TSQ.SurveyId
		AND LTRIM(RTRIM(TTOM.BaseOptionName)) = LTRIM(RTRIM(TSQ.Answer))
	WHERE TTOM.BaseQuestionId IS NULL
		
	-- 1st Trend Option Mapping Text Input  
	UPDATE TTOM
	SET TTOM.BaseQuestionId = TSQ.QuestionId 
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	ON TT.BaseSurveyId = TSQ.SurveyId AND TSQ.QuestionTypeId = 3
	AND TTOM.BaseOptionName LIKE '%'+LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+'%'
	WHERE TTOM.BaseQuestionId IS NULL
	
	UPDATE TTOM
	SET TTOM.BaseQuestionId = TSQ.QuestionId 
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	ON TT.BaseSurveyId = TSQ.SurveyId AND TSQ.QuestionTypeId = 9
	AND TTOM.BaseOptionName LIKE '%'+LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+'%'
	WHERE TTOM.BaseQuestionId IS NULL
	
	UPDATE TTOM
	SET TTOM.BaseQuestionId = TSQ.QuestionId  
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN 
	(
		SELECT TSQ.SurveyId, TSQ.QuestionId, TSA.Answer 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyAnswers TSA  WITH(NOLOCK) 
		ON TSQ.QuestionId = TSA.QuestionId
		AND TSQ.QuestionTypeId = 2
	 ) TSQ
		ON TT.BaseSurveyId = TSQ.SurveyId
		AND LTRIM(RTRIM(TTOM.BaseOptionName)) = LTRIM(RTRIM(LEFT(TSQ.Answer,20)))
	WHERE TTOM.BaseQuestionId IS NULL
	
	UPDATE TTOM
	SET TTOM.BaseQuestionId = TSQ.QuestionId  
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN 
	(
		SELECT TSQ.SurveyId, TSQ.QuestionId, TSA.Answer 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyAnswers TSA  WITH(NOLOCK) 
		ON TSQ.QuestionId = TSA.QuestionId
	 ) TSQ
		ON TT.BaseSurveyId = TSQ.SurveyId
		AND LTRIM(RTRIM(TTOM.BaseOptionName)) = LTRIM(RTRIM(LEFT(TSQ.Answer,20)))
	WHERE TTOM.BaseQuestionId IS NULL
	

		-- COMPARE SURVEY OPTION QUESTION ID --

	-- 2nd Trend Option Mapping   
	UPDATE TTOM
	SET TTOM.OptionQuestionId = TSQ.QuestionId 
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN 
	(
		SELECT TSQ.SurveyId, TSQ.QuestionId, TSA.Answer 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyAnswers TSA  WITH(NOLOCK) 
		ON TSQ.QuestionId = TSA.QuestionId
	 ) TSQ
		ON TT.SurveyId = TSQ.SurveyId
		AND LTRIM(RTRIM(TTOM.OptionName)) = LTRIM(RTRIM(TSQ.Answer))
	WHERE TTOM.OptionQuestionId IS NULL	
		
	-- 2nd Trend Option Mapping Text Input
	UPDATE TTOM
	SET TTOM.OptionQuestionId = TSQ.QuestionId   
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	ON TT.SurveyId = TSQ.SurveyId AND TSQ.QuestionTypeId = 3
	AND TTOM.OptionName LIKE '%'+LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+'%'
	WHERE TTOM.OptionQuestionId IS NULL
	
	-- 2nd Trend Option Mapping Number Input
	UPDATE TTOM
	SET TTOM.OptionQuestionId = TSQ.QuestionId   
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
	ON TT.SurveyId = TSQ.SurveyId AND TSQ.QuestionTypeId = 9
	AND TTOM.OptionName LIKE '%'+LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+'%'
	WHERE TTOM.OptionQuestionId IS NULL
	
	-- 3rd Trend Option Mapping Multi Choice
	UPDATE TTOM
	SET TTOM.OptionQuestionId = TSQ.QuestionId 
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN 
	(
		SELECT TSQ.SurveyId, TSQ.QuestionId, TSA.Answer 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyAnswers TSA  WITH(NOLOCK) 
		ON TSQ.QuestionId = TSA.QuestionId
		AND TSQ.QuestionTypeId = 2
	 ) TSQ
		ON TT.SurveyId = TSQ.SurveyId
		AND LTRIM(RTRIM(TTOM.OptionName)) = LTRIM(RTRIM(LEFT(TSQ.Answer,20)))
	WHERE TTOM.OptionQuestionId IS NULL	
	
	UPDATE TTOM
	SET TTOM.OptionQuestionId = TSQ.QuestionId 
	FROM DBO.TR_TrendOptionMapping TTOM WITH(NOLOCK) 
	INNER JOIN DBO.TR_Trends TT WITH(NOLOCK)
	ON TTOM.TrendId = TT.TrendId
	INNER JOIN 
	(
		SELECT TSQ.SurveyId, TSQ.QuestionId, TSA.Answer 
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		INNER JOIN DBO.TR_SurveyAnswers TSA  WITH(NOLOCK) 
		ON TSQ.QuestionId = TSA.QuestionId
	 ) TSQ
		ON TT.SurveyId = TSQ.SurveyId
		AND LTRIM(RTRIM(TTOM.OptionName)) = LTRIM(RTRIM(LEFT(TSQ.Answer,20)))
	WHERE TTOM.OptionQuestionId IS NULL	

-------------------- END TR_TrendOptionMapping -------------------- 	