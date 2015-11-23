-- Survey Id = @SurveyId -- ORT SURVEY ID : 1132  -- PROD SURVEY ID : 1099 
BEGIN
BEGIN TRY
BEGIN TRAN

	DECLARE @SurveyId INT
	SET @SurveyId = 0 

	INSERT INTO DBO.TR_Survey
	(
		SurveyName,CustomerId,StarMarked,RewardEnabled,CreatedBy,CreatedDate,
		IsActive,StatusId,CategoryId,LanguageId, SurveyEndDate
	)
	SELECT 
		'Seattle KLCK - Opinions Ltd' AS SurveyName, 1 AS CustomerId, 1 AS StarMarked, 1 AS RewardEnabled,
		1 AS CreatedBy, GETDATE() AS CreatedDate, 1 AS InActive, 1 AS StatusId,
		1 AS CategoryId, 1 AS LanguageId, GETDATE()+25

	SET @SurveyId = @@IDENTITY

-------------------------------------------------------------------------------
	-- Q1.1
	DECLARE @Q1_1 INT
	SET @Q1_1 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thank you for agreeing to take part in our online music survey!  You will be able to rate songs and give your opinions about music and entertainment that you like.  No one will attempt to sell you anything, and I think you will find the survey to be fun and rewarding. It was agreed that for completing the entire survey within the time frame allowed, you will be compensated $60 for your time.  After you have completed the survey you will be asked for your name, address and phone number. This information will used to send you your $60 gift.  Your information will not be sold to a third party.    The survey will take approximately 2 hours, and is self-directed.  You can work at your own pace, starting and stopping at your convenience when you are connected to the internet.  We ask that you complete the survey within 48 hours of starting it and that you give the survey your full attention. Importantly, we also require that the survey is totally completed by you alone and that you do not forward nor allow anyone other than you to access the survey.  Click NEXT>' AS QuestionText,
		1 AS IsDeleted, 1
	FROM MS_QuestionTypes WHERE QuestionCode = 'Welcome'
	
	SET @Q1_1 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 2
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_1, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
-------------------------------------------------------------------------------
	-- Q781
	DECLARE @Q781 INT
	SET @Q781 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'First, some important browser information: In order to have the best possible survey experience, it is important to upgrade your browser to the most current available.  This will not only help you be safer when you surf the web, but it will also allow you to see all the graphics that are being displayed in this survey.  If you think you currently do not have the most current browser available, please go to one of the following sites depending on what browser you prefer using.  You can use any of these browsers for free in order to take your survey.Explorer 9 at:http://windows.microsoft.com/en-US/internet-explorer/products/ie/homeFirefox at:http://www.getfirefox.net/Google Chrome at:www.google.com/chrome/Once you''ve uploaded your upgraded browser or if you already have an upgraded browser, you are ready to begin!  Click next>' AS QuestionText,
		1 AS IsDeleted, 3
	FROM MS_QuestionTypes WHERE QuestionCode = 'PerceptIntro'

	SET @Q781 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 4
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q781, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
------------------------------------------------------------------------------- 
	-- Q1.3 
	DECLARE @Q1_3 INT
	SET @Q1_3 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your exact age?' AS QuestionText,
		1 AS IsDeleted, 5
	FROM MS_QuestionTypes WHERE QuestionCode = 'NumberInput'
	
	SET @Q1_3 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 6
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_3, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

------------------------------------------------------------------------------- 
	--Q1.4
	DECLARE @Q1_4 INT
	SET @Q1_4 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Gender:' AS QuestionText,
		1 AS IsDeleted, 7
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q1_4 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 8
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_4, 'Female','Female' 
	
	DECLARE @Ans1 INT
	SET @Ans1 = 0  
		INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
		SELECT @Q1_4, 'Male','Male' 
	SET @Ans1 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_4, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

------------------------------------------------------------------------------- 
	--Q1.7
	DECLARE @Q1_7 INT
	SET @Q1_7 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'List all of the Radio Stations you listen to in a typical week for at least one hour FOR MUSIC.Think about ALL of the occasions in which you listen to each station during your typical week.' AS QuestionText,
		1 AS IsDeleted, 9
	FROM MS_QuestionTypes WHERE QuestionCode = 'MultiSelect'

	SET @Q1_7 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 10
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	DECLARE @Ans2 INT
	SET @Ans2 = 0  
		INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
		SELECT @Q1_7,'Click 98.9FM','Click 98.9FM'  
	SET @Ans2 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'107.7 The End','107.7 The End' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'106.1 Kiss FM','106.1 Kiss FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'KUBE 93.3 FM','KUBE 93.3 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'94.1 KMPS','94.1 KMPS' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'Movin 92.5 FM','Movin 92.5 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'Star 101.5','Star 101.5' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'Warm 106.9','Warm 106.9' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'The Wolf 100.7 FM','The Wolf 100.7 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7,'Other','Other' 
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_7, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

-------------------------------------------------------------------------------
	--
	DECLARE @Q1_7A INT
	SET @Q1_7A = 0
	
	INSERT INTO DBO.TR_SurveyQuestions(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
			@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Has Click 98.9 made a change in its music lately?' AS QuestionText,
			1 AS IsDeleted, 11
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q1_7A = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 12
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	DECLARE @Ans3 INT
	SET @Ans3 = 0  
		INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
		SELECT @Q1_7A,'Yes','Yes' 
	SET @Ans3 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7A,'No','No' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7A,'Don’t Know','Don’t Know' 
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_7A, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
 
-------------------------------------------------------------------------------
	--
	DECLARE @Q1_7B INT
	SET @Q1_7B = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Has the change made the radio station better, worse, or has it not made a difference?' AS QuestionText,
		1 AS IsDeleted, 13
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q1_7B = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 14
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7B,'Better','Better'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7B,'Worse','Worse'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_7B,'Don’t Know','Don’t Know'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_7B, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

-------------------------------------------------------------------------------
	--Q1.18
	DECLARE @Q1_18 INT
	SET @Q1_18 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What radio station has been getting BETTER lately, in terms of its MUSIC?' AS QuestionText,
		1 AS IsDeleted, 15
	FROM MS_QuestionTypes WHERE QuestionCode = 'MultiSelect'
	
	SET @Q1_18  = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 16
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'Click 98.9FM','Click 98.9FM'  
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'107.7 The End','107.7 The End' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'106.1 Kiss FM','106.1 Kiss FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'KUBE 93.3 FM','KUBE 93.3 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'94.1 KMPS','94.1 KMPS' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'Movin 92.5 FM','Movin 92.5 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'Star 101.5','Star 101.5' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'Warm 106.9','Warm 106.9' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'The Wolf 100.7 FM','The Wolf 100.7 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18,'Other','Other' 
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_18, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
------------------------------------------------------------------------------- 
	--Q1.18a
	DECLARE @Q1_18A INT
	SET @Q1_18A = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What radio station has been getting WORSE lately, in terms of its MUSIC?' AS QuestionText,
		1 AS IsDeleted, 17
	FROM MS_QuestionTypes WHERE QuestionCode = 'MultiSelect'

	SET @Q1_18A = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 18
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'Click 98.9FM','Click 98.9FM'  
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'107.7 The End','107.7 The End' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'106.1 Kiss FM','106.1 Kiss FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'KUBE 93.3 FM','KUBE 93.3 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'94.1 KMPS','94.1 KMPS' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'Movin 92.5 FM','Movin 92.5 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'Star 101.5','Star 101.5' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'Warm 106.9','Warm 106.9' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'The Wolf 100.7 FM','The Wolf 100.7 FM' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_18A,'Other','Other' 
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_18A, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
-------------------------------------------------------------------------------
 	--Q1.19
 	DECLARE @Q1_19 INT
	SET @Q1_19 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has Click 98.9 been:' AS QuestionText,
		1 AS IsDeleted, 19
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q1_19 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 20
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_19,'Getting Better','Getting Better'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_19,'About the same as a few months ago','About the same as a few months ago'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_19,'Getting Worse','Getting Worse'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_19,'don''t Listen / don''t Know','don''t Listen / don''t Know'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_19, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

------------------------------------------------------------------------------- 
	--Q1.20
	DECLARE @Q1_20 INT
	SET @Q1_20 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has 107.7 The End been:' AS QuestionText,
		1 AS IsDeleted, 21
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
 
	SET @Q1_20 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 22
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_20,'Getting Better','Getting Better'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_20,'About the same as a few months ago','About the same as a few months ago'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_20,'Getting Worse','Getting Worse'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_20,'don''t Listen / don''t Know','don''t Listen / don''t Know'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_20, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
-------------------------------------------------------------------------------
	-- Q1.21
	DECLARE @Q1_21 INT
	SET @Q1_21 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has 106.1 Kiss FM been:' AS QuestionText,
		1 AS IsDeleted, 23
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q1_21 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 24
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_21,'Getting Better','Getting Better'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_21,'About the same as a few months ago','About the same as a few months ago'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_21,'Getting Worse','Getting Worse'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_21,'don''t Listen / don''t Know','don''t Listen / don''t Know'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_21, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
-------------------------------------------------------------------------------
	--Q1.22
	DECLARE @Q1_22 INT
	SET @Q1_22 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has Star 101.5 been:' AS QuestionText,
		1 AS IsDeleted, 25
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q1_22 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 26
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_22,'Getting Better','Getting Better'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_22,'About the same as a few months ago','About the same as a few months ago'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_22,'Getting Worse','Getting Worse'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q1_22,'don''t Listen / don''t Know','don''t Listen / don''t Know'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_22, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
-------------------------------------------------------------------------------
	-- Q1.23
	DECLARE @Q1_23 INT
	SET @Q1_23 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Good news!  It is time for the music. You will hear song clips of about 6-8 seconds each.   After you listen to each clip, we will ask you to give a vote for each song:1=LOVE IT - One of your favorites.  You can have many favorites2=LIKE IT  - Not one of your favorites, but you like it3=JUST OK - not positive or negative toward the song4=TIRED OF-  it’s a song you’re so tired of hearing it that it may cause you to switch radio stations.5=HATE IT - it’s a song that you don’t like.6=I don''t KNOW THIS SONG - you have never heard this song beforeVoting opens after you have listened to at least the first few seconds of the song clip.  If you wish to listen to that song clip again before voting, you can hit the ''play'' button again.Remember that this survey involves the playing of song clips through your computer''s speakers.  If you are taking this survey in an office or other public place, make sure to wear headphones!  Ready?  Let''s Go!  Click the ''next'' ( > ) button to get to the first song.' AS QuestionText,
		1 AS IsDeleted, 27
	FROM MS_QuestionTypes WHERE QuestionCode = 'MediaIntro'
	
	SET @Q1_23 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 28
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_23, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	
------------------------------------------------------------------------------- 
	--Q2.568
	DECLARE @Q2_568 INT
	SET @Q2_568 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS IsDeleted, 29
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q2_568 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 30
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'

	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q2_568,'Love it','Love it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q2_568,'Like it','Like it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q2_568,'Just OK','Just OK'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q2_568,'Tired of','Tired of'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q2_568,'Hate it','Hate it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q2_568,'I don''t know this song','I don''t know this song'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q2_568, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,5) THEN 'True'  
				WHEN SettingId IN(6) THEN 'False'
				WHEN SettingId IN(7) THEN '4'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

------------------------------------------------------------------------------- 
	--Q3.1
	DECLARE @Q3_1 INT
	SET @Q3_1 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'There are just a few more questions we would like to ask before the end of this survey.  Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.  Click the >> button when you are ready to proceed.' AS QuestionText,
		1 AS IsDeleted, 31
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'PerceptIntro'

	SET @Q3_1 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 32
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q3_1, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,6) THEN 'False'  
				WHEN SettingId IN(5) THEN 'True'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8) THEN '' 
				WHEN SettingId IN(9) THEN '703' END AS Value 
	FROM MS_QuestionSettings
	
	
-------------------------------------------------------------------------------
	--Q4.1
	DECLARE @Q4_1 INT
	SET @Q4_1 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Here is the next group of songs. Click the ''Play'' button when you are ready to listen to the music.  (remember to wear headphones if you are listening in a public place)           When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:  If a radio station played the kind of music you just heard, would you:' AS QuestionText,
		1 AS IsDeleted, 33
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @Q4_1 = @@IDENTITY	
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 34
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_1,'Listen a lot','Listen a lot'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_1,'Listen Sometimes','Listen Sometimes'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_1,'Listen only once in a while','Listen only once in a while'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_1,'Rarely Listen','Rarely Listen'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_1,'Never Listen','Never Listen'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q4_1, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,6) THEN 'False'  
				WHEN SettingId IN(5) THEN 'True'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8) THEN '' 
				WHEN SettingId IN(9) THEN '703' END AS Value 
	FROM MS_QuestionSettings
-------------------------------------------------------------------------------
	--Q4.2
	DECLARE @Q4_2 INT
	SET @Q4_2 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
		1 AS IsDeleted, 35
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @Q4_2 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 36
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_2,'Click 98.9','Click 98.9'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_2,'107.7 The End','107.7 The End'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_2,'106.1 Kiss FM','106.1 Kiss FM'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_2,'KUBE 93.3 FM','KUBE 93.3 FM'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_2,'Movin 92.5','Movin 92.5'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_2,'Other Station','Other Station'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q4_2,'No Station','No Station'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q4_2, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
-------------------------------------------------------------------------------
	--Q5.1
	DECLARE @Q5_1 INT
	SET @Q5_1 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.    Click the &#39;Play&#39; button when you are ready to listen to the music.  (remember to wear headphones if you are listening in a public place)             When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:     If a radio station played the kind of music you just heard, would you:' AS QuestionText,
		1 AS IsDeleted, 37
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
     
    SET @Q5_1 = @@IDENTITY
    
    INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
    SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 38
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
     
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_1,'Listen a lot','Listen a lot'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_1,'Listen Sometimes','Listen Sometimes'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_1,'Listen only once in a while','Listen only once in a while'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_1,'Rarely Listen','Rarely Listen'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_1,'Never Listen','Never Listen'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q5_1, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,6) THEN 'False'  
				WHEN SettingId IN(5) THEN 'True'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8) THEN '' 
				WHEN SettingId IN(9) THEN '703' END AS Value 
	FROM MS_QuestionSettings
-------------------------------------------------------------------------------
	--Q5.2
	DECLARE @Q5_2 INT
	SET @Q5_2 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
		1 AS IsDeleted, 39
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @Q5_2 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 40
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_2,'Click 98.9','Click 98.9'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_2,'107.7 The End','107.7 The End'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_2,'106.1 Kiss FM','106.1 Kiss FM'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_2,'KUBE 93.3 FM','KUBE 93.3 FM'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_2,'Movin 92.5','Movin 92.5'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_2,'Other Station','Other Station'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q5_2,'No Station','No Station'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q5_2, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
-------------------------------------------------------------------------------
	--Q6.1
	DECLARE @Q6_1 INT
	SET @Q6_1 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'There are just a few more questions we would like to ask before the end of this survey.      Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.           When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:  If a radio station played the kind of music you just heard, would you:' AS QuestionText,
		1 AS IsDeleted, 41
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @Q6_1 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 42
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_1,'Listen a lot','Listen a lot'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_1,'Listen Sometimes','Listen Sometimes'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_1,'Listen only once in a while','Listen only once in a while'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_1,'Rarely Listen','Rarely Listen'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_1,'Never Listen','Never Listen'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q6_1, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,6) THEN 'False'  
				WHEN SettingId IN(5) THEN 'True'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8) THEN '' 
				WHEN SettingId IN(9) THEN '703' END AS Value 
	FROM MS_QuestionSettings
	
	
-------------------------------------------------------------------------------
	--Q6.2
	DECLARE @Q6_2 INT
	SET @Q6_2 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
		1 AS IsDeleted, 43
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @Q6_2 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 44
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_2,'Click 98.9','Click 98.9'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_2,'107.7 The End','107.7 The End'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_2,'106.1 Kiss FM','106.1 Kiss FM'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_2,'KUBE 93.3 FM','KUBE 93.3 FM'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_2,'Movin 92.5','Movin 92.5'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_2,'Other Station','Other Station'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q6_2,'No Station','No Station'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q6_2, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
-------------------------------------------------------------------------------------------------

	---- PENDING *************************************************************************************
	--INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	-- INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	-- Q7.1 Thank you for participating in our survey.  You have been part of a small select group of participants that will help change the music you hear in Seattle.  We appreciate your time!  Below you will need to fill out your contact information.  We will use this to send your $60 participation fee.  Please be sure to double check your information for accuracy. 
	-- First Name (1)
	-- Last Name (2)
	-- Street Address (3)
	-- City (4)
	-- State (5)
	-- Post code (6)
	-- email address (7)
	-- Phone Number (8)
	---- PENDING *************************************************************************************
--------------------------------------------------
	-- Q7.2 
	DECLARE @ThankYou INT
	SET @ThankYou = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thank you.  We will send you a check shortly.  If you have not received the check within 30 days please contact us at: 1-206-347-2188.  It is important to us that this is a positive experience for you. Please let us know if you would be willing to be contacted for future MUSIC research studies.  If yes, we will use your email address to contact you for the next available study. Please keep in mind that the next study could be 6 months from now. Thank you again, Music Research Department' AS QuestionText,
		1 AS IsDeleted, 45 
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @ThankYou = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @ThankYou, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @ThankYou,'YES I would be willing to participate in a future music study','YES I would be willing to participate in a future music study'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @ThankYou,'NO I would prefer not to participate in any future music studies','NO I would prefer not to participate in any future music studies'
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 46
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	
	DECLARE @AddThanku INT 
	SET @AddThanku = 0
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 
		'<p>IMPORTANT:Please click the NEXT button to submit your completed survey!<br /> Thank you so much for your participation!</p>
		<p>Tina Paolella<br />Music Research Department</p>' AS QuestionText,
		1 AS IsDeleted, 47 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'ThankYou'
	
	SET @AddThanku = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @AddThanku, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
--------------------------------------------------

	DECLARE @EndOfBlock INT
	SET @EndOfBlock = 0
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId,	'Sorry you did not qualify for survey, better luck next time.',
		1,48
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'EndOfBlock'
	
	SET @EndOfBlock = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @EndOfBlock, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

--------------- SKIP LOGIC
	-- @Q1_3
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.3 
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_3)+').Answer < 27',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_4),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.3 
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_3)+').Answer > 33',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_4),@SurveyId)
	-- @Q1_4
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)-- @Q1_4
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_4)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans1)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_7),@SurveyId)
	-- @Q1_7
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId) 
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_7)+').Answer != Answer('+CONVERT(VARCHAR(12),@Ans2)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_7A),@SurveyId)
	-- @@Q1_7A
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId) 
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_7A)+').Answer != Answer('+CONVERT(VARCHAR(12),@Ans3)+')',CONVERT(VARCHAR(12),@Q1_18),CONVERT(VARCHAR(12),@Q1_7B),@SurveyId)

--------------- SKIP LOGIC 

--- START OF SURVEY SETTINGS --------------------------------------------------------------------------------------

	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'BTN_BACK'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'BTN_SAVECONTIUNE'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'CB_DEFAULTEOS'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'CB_OPENACCESS'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'ALLOW_ANONYMOUS'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'ALLOW_REPEAT'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'ALLOW_SAVE_CONTINUE'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'Verdana' FROM MS_SurveySettings WHERE SettingName = 'ANSWER_FONT'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'#191970' FROM MS_SurveySettings WHERE SettingName = 'ANSWER_FONT_COLOR'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'12px' FROM MS_SurveySettings WHERE SettingName = 'ANSWER_FONT_SIZE'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'BY_INVITE'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'E_O_S_EMAIL'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'E_O_S_MESSAGE'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'' FROM MS_SurveySettings WHERE SettingName = 'E_O_S_EMAIL_ID'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'6' FROM MS_SurveySettings WHERE SettingName = 'E_O_S_MESSAGE_ID'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'' FROM MS_SurveySettings WHERE SettingName = 'E_O_S_REDIRECT_URL'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'Verdana' FROM MS_SurveySettings WHERE SettingName = 'HEADER_FONT'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'20px' FROM MS_SurveySettings WHERE SettingName = 'HEADER_FONT_SIZE'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'HEADER_SHOW_DATE_TIME'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'HEADER_TEXT_COLOR'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'INVITE_HAS_PSW'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'Verdana' FROM MS_SurveySettings WHERE SettingName = 'QUESTION_FONT'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'#fff' FROM MS_SurveySettings WHERE SettingName = 'QUESTION_FONT_COLOR'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'14px' FROM MS_SurveySettings WHERE SettingName = 'QUESTION_FONT_SIZE'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'AutoAdvance'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'' FROM MS_SurveySettings WHERE SettingName = 'BackGroundColor'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'E_O_S_REDIRECT'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'' FROM MS_SurveySettings WHERE SettingName = 'LogoFile'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'surveyEngine1.html' FROM MS_SurveySettings WHERE SettingName = 'SurveyTemplateName'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'surveyEngine1_ThankYou.html' FROM MS_SurveySettings WHERE SettingName = 'SurveyThankuPage'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'surveyEngine1_welcome.html' FROM MS_SurveySettings WHERE SettingName = 'SurveyWelcomePage'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'#fff' FROM MS_SurveySettings WHERE SettingName = 'HEADER_FONT_COLOR'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'PipingIn'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'ValidationAnswerValues'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'CheckQuotas'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'NextBackTextLink'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'CheckSurveyEnd'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'RewardSet'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'FollowupMTBQue'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = 'VerificationQuestion'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'False' FROM MS_SurveySettings WHERE SettingName = '2ndValidation'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'SkipLogic'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'SurveyEngine1_Expired.html' FROM MS_SurveySettings WHERE SettingName = 'SurveyExpiredPage'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'surveyEngine1_Rewards.html' FROM MS_SurveySettings WHERE SettingName = 'SurveyRewardPage'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'RandomizeTestList'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'5' FROM MS_SurveySettings WHERE SettingName = 'TestListRandomNo' 
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'AutoPlay'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'surveyEngine1_EndOfBlock.html' FROM MS_SurveySettings WHERE SettingName = 'SurveyEndofBlockPage'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'surveyEngine1_AccessDenied.html' FROM MS_SurveySettings WHERE SettingName = 'AccessDeniedPage'
	 
	--- END OF SURVEY SETTINGS --------------------------------------------------------------------------------------

	SELECT @SurveyId AS NewSurveyId

COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END