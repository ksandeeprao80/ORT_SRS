-- Survey Id = @SurveyId -- ORT SURVEY ID : 1129 -- PROD SURVEY ID : 1098
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
		'Adelaide November' AS SurveyName, 1 AS CustomerId, 1 AS StarMarked, 1 AS RewardEnabled,
		1 AS CreatedBy, GETDATE() AS CreatedDate, 1 AS InActive, 1 AS StatusId,
		1 AS CategoryId, 1 AS LanguageId, GETDATE()+25

	SET @SurveyId = @@IDENTITY

	------- START QUESTIONS AND ANSWERS ---------------------------------------------------------------------------

	DECLARE @Q1_1 INT
	SET @Q1_1 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions--Q1.1
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thank you for agreeing to take part in our online music survey!   This survey will only take a few moments of your time.  We appreciate your participation, your answers will help improve the radio you hear in Adelaide.  Importantly, we also require that the survey is totally completed by you alone and that you do not forward nor allow anyone other than you to access the survey.  Click NEXT>' AS QuestionText,
		1 AS IsDeleted, 1
	FROM MS_QuestionTypes WHERE QuestionCode = 'Welcome'

	SET @Q1_1 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_1, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 2 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	
	-------------------------------------------------------------------------------------------------

	DECLARE @Q753 INT
	SET @Q753 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions--Q753
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'In order to best participate, It is important to upgrade your browser to the most current available.  This will not only help you be safer when you surf the web, but it will also allow you to see all the graphics that are being displayed in this survey.  If you think you currently do not have the most current browser available, please go to one of the following sites depending on what browser you are using or you can upload any of these for free and use this browser to take your survey.Explorer 9 at:http://windows.microsoft.com/en-US/internet-explorer/products/ie/homeFirefox at:http://www.getfirefox.net/Google Chrome at:www.google.com/chrome/Once you''ve uploaded your upgraded browser or if you already have an upgraded browser, you are ready to begin!  Click next>' AS QuestionText,
	1 AS IsDeleted, 3
	FROM MS_QuestionTypes WHERE QuestionCode = 'PerceptIntro'

	SET @Q753 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q753, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 4 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	-------------------------------------------------------------------------------------------------

	DECLARE @Q1_2 INT
	SET @Q1_2 = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q1.2
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Check the box if you or any other member of your household work for any of the following types of companies.' AS QuestionText,
		1 AS IsDeleted, 5
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q1_2 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_2,'Market Research Company','Market Research Company'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_2,'Advertising Agency','Advertising Agency'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_2,'Radio or TV Station','Radio or TV Station'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_2,'The Press / Newspapers','The Press / Newspapers'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_2,'Music- Related Industry','Music- Related Industry'

	DECLARE @AnswerId1 INT
	SET @AnswerId1 = 0 
		INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_2,'None of these','None of these'
	SET @AnswerId1 = @@IDENTITY
--	If None of these Is Not Selected, Then Discontinue

	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_2, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings


	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 6 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------
	
	DECLARE @Q1_3 INT
	SET @Q1_3 = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q1.3
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your exact age?' AS QuestionText,
		1 AS IsDeleted, 7
	FROM MS_QuestionTypes WHERE QuestionCode = 'NumberInput'
	
	SET @Q1_3 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_3, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

--	If What is your exact age? Is Less Than 35, Then Skip To End of SurveyIf What is your exact age? Is Greater Than 49, Then Discontinue

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
	@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 8 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------

	DECLARE @Q1_4 INT
	SET @Q1_4 = 0
	INSERT INTO DBO.TR_SurveyQuestions--Q1.4
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Gender:' AS QuestionText,
		1 AS IsDeleted, 9
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q1_4 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_4, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_4,'Female','Female'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_4,'Male','Male'

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 10 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------


	DECLARE @Q1_8 INT
	SET @Q1_8 = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q1.8
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Think about listening to the radio from Monday - Friday - at home, at work, in your car or anywhere else.  How many hours in a typical day to you listen to the radio, Monday - Friday?' AS QuestionText,
		1 AS IsDeleted, 11 
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q1_8 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_8, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	DECLARE @AnswerId2 INT
	SET @AnswerId2 = 0 
		INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_8,'Less than 1 hour','Less than 1 hour'
	SET @AnswerId2 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_8,'1 hour or more but less than 2 hours','1 hour or more but less than 2 hours'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_8,'2 hours or more but less than 3 hour','2 hours or more but less than 3 hour'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_8,'More than 3 hours','More than 3 hours'

--	If Less than 1 hour Is Selected, Then Discontinue

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 12 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------

	DECLARE @Q1_9 INT
	SET @Q1_9 = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q1.9
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'List all of the Radio Stations you listen to in a typical day FOR MUSIC.' AS QuestionText,
		1 AS IsDeleted, 13
	FROM MS_QuestionTypes WHERE QuestionCode = 'MultiSelect'
	
	SET @Q1_9 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_9, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'SAFM (107.1)','SAFM (107.1)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'NOVA (91.9)','NOVA (91.9)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'FRESH (92.7)','FRESH (92.7)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'MIX (102.3)','MIX (102.3)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'Triple M (104.7)','Triple M (104.7)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'FLOW FM (99.5)','FLOW FM (99.5)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'WOW FM (100.5)','WOW FM (100.5)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'ABC CLASSIC FM (103.9)','ABC CLASSIC FM (103.9)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'LIFE FM (107.9)','LIFE FM (107.9)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_9,'OTHER','OTHER'

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 14 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------

	DECLARE @Q1_10 INT
	SET @Q1_10 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions--Q1.10 
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'When you have a choice, what is your favorite radio station to listen to FOR MUSIC?' AS QuestionText,
		1 AS IsDeleted, 15
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q1_10 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_10, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'SAFM (107.1)','SAFM (107.1)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'NOVA (91.9)','NOVA (91.9)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'FRESH (92.7)','FRESH (92.7)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'MIX (102.3)','MIX (102.3)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'Triple M (104.7)','Triple M (104.7)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'FLOW FM (99.5)','FLOW FM (99.5)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'WOW FM (100.5)','WOW FM (100.5)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'ABC CLASSIC FM (103.9)','ABC CLASSIC FM (103.9)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'LIFE FM (107.9)','LIFE FM (107.9)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_10,'OTHER','OTHER'

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 16 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	-------------------------------------------------------------------------------------------------
		
	DECLARE @Q1_12 INT
	SET @Q1_12 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions--Q1.12
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please let me know what you think of the music you have just heard.  If there were a radio station in your area that played this type of music, would you listen to that station Often, Once in a While or Never.' AS QuestionText,
		1 AS IsDeleted, 17
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q1_12 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_12, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,6) THEN 'False'  
				WHEN SettingId IN(5) THEN 'True'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8) THEN '' 
				WHEN SettingId IN(9) THEN '703' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_12,'Listen Often','Listen Often'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_12,'Listen Once in a While','Listen Once in a While'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_12,'Listen Never','Listen Never'

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 18 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	-------------------------------------------------------------------------------------------------
	
	DECLARE @Q1_13 INT
	SET @Q1_13 = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q1.13
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Would that type of music you just heard be your favorite type or would it be a second or third choice for you.' AS QuestionText,
		1 AS IsDeleted, 19
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q1_13 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_13, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_13,'This is my favorite type of music','This is my favorite type of music'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_13,'This would be my second or third choice for music','This would be my second or third choice for music'

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 20 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------
	
	DECLARE @Q1_14 INT
	SET @Q1_14 = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q1.14
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Have you taken part in research, such as focus groups or auditorium studies at a hotel or research facility or online study where you were paid to complete it.' AS QuestionText,
		1 AS IsDeleted, 21
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q1_14 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_14, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_14,'No Never','No Never'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_14,'I have but Less than 5 times','I have but Less than 5 times'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_14,'I have taken More than 5 surveys where I was paid to complete them','I have taken More than 5 surveys where I was paid to complete them'


	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 22 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------
	
	
	DECLARE @Q1_15 INT
	SET @Q1_15 = 0
	INSERT INTO DBO.TR_SurveyQuestions--Q1.15
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What was the topic of the study? (select one or more)' AS QuestionText,
		1 AS IsDeleted, 23
	FROM MS_QuestionTypes WHERE QuestionCode = 'MultiSelect'
	
	SET @Q1_15 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_15, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_15,'Financial','Financial'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_15,'Consumer Product','Consumer Product'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_15,'Music','Music'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_15,'Political','Political'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_15,'Television','Television'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_15,'Health / Medical','Health / Medical'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_15,'Radio','Radio'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_15,'Other','Other'

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 24 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
	-------------------------------------------------------------------------------------------------
	

	DECLARE @Q1_16 INT
	SET @Q1_16 = 0
	INSERT INTO DBO.TR_SurveyQuestions--Q1.16
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'When was the most recent research study in which you participated?' AS QuestionText,
		1 AS IsDeleted, 25
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q1_16 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_16, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_16,'More than 1 year ago','More than 1 year ago'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_16,'More than 2 months but less than 1 year ago','More than 2 months but less than 1 year ago'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_16,'Less than 2 months ago','Less than 2 months ago'

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 26
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	-------------------------------------------------------------------------------------------------
		

	DECLARE @Q1_17 INT
	SET @Q1_17 = 0
	INSERT INTO DBO.TR_SurveyQuestions--Q1.17
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Congratulations!  We would like to invite you to take part in an online music survey where you will be able to rate songs and give your opinions about music and entertainment that you like.  No one will attempt to sell you anything, and I think you will find the survey to be fun and rewarding.     In fact, we would like to give you a gift of $50 for taking the online music survey.  After you have completed the survey you will be asked for your name, address and phone number. This information will used to send you your $50.  Your information will not be sold to a third party.  You will also be asked if you are interested in participating in future music studies.  We will only use this information to send additional music/radio surveys only if you are interested in participating.      The survey will take approximately 2 hours, and is self-directed.  You can work at your own pace, starting and stopping at your convenience when you are connected to the internet.  We ask that you complete the survey within 48 hours of starting it and that you give the survey your full attention.     Importantly, we also require that the survey is totally completed by you alone and that you do not forward nor allow anyone other than you to access the survey.     Will you participate?' AS QuestionText,
		1 AS IsDeleted, 27
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q1_17 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_17, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_17,'Yes, sounds like fun','Yes, sounds like fun'

	DECLARE @AnswerId3 INT
	SET @AnswerId3 = 0 	 
		INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q1_17,'No','No'
	SET @AnswerId3 = @@IDENTITY

--	If No Is Selected, Then Discontinue 

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 28 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------
	
	
	DECLARE @Q1_18 INT
	SET @Q1_18 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions--Q1.18
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thank you for taking the time to participate in our survey.  Have a great day.' AS QuestionText,
		1 AS IsDeleted, 29
	FROM MS_QuestionTypes WHERE QuestionCode = 'PerceptIntro'

	SET @Q1_18 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_18, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 30 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	-------------------------------------------------------------------------------------------------
	
	DECLARE @Q1_19 INT
	SET @Q1_19 = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q1.19
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Welcome and Thank You for accepting our invitation to share your thoughts and feelings about the music you like to listen to.In this survey you will listen to and rate songs, and you may hear the same song a couple of times.  If at any time you cannot see the NEXT button, scroll down on the page you are viewing.  During the survey you are going to listen to short clips of songs and vote on those songs. You do not need to complete the survey in one sitting. Take as many breaks as you need, and come back when you are ready to continue.When you return, the survey will pick up right where you left off as long as you continue on the same computer using the same browser (i.e. Internet Explorer, Firefox, Chrome, or whatever browser you started with).   Your stopping point is saved by the survey system placing a ''cookie'' in your temporary folder to mark your progress so that your computer can communicate with the system. Please Do Not remove your cookies or delete your internet history until you have completed the survey.Click NEXT and lets begin with a few questions that will lead you into the music.' AS QuestionText,
		1 AS IsDeleted, 31
	FROM MS_QuestionTypes WHERE QuestionCode = 'Welcome'
	
	SET @Q1_19 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_19, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 32 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	
	-------------------------------------------------------------------------------------------------
	
	DECLARE @Q1_21 INT
	SET @Q1_21 = 0 
	
	INSERT INTO DBO.TR_SurveyQuestions--Q1.21
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Good news!  It is time for the music. You will hear song clips of about 6-8 seconds each.   After you listen to each clip, we will ask you to give a vote for each song:1=LOVE IT - One of your favorites.  You can have many favorites2=LIKE IT  - Not one of your favorites, but you like it3=JUST OK - not positive or negative toward the song4=TIRED OF-  it’s a song you’re so tired of hearing it that it may cause you to switch radio stations.5=HATE IT - it’s a song that you don’t like.6=I don''t know this song - you have never heard this song beforeVoting opens after you have listened to at least the first few seconds of the song clip.  If you wish to listen to that song clip again before voting, you can hit the ''play'' button again.Remember that this survey involves the playing of song clips through your computer''s speakers.  If you are taking this survey in an office or other public place, make sure to wear headphones!  Ready?  Let''s Go!  Click the ''next'' ( > ) button to get to the first song.' AS QuestionText,
		1 AS IsDeleted, 33
	FROM MS_QuestionTypes WHERE QuestionCode = 'MediaIntro'
	
	SET @Q1_21 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1_21, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 34 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
	
	-------------------------------------------------------------------------------------------------
	
	DECLARE @Q2_573 INT
	SET @Q2_573 = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q2.573
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS IsDeleted, 35
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @Q2_573 = @@IDENTITY

	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q2_573, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,5) THEN 'True'  
				WHEN SettingId IN(6) THEN 'False'
				WHEN SettingId IN(7) THEN '4'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q2_573, 'Love it','Love it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q2_573, 'Like it','Like it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q2_573, 'Just OK','Just OK'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q2_573, 'Tired of','Tired of'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q2_573, 'Hate it','Hate it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText) SELECT @Q2_573, 'I don''t know this song','I don''t know this song'

	
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 36 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'

	-------------------------------------------------------------------------------------------------

	---- PENDING *************************************************************************************
	--INSERT INTO DBO.TR_SurveyQuestions--
	--	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	--Q3.1 Thank you for participating in our survey.  You have been part of a small select group of participants that will help change the music you hear in Seattle.  We appreciate your time!  Below you will need to fill out your contact information.  We will use this to send your $50 participation fee.  Please be sure to double check your information for accuracy. 
	--First Name (1)
	--Last Name (2)
	--Street Address (3)
	--City (4)
	--State (5)
	--Post code (6)
	--email address (7)

	--  	INSERT INTO DBO.TR_SurveyQuestions
	--(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	--SELECT 
	--	@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 2 
	--FROM MS_QuestionTypes 
	--WHERE QuestionCode = 'PageBreak'

	---- PENDING *************************************************************************************

	DECLARE @ThankYou INT
	SET @ThankYou = 0

	INSERT INTO DBO.TR_SurveyQuestions--Q3.2 
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thank you.  We will send you a check shortly.  If you have not received the check within 30 days please contact us at: 1-206-347-2188.  It is important to us that this is a positive experience for you. Please let us know if you would be willing to be contacted for future MUSIC research studies.  If yes, we will use your email address to contact you for the next available study. Please keep in mind that the next study could be 6 months from now. Thank you again, Tina Paolella Music Research Department' AS QuestionText,
		1 AS IsDeleted, 37 
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


	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText, IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,1 AS IsDeleted, 38 
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'


	-- Additional Thaku added ---------------------------------------------------------------------------------------

	DECLARE @AddThanku INT 
	SET @AddThanku = 0
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 
		'<p>IMPORTANT:Please click the NEXT button to submit your completed survey!<br /> Thank you so much for your participation!</p>
		<p>Tina Paolella<br />Music Research Department</p>' AS QuestionText,
		1 AS IsDeleted, 39 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'ThankYou'
	
	SET @AddThanku = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @AddThanku, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

	
	-------------------------------------------------------------------------------------------------

	DECLARE @EndOfBlock INT
	SET @EndOfBlock = 0
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId,	'Sorry you did not qualify for survey, better luck next time.',
		1,40
	FROM MS_QuestionTypes WHERE QuestionCode = 'EndOfBlock'

	SET @EndOfBlock = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @EndOfBlock, SettingId, 
			CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9) THEN '' END AS Value 
	FROM MS_QuestionSettings

	
	--- END OF QUESTIONS AND ANSWERS --------------------------------------------------------------------------- 
	
	----- START SKIP LOGIC START  ---------------------------------------------------------------------------
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.2 
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_2)+').Answer != Answer('+CONVERT(VARCHAR(12),@AnswerId1)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_3),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.3 
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_3)+').Answer < 35',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_4),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.3 
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_3)+').Answer > 49',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_4),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)--Q1.4 
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_17)+').Answer == Answer('+CONVERT(VARCHAR(12),@AnswerId3)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_18),@SurveyId)
	INSERT INTO TR_SkipLogic(LogicExpression,TrueAction,FalseAction,SurveyId)----Q1.8
	VALUES('Question('+CONVERT(VARCHAR(12),@Q1_8)+').Answer == Answer('+CONVERT(VARCHAR(12),@AnswerId2)+')',CONVERT(VARCHAR(12),@EndOfBlock),CONVERT(VARCHAR(12),@Q1_9),@SurveyId)

	----- END SKIP LOGIC START  ---------------------------------------------------------------------------

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