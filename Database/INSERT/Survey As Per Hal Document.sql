-- Survey Id = @SurveyId
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
		'Survey TestOctober 2012' AS SurveyName, 1 AS CustomerId, 1 AS StarMarked, 1 AS RewardEnabled,
		1 AS CreatedBy, GETDATE() AS CreatedDate, 1 AS InActive, 1 AS StatusId,
		1 AS CategoryId, 1 AS LanguageId, GETDATE()+25

	SET @SurveyId = @@IDENTITY

---------------------------------------------------------------------------------------------------------------
	DECLARE @QuestionId INT
	SET @QuestionId = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q1.2 
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Check the box if you or any other member of your household work for any of the following types of companies.' AS QuestionText,
		1 AS IsDeleted, 1 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId, 'Market Research Company','Market Research Company'  
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId, 'Advertising Agency','Advertising Agency' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId,'Radio or TV Station','Radio or TV Station'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId,'The Press / Newspapers','The Press / Newspapers'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId,'Music- Related Industry','Music- Related Industry'
	
	DECLARE @AnswerId1 INT 
	SET @AnswerId1 = 0
		INSERT INTO DBO.TR_SurveyAnswers
		(QuestionId,Answer,AnswerText)
		SELECT @QuestionId,'None of these','None of these'
	SET @AnswerId1 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 2 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---------------------------------------------------------------------------------------------------------------	

	DECLARE @AgeQuestion INT
	SET @AgeQuestion = 0
	
	INSERT INTO DBO.TR_SurveyQuestions --Q1.3
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your exact age?' AS QuestionText,
		1 AS IsDeleted, 3
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'NumberInput'
	
	SET @AgeQuestion = @@IDENTITY

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,
		IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 4 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---3-4------------------------------------------------------------------------------------------------------------
	
	DECLARE @QuestionId1 INT
	SET @QuestionId1 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions--Q1.4 
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Gender:' AS QuestionText,
		1 AS IsDeleted, 5 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId1 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId1, 'Female','Female' 
	
	DECLARE @AnswerId2 INT
	SET @AnswerId2 = 0  
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId1, 'Male','Male' 
	SET @AnswerId2 = @@IDENTITY
		
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 6 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---5-6------------------------------------------------------------------------------------------------------------
	DECLARE @QuestionId2 INT
	SET @QuestionId2 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Ethnic Background' AS QuestionText,
		1 AS IsDeleted, 7 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId2 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'White/Caucasian','White/Caucasian'  
	
	DECLARE @African INT
	SET @African = 0 
		INSERT INTO DBO.TR_SurveyAnswers
		(QuestionId,Answer,AnswerText)
		SELECT @QuestionId2, 'African American / Black','African American / Black' 
	SET @African = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'Asian','Asian' 
	
	DECLARE @Hispanic INT
	SET @Hispanic = 0 
		INSERT INTO DBO.TR_SurveyAnswers
		(QuestionId,Answer,AnswerText)
		SELECT @QuestionId2, 'Hispanic / Latino','Hispanic / Latino' 
	SET @Hispanic = @@IDENTITY
	
	DECLARE @Otherrace INT
	SET @Otherrace = 0
		INSERT INTO DBO.TR_SurveyAnswers
		(QuestionId,Answer,AnswerText)
		SELECT @QuestionId2, 'Other race or ethnic background','Other race or ethnic background'
	SET @Otherrace = @@IDENTITY
	
	DECLARE @Decline INT
	SET @Decline = 0
		INSERT INTO DBO.TR_SurveyAnswers
		(QuestionId,Answer,AnswerText)
		SELECT @QuestionId2, 'Decline to answer','Decline to answer'
	SET @Decline = @@IDENTITY

	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 8 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
---7-8------------------------------------------------------------------------------------------------------------	

	DECLARE @QuestionId3 INT
	SET @QuestionId3 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Think about listening to the radio from Monday - Friday - at home, at work, in your car or anywhere else.  How many hours in a typical day to you listen to the radio, Monday - Friday?' AS QuestionText,
		1 AS IsDeleted, 9 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId3 = @@IDENTITY
	
	DECLARE @Onehour INT
	SET @Onehour = 0
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, 'Less than 1 hour','Less than 1 hour'
	SET @Onehour = @@IDENTITY
	
	DECLARE @Twohour INT
	SET @Twohour = 0
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, '1 hour or more but less than 2 hours','1 hour or more but less than 2 hours'	
	SET @Twohour = @@IDENTITY
 
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, '2 hours or more but less than 3 hour','2 hours or more but less than 3 hour'	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, 'More than 3 hours','More than 3 hours'
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 10 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---9-10------------------------------------------------------------------------------------------------------------	
	DECLARE @QuestionId4 INT
	SET @QuestionId4 = 0

	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'List all of the Radio Stations you listen to in a typical week for at least one hour FOR MUSIC.Think about ALL of the occasions in which you listen to each station during your typical week.' AS QuestionText,
		1 AS IsDeleted, 11
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'MultiSelect'

	SET @QuestionId4 = @@IDENTITY
	
	DECLARE @AnswerId60 INT
	SET @AnswerId60 = 0 
		INSERT INTO DBO.TR_SurveyAnswers
		(QuestionId,Answer,AnswerText)
		SELECT @QuestionId4, 'Click 98.9FM','Click 98.9FM' 
		
	SET @AnswerId60 = @@IDENTITY
		
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, '107.7 The End','107.7 The End'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, '106.1 Kiss FM','106.1 Kiss FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'KUBE 93.3 FM','KUBE 93.3 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, '94.1 KMPS','94.1 KMPS'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'Movin 92.5 FM','Movin 92.5 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'Star 101.5','Star 101.5'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'Warm 106.9','Warm 106.9'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'The Wolf 100.7 FM','The Wolf 100.7 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'Other','Other'
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 12
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	 
----11-12-----------------------------------------------------------------------------------------------------------	 
	DECLARE @QuestionId5 INT
	SET @QuestionId5 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'When you have a choice, what is your favorite radio station to listen to FOR MUSIC?' AS QuestionText,
		1 AS IsDeleted, 13 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	SET @QuestionId5 = @@IDENTITY

	DECLARE @Ans65 INT	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Click 98.9FM','Click 98.9FM' 
	SET @Ans65 = @@IDENTITY
	
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, '107.7 The End','107.7 The End'
	

	DECLARE @Ans67 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, '106.1 Kiss FM','106.1 Kiss FM'
	SET @Ans67 = @@IDENTITY
	

	DECLARE @Ans68 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'KUBE 93.3 FM','KUBE 93.3 FM'
	SET @Ans68 = @@IDENTITY

	DECLARE @Ans69 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, '94.1 KMPS','94.1 KMPS'
	SET @Ans69 = @@IDENTITY

	DECLARE @Ans70 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Movin 92.5 FM','Movin 92.5 FM'
	SET @Ans70 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Star 101.5','Star 101.5'

	DECLARE @Ans71 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Warm 106.9','Warm 106.9'
	SET @Ans71 = @@IDENTITY

	DECLARE @Ans66 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'The Wolf 100.7 FM','The Wolf 100.7 FM'
	SET @Ans66 = @@IDENTITY

	DECLARE @Ans72 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Other','Other'
	SET @Ans72 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 14
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

---------------------------------------------------------------------------------------------------------------		
	DECLARE @QuestionId6 INT -- Song to play for 25 seconds
	SET @QuestionId6 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Now please listen to a montage of song clips, which lasts about 25 seconds.  Please listen to the entire group of song clips before you answer this question:  If there were a radio station in your area that played this type of music, would you listen to that station Often, Once in a While or Never. Click the ''Play'' button when you are ready to listen to the music.  If you are in a public place or open office, make sure to watch your volume or wear headphones.' AS QuestionText,
		1 AS IsDeleted, 15
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId6 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId6, 'Listen Often','Listen Often'
	
	DECLARE @Montage1 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId6, 'Listen Once in a While','Listen Once in a While'
	SET @Montage1 = @@IDENTITY

	DECLARE @Montage2 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId6, 'Listen Never','Listen Never'
	SET @Montage2 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 16
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

---------------------------------------------------------------------------------------------------------------	
	DECLARE @QuestionId7 INT  
	SET @QuestionId7 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Would that type of music you just heard be your favorite type or would it be a second or third choice for you.' AS QuestionText,
		1 AS IsDeleted, 17 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId7 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId7, 'This is my favorite type of music','This is my favorite type of music'
	
	DECLARE @Ans73 INT 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId7, 'This would be my second or third choice for music','This would be my second or third choice for music'
	SET @Ans73 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 18 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---------------------------------------------------------------------------------------------------------------
	
	DECLARE @QuestionId8 INT  
	SET @QuestionId8 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Have you taken part in research, such as focus groups or auditorium studies at a hotel or research facility or online study where you were paid to complete it.' AS QuestionText,
		1 AS IsDeleted, 19 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId8 = @@IDENTITY
	
	DECLARE @Ans74 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId8, 'No Never','No Never'
	SET @Ans74 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId8, 'I have but Less than 5 times','I have but Less than 5 times'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId8, 'I have taken More than 5 surveys where I was paid to complete them','I have taken More than 5 surveys where I was paid to complete them'
	 
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 20
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---------------------------------------------------------------------------------------------------------------
	
	DECLARE @QuestionId9 INT  
	SET @QuestionId9 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'When was the most recent research study in which you participated?' AS QuestionText,
		1 AS IsDeleted, 21 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId9 = @@IDENTITY
	
	DECLARE @Ans75 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId9, 'More than 1 year ago','More than 1 year ago'
	SET @Ans75 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId9, 'More than 2 months but less than 1 year ago','More than 2 months but less than 1 year ago'

	DECLARE @Ans76 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId9, 'Less than 2 months ago','Less than 2 months ago'
	SET @Ans76 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 22 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
	
	-- SELECT * FROM TR_SurveyQuestions WHERE SurveyId = 1112 ORDER BY QuestionNo

	
	
	
---------------------------------------------------------------------------------------------------------------

	DECLARE @QuestionId10 INT  
	SET @QuestionId10 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What was the topic of the study? (select one or more)' AS QuestionText,
		1 AS IsDeleted, 23
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'MultiSelect'

	SET @QuestionId10 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Financial','Financial' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Consumer Product','Consumer Product' 
	
	DECLARE @Ans77 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Music','Music' 
	SET @Ans77 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Political','Political' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Television','Television' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Health / Medical','Health / Medical' 

	DECLARE @Ans78 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Radio','Radio' 
	SET @Ans78 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Other','Other' 
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 24
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---------------------------------------------------------------------------------------------------------------

	DECLARE @QuestionId11 INT  
	SET @QuestionId11 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Congratulations!  We would like to invite you to take part in an online music survey where you will be able to rate songs and give your opinions about music and entertainment that you like.  No one will attempt to sell you anything, and I think you will find the survey to be fun and rewarding.     The survey will take approximately 2 hours, and is self-directed.  You can work at your own pace, starting and stopping at your convenience when you are connected to the internet.  We ask that you complete the survey within 48 hours of starting it and that you give the survey your full attention.     Importantly, we also require that the survey is totally completed by you alone and that you do not forward nor allow anyone other than you to access the survey.     Will you participate?' AS QuestionText,
		1 AS IsDeleted, 25 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId11 = @@IDENTITY
	
	DECLARE @Ans79 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId11, 'Yes, sounds like fun','Yes, sounds like fun'
	SET @Ans79 = @@IDENTITY
	 
	DECLARE @Ans80 INT
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId11, 'No','No'
	SET @Ans80 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 26 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	

---------------------------------------------------------------------------------------------------------------
	
	DECLARE @QuestionId12 INT  
	SET @QuestionId12 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your favorite radio station to listen to FOR MUSIC?' AS QuestionText,
		1 AS IsDeleted, 27
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId12 = @@IDENTITY
 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, 'Click 98.9FM','Click 98.9FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, '107.7 The End','107.7 The End'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, '106.1 Kiss FM','106.1 Kiss FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, 'KUBE 93.3 FM','KUBE 93.3 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, '94.1 KMPS','94.1 KMPS'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, 'Movin 92.5 FM','Movin 92.5 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, 'Star 101.5','Star 101.5'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, 'Warm 106.9','Warm 106.9'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, 'The Wolf 100.7 FM','The Wolf 100.7 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId12, 'Other','Other'

	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 28
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

---------------------------------------------------------------------------------------------------------------
	DECLARE @Welcome INT
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Welcome and Thank You for accepting our invitation to share your thoughts and feelings about the music you like to listen to.In this survey you will listen to and rate songs, and you may hear the same song a couple of times.  If at any time you cannot see the NEXT button, scroll down on the page you are viewing.  During the survey you are going to listen to short clips of songs and vote on those songs. You do not need to complete the survey in one sitting. Take as many breaks as you need, and come back when you are ready to continue.When you return, the survey will pick up right where you left off as long as you continue on the same computer using the same browser (i.e. Internet Explorer, Firefox, Chrome, or whatever browser you started with).   Your stopping point is saved by the survey system placing a ''cookie'' in your temporary folder to mark your progress so that your computer can communicate with the system. Please Do Not remove your cookies or delete your internet history until you have completed the survey.Click NEXT and lets begin with a few questions that will lead you into the music.' AS QuestionText,
		1 AS IsDeleted, 29
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'Welcome'
	
	SET @Welcome = @@IDENTITY

	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 30
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
	
---------------------------------------------------------------------------------------------------------------
	DECLARE @QuestionId13 INT  
	SET @QuestionId13 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What radio station has been getting BETTER lately in terms of MUSIC?' AS QuestionText,
		1 AS IsDeleted, 31 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId13 = @@IDENTITY
 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, 'Click 98.9FM','Click 98.9FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, '107.7 The End','107.7 The End'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, '106.1 Kiss FM','106.1 Kiss FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, 'KUBE 93.3 FM','KUBE 93.3 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, '94.1 KMPS','94.1 KMPS'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, 'Movin 92.5 FM','Movin 92.5 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, 'Star 101.5','Star 101.5'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, 'Warm 106.9','Warm 106.9'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, 'The Wolf 100.7 FM','The Wolf 100.7 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId13, 'Other','Other'
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 32
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
	
---------------------------------------------------------------------------------------------------------------
	
	DECLARE @QuestionId14 INT  
	SET @QuestionId14 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What radio station has been getting WORSE lately, in terms of its MUSIC?' AS QuestionText,
		1 AS IsDeleted, 33
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId14 = @@IDENTITY
 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, 'Click 98.9FM','Click 98.9FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, '107.7 The End','107.7 The End'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, '106.1 Kiss FM','106.1 Kiss FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, 'KUBE 93.3 FM','KUBE 93.3 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, '94.1 KMPS','94.1 KMPS'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, 'Movin 92.5 FM','Movin 92.5 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, 'Star 101.5','Star 101.5'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, 'Warm 106.9','Warm 106.9'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, 'The Wolf 100.7 FM','The Wolf 100.7 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId14, 'Other','Other'
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 34
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
	
	
---------------------------------------------------------------------------------------------------------------
	DECLARE @QuestionId15 INT  
	SET @QuestionId15 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has Click 98.9 been:' AS QuestionText,
		1 AS IsDeleted, 35 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId15 = @@IDENTITY
 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId15, 'Getting Better','Getting Better'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId15, 'About the same as a few months ago','About the same as a few months ago'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId15, 'Getting Worse','Getting Worse'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId15, 'Don''t Listen / Don''t Know','Don''t Listen / Don''t Know'


	DECLARE @QuestionId16 INT  
	SET @QuestionId16 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has 107.7 The End been:' AS QuestionText,
		1 AS IsDeleted, 36
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId16 = @@IDENTITY
 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId16, 'Getting Better','Getting Better'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId16, 'About the same as a few months ago','About the same as a few months ago'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId16, 'Getting Worse','Getting Worse'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId16, 'Don''t Listen / Don''t Know','Don''t Listen / Don''t Know'
 
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 37
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

---------------------------------------------------------------------------------------------------------------
	DECLARE @QuestionId17 INT  
	SET @QuestionId17 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has 106.1 Kiss FM been:' AS QuestionText,
		1 AS IsDeleted, 38 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId17 = @@IDENTITY
 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId17, 'Getting Better','Getting Better'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId17, 'About the same as a few months ago','About the same as a few months ago'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId17, 'Getting Worse','Getting Worse'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId17, 'Don''t Listen / Don''t Know','Don''t Listen / Don''t Know'
 
 
	DECLARE @QuestionId18 INT  
	SET @QuestionId18 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has Star 101.5 been:' AS QuestionText,
		1 AS IsDeleted, 39 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId18 = @@IDENTITY
 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId18, 'Getting Better','Getting Better'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId18, 'About the same as a few months ago','About the same as a few months ago'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId18, 'Getting Worse','Getting Worse'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId18, 'Don''t Listen / Don''t Know','Don''t Listen / Don''t Know'
 
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 40
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---------------------------------------------------------------------------------------------------------------
	DECLARE @GoodNews INT
	SET @GoodNews = 0

	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 
		'<p>Good news!  It is time for the music.You will hear song clips of about 6-8 seconds each.<br />
			After you listen to each clip, we will ask you to give a vote for each song:<br />
			1=LOVE IT - One of your favorites.You can have many favorites<br />
			2=LIKE IT  - Not one of your favorites, but you like it<br />
			3=JUST OK - not positive or negative toward the song<br />
			4=TIRED OF-  it''s a song you''re so tired of hearing it that it may cause you to switch radio stations.<br />
			5=HATE IT - it''s a song that you don''t like.<br />
			6=I DON''T KNOW THIS SONG - you have never heard this song before<br /></p>
			</p> Voting opens after you have listened to at least the first few seconds of the song clip.<br /></p>
			<p>
			If you wish to listen to that song clip again before voting, you can hit the ''play'' button again. Remember that this survey involves the playing of song clips through your computer''s speakers.<br />
			If you are taking this survey in an office or other public place, make sure to wear headphones!<br />
			Ready?  Let''s Go!  Click the ''next'' ( &gt; ) button to get to the first song.</p>' AS QuestionText,
		1 AS IsDeleted, 41
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'MediaIntro'
	
	SET @GoodNews = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 42
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---------------------------------------------------------------------------------------------------------------
	------------------ MEDIA --------------------------
	DECLARE @QuestionId19 INT  
	SET @QuestionId19 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS IsDeleted, 43
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId19 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'Love it','Love it'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'Like it','Like it'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'Just OK','Just OK'
	
	DECLARE @TiredOf INT
	SET @TiredOf = 0
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'Tired of','Tired of'
	SET @TiredOf = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'Hate it','Hate it'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'I don''t know this song','I don''t know this song'


	DECLARE @QuestionId35 INT  
	SET @QuestionId35 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'How much are you tried of it ?' AS QuestionText,
		1 AS IsDeleted, 44
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	
	
	SET @QuestionId35 = @@IDENTITY
 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId35,'Very Tired','Very Tired'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId35,'Forget It','Forget It'
	
	
	------------------ MEDIA END --------------------------

	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS IsDeleted, 45
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
---------------------------------------------------------------------------------------------------------------

DECLARE @Question46 INT
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'There are just a few more questions we would like to ask before the end of this survey.  Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.  Click the >> button when you are ready to proceed.' AS QuestionText,
 		1 AS IsDeleted, 46 
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'PerceptIntro'
 	SET @Question46  = @@IDENTITY
 
  	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 47
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'PageBreak'
 
 ----------------------------------------------
 
 	DECLARE @QuestionId20 INT  
 	SET @QuestionId20 = 0
 
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Here is the next group of songs. Click the ''Play'' button when you are ready to listen to the music.  (remember to wear headphones if you are listening in a public place)           When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:  If a radio station played the kind of music you just heard, would you:' AS QuestionText,
 		1 AS IsDeleted, 48
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'SingleChoice'
 	
 	SET @QuestionId20 = @@IDENTITY
 	
 

 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId20, 'Listen a lot','Listen a lot'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId20, 'Listen Sometimes','Listen Sometimes'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId20, 'Listen only once in a while','Listen only once in a while'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId20, 'Rarely Listen','Rarely Listen'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId20, 'Never Listen','Never Listen'
 	
 	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 49
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
 --34-----------------------------------------------
 
 	DECLARE @QuestionId21 INT  
 	SET @QuestionId21 = 0
 
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
 		1 AS IsDeleted, 50 
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'SingleChoice'
 	
 	SET @QuestionId21 = @@IDENTITY
 	

 
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId21, 'Click 98.9','Click 98.9'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId21, '107.7 The End','107.7 The End'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId21, '106.1 Kiss FM','106.1 Kiss FM'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId21, 'KUBE 93.3 FM','KUBE 93.3 FM'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId21, 'Movin 92.5','Movin 92.5'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId21, 'Other Station','Other Station'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId21, 'No Station','No Station'
 
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 51
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'PageBreak'
 
 --36-----------------------------------------------
 
 	DECLARE @QuestionId22 INT  
 	SET @QuestionId22 = 0
 
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.    Click the &#39;Play&#39; button when you are ready to listen to the music.  (remember to wear headphones if you are listening in a public place)        When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:     If a radio station played the kind of music you just heard, would you:' AS QuestionText,
 		1 AS IsDeleted, 52 
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'SingleChoice'
 	
 	SET @QuestionId22 = @@IDENTITY
 	 	
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId22, 'Listen a lot','Listen a lot'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId22, 'Listen Sometimes','Listen Sometimes'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId22, 'Listen only once in a while','Listen only once in a while'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId22, 'Rarely Listen','Rarely Listen'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId22, 'Never Listen','Never Listen'
 	
 	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 53
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
    
 --37-----------------------------------------------
 
 	DECLARE @QuestionId23 INT  
 	SET @QuestionId23 = 0
 
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
 		1 AS IsDeleted, 54 
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'SingleChoice'
 	
 	SET @QuestionId23 = @@IDENTITY
 	
  	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId23, 'Click 98.9','Click 98.9'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId23, '107.7 The End','107.7 The End'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId23, '106.1 Kiss FM','106.1 Kiss FM'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId23, 'KUBE 93.3 FM','KUBE 93.3 FM'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId23, 'Movin 92.5','Movin 92.5'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId23, 'Other Station','Other Station'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId23, 'No Station','No Station'
 	
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 55
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'PageBreak'
 
  --39-----------------------------------------------
  
 	DECLARE @QuestionId24 INT  
 	SET @QuestionId24 = 0
 
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'There are just a few more questions we would like to ask before the end of this survey.Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.        When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:  If a radio station played the kind of music you just heard, would you:' AS QuestionText,
 		1 AS IsDeleted, 56
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'SingleChoice'
 	
 	SET @QuestionId24 = @@IDENTITY
  	
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId24, 'Listen a lot','Listen a lot'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId24, 'Listen Sometimes','Listen Sometimes'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId24, 'Listen only once in a while','Listen only once in a while'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId24, 'Rarely Listen','Rarely Listen'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId24, 'Never Listen','Never Listen'
 	
 	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 57
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
 	
 --40-----------------------------------------------
 
 	DECLARE @QuestionId25 INT  
 	SET @QuestionId25 = 0
 
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
 		1 AS IsDeleted, 58 
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'SingleChoice'
 	
 	SET @QuestionId25 = @@IDENTITY
 	
 	
 	
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId25, 'Click 98.9','Click 98.9'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId25, '107.7 The End','107.7 The End'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId25, '106.1 Kiss FM','106.1 Kiss FM'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId25, 'KUBE 93.3 FM','KUBE 93.3 FM'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId25, 'Movin 92.5','Movin 92.5'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId25, 'Other Station','Other Station'
 	INSERT INTO DBO.TR_SurveyAnswers
 	(QuestionId,Answer,AnswerText)
 	SELECT @QuestionId25, 'No Station','No Station' 
  	
 	INSERT INTO DBO.TR_SurveyQuestions
 	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
 	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 59
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'PageBreak'
	
---------------------------------------------------------------------------------------------------------------
	
	DECLARE @Thanku INT 
	SET @Thanku = 0
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 
		'<p>IMPORTANT:Please click the NEXT button to submit your completed survey!<br /> Thank you so much for your participation!</p>
		<p>Tina Paolella<br />Music Research Department</p>' AS QuestionText,
		1 AS IsDeleted, 60 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'ThankYou'
	
	SET @Thanku = @@IDENTITY
	
	DECLARE @EndOfBlock INT
	SET @EndOfBlock = 0
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId,	'Sorry you did not qualify for survey, better luck next time.',
		1,61
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'EndOfBlock'
	
	SET @EndOfBlock = @@IDENTITY
	
---------------------------------------------------------------------------------------------------------------

	
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
		
	 
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@EndOfBlock,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,1,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,3,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,7,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId25,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,1,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,3,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,5,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,7,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId24,9,'703')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,1,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,3,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,7,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId23,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,1,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,3,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,5,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,7,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId22,9,'703')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,1,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,3,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,7,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId21,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@AgeQuestion,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId1,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId2,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId3,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId4,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId5,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,1,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,3,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,5,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,7,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId6,9,'703')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId7,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId8,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId9,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId10,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId11,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId12,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Welcome,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId13,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId14,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId15,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId16,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId17,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId18,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@GoodNews,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,7,'4')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,5,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,4,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId19,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,2,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId35,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,1,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,3,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,7,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Question46,9,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,1,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,3,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,5,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,7,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@QuestionId20,9,'703')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,8,'')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,7,'0')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,6,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,5,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,4,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,3,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,2,'False')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,1,'True')
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)VALUES(@Thanku,9,'')

	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.2 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId)+').Answer != Answer('+CONVERT(VARCHAR(12),@AnswerId1)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@AgeQuestion),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.3 
	VALUES('Question('+CONVERT(VARCHAR(12),@AgeQuestion)+').Answer < 27',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@QuestionId1),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.3 
	VALUES('Question('+CONVERT(VARCHAR(12),@AgeQuestion)+').Answer > 33',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@QuestionId1),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.4 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId1)+').Answer == Answer('+CONVERT(VARCHAR(12),@AnswerId2)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@QuestionId2),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.5 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId2)+').Answer == Answer('+CONVERT(VARCHAR(12),@African)+')',CONVERT(VARCHAR(12),@QuestionId5),CONVERT(VARCHAR(12),@QuestionId3),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.5 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId2)+').Answer == Answer('+CONVERT(VARCHAR(12),@Hispanic)+')',CONVERT(VARCHAR(12),@QuestionId5),CONVERT(VARCHAR(12),@QuestionId3),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.5 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId2)+').Answer == Answer('+CONVERT(VARCHAR(12),@Otherrace)+')',CONVERT(VARCHAR(12),@QuestionId5),CONVERT(VARCHAR(12),@QuestionId3),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.5 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId2)+').Answer == Answer('+CONVERT(VARCHAR(12),@Decline)+')',CONVERT(VARCHAR(12),@QuestionId5),CONVERT(VARCHAR(12),@QuestionId3),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.6 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId3)+').Answer == Answer('+CONVERT(VARCHAR(12),@Onehour)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@QuestionId4),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.6 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId3)+').Answer == Answer('+CONVERT(VARCHAR(12),@Twohour)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@QuestionId4),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.7 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId4)+').Answer != Answer('+CONVERT(VARCHAR(12),@AnswerId60)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId5),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId5)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans65)+')', CONVERT(VARCHAR(12),@EndOfBlock), CONVERT(VARCHAR(10),@QuestionId6),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId5)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans66)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId6),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId5)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans67)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId6),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId5)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans68)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId6),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId5)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans69)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId6),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId5)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans70)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId6),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId5)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans71)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId6),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId5)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans72)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId6),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.10
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId7)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans73)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId8),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.11 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId8)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans74)+')',CONVERT(VARCHAR(12),@QuestionId11),CONVERT(VARCHAR(10),@QuestionId9),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.12 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId9)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans75)+')',CONVERT(VARCHAR(12),@QuestionId11),CONVERT(VARCHAR(10),@QuestionId10),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.12
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId9)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans76)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId10),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.13 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId10)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans77)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId11),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.13 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId10)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans78)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@QuestionId11),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.14 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId11)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans79)+')',CONVERT(VARCHAR(12),@Welcome),CONVERT(VARCHAR(12),@EndOfBlock),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.14 
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId11)+').Answer == Answer('+CONVERT(VARCHAR(12),@Ans80)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(10),@Welcome),@SurveyId)
	INSERT INTO dbo.TR_MediaSkipLogic
	(LogicExpression,TrueAction,FalseAction,QuestionId)
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId6)+').Answer == Answer('+CONVERT(VARCHAR(12),@Montage1)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@QuestionId7),@SurveyId)
	INSERT INTO dbo.TR_MediaSkipLogic
	(LogicExpression,TrueAction,FalseAction,QuestionId)
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId6)+').Answer == Answer('+CONVERT(VARCHAR(12),@Montage2)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@QuestionId7),@SurveyId)
 
	INSERT INTO dbo.TR_MediaSkipLogic
	(LogicExpression,TrueAction,FalseAction,QuestionId)
	VALUES('Question('+CONVERT(VARCHAR(12),@QuestionId19)+').Answer == Answer('+CONVERT(VARCHAR(12),@TiredOf)+')',CONVERT(VARCHAR(12),@QuestionId35),CONVERT(VARCHAR(12),@QuestionId19),@SurveyId)


	---------
	
	
	SELECT @SurveyId AS NewSurveyId

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END