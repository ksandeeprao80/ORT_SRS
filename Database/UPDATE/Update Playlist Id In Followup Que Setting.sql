UPDATE A
SET A.Value = B.Value
--SELECT A.SettingId, A.QuestionId, A.Value, B.FollowupQuestionId, B.Value
FROM TR_QuestionSettings A
INNER JOIN 
(
	SELECT 
		 TSS1.FollowupQuestionId, TSS1.MtbQuestionId, TSS.Value
	FROM TR_QuestionSettings TSS (NOLOCK)
	INNER JOIN	
	(
		SELECT 
			TSS.QuestionId AS FollowupQuestionId, CONVERT(INT,ISNULL(TSS.Value,0)) AS MtbQuestionId
		FROM TR_QuestionSettings TSS (NOLOCK)
		INNER JOIN
		(		
			SELECT TSS.QuestionId, TSS.Value 
			FROM MS_QuestionSettings MSS (NOLOCK)
			INNER JOIN TR_QuestionSettings TSS (NOLOCK)
				ON MSS.SettingId = TSS.SettingId 
				AND MSS.SettingName = 'IsMediaFollowup' AND TSS.Value = 'True'
		) TSS1
			ON TSS1.QuestionId = TSS.QuestionId
			AND TSS.SettingId = 32
			AND ISNULL(TSS1.Value,'') <> '' 
		WHERE CONVERT(INT,ISNULL(TSS.Value,0)) <> 0
	) TSS1
		ON TSS.QuestionId = TSS1.MtbQuestionId
		WHERE TSS.SettingId = 7 
		AND LTRIM(RTRIM(TSS.Value)) <> 'False'
		AND LTRIM(RTRIM(TSS.Value)) <> '0'
		AND LTRIM(RTRIM(TSS.Value)) <> ''
) B
	ON A.QuestionId = B.FollowupQuestionId
WHERE A.SettingId = 7	
		
	
	

	
	 