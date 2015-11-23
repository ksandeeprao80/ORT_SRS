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
		'Survey October 2012' AS SurveyName, 1 AS CustomerId, 1 AS StarMarked, 1 AS RewardEnabled,
		1 AS CreatedBy, GETDATE() AS CreatedDate, 1 AS InActive, 1 AS StatusId,
		1 AS CategoryId, 1 AS LanguageId, GETDATE()+25

	SET @SurveyId = @@IDENTITY

--1-----------------------------------------------

	DECLARE @QuestionId INT
	SET @QuestionId = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Check the box if you or any other member of your household work for any of the following types of companies.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 1 
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
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId,'None of these','None of these'
	
--2-----------------------------------------------		
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your exact age?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 2
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'TextInput'
	
--3-----------------------------------------------
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 3 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
--4-----------------------------------------------
	
	DECLARE @QuestionId1 INT
	SET @QuestionId1 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Gender:' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 4 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId1 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId1, 'Female','Female' UNION
	SELECT @QuestionId1, 'Male','Male' 
	
--5-----------------------------------------------

	DECLARE @QuestionId2 INT
	SET @QuestionId2 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Ethnic Background' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 5 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId2 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'White/Caucasian','White/Caucasian'  
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'African American / Black','African American / Black' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'Asian','Asian' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'Hispanic / Latino','Hispanic / Latino' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'Other race or ethnic background','Other race or ethnic background'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'Decline to answer','Decline to answer'

--6-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 6 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
--7-----------------------------------------------	
	
	DECLARE @QuestionId3 INT
	SET @QuestionId3 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Think about listening to the radio from Monday - Friday - at home, at work, in your car or anywhere else.  How many hours in a typical day to you listen to the radio, Monday - Friday?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 7 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId3 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, 'Less than 1 hour','Less than 1 hour'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, '1 hour or more but less than 2 hours','1 hour or more but less than 2 hours'	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, '2 hours or more but less than 3 hour','2 hours or more but less than 3 hour'	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, 'More than 3 hours','More than 3 hours'
	
--8-----------------------------------------------
	
	DECLARE @QuestionId4 INT
	SET @QuestionId4 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'List all of the Radio Stations you listen to in a typical week for at least one hour FOR MUSIC.Think about ALL of the occasions in which you listen to each station during your typical week.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 8
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'MultiSelect'

	SET @QuestionId4 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'Click 98.9FM','Click 98.9FM' 
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
	
--9-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 9
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	 
--10-----------------------------------------------
	 
	DECLARE @QuestionId5 INT
	SET @QuestionId5 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'When you have a choice, what is your favorite radio station to listen to FOR MUSIC?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 10 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId5 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Click 98.9FM','Click 98.9FM' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, '107.7 The End','107.7 The End'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, '106.1 Kiss FM','106.1 Kiss FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'KUBE 93.3 FM','KUBE 93.3 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, '94.1 KMPS','94.1 KMPS'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Movin 92.5 FM','Movin 92.5 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Star 101.5','Star 101.5'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Warm 106.9','Warm 106.9'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'The Wolf 100.7 FM','The Wolf 100.7 FM'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Other','Other'

--11-----------------------------------------------
		
	--DECLARE @QuestionId6 INT -- Song to play for 25 seconds
	--SET @QuestionId6 = 0
	
	--INSERT INTO DBO.TR_SurveyQuestions
	--(
	--	SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
	--	HasEmailTrigger,HasMedia,IsDeleted, QuestionNo, PlayListId 
	--)
	--SELECT 
	--	@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Now please listen to a montage of song clips, which lasts about 25 seconds.  Please listen to the entire group of song clips before you answer this question:  If there were a radio station in your area that played this type of music, would you listen to that station Often, Once in a While or Never. Click the ''Play'' button when you are ready to listen to the music.  If you are in a public place or open office, make sure to watch your volume or wear headphones.' AS QuestionText,
	--	1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 11, 4 
	--FROM MS_QuestionTypes 
	--WHERE QuestionCode = 'SingleChoice'
	
	--SET @QuestionId6 = @@IDENTITY
	
	--INSERT INTO DBO.TR_SurveyAnswers
	--(QuestionId,Answer,AnswerText)
	--SELECT @QuestionId6, 'Listen Often','Listen Often'
	--INSERT INTO DBO.TR_SurveyAnswers
	--(QuestionId,Answer,AnswerText)
	--SELECT @QuestionId6, 'Listen Once in a While','Listen Once in a While'
	--INSERT INTO DBO.TR_SurveyAnswers
	--(QuestionId,Answer,AnswerText)
	--SELECT @QuestionId6, 'Listen Never','Listen Never'

--12-----------------------------------------------
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 11
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

--13-----------------------------------------------
	
	DECLARE @QuestionId7 INT  
	SET @QuestionId7 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Would that type of music you just heard be your favorite type or would it be a second or third choice for you.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 12 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId7 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId7, 'This is my favorite type of music','This is my favorite type of music'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId7, 'This would be my second or third choice for music','This would be my second or third choice for music'
	
--14-----------------------------------------------
	
	DECLARE @QuestionId8 INT  
	SET @QuestionId8 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Have you taken part in research, such as focus groups or auditorium studies at a hotel or research facility or online study where you were paid to complete it.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 13 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId8 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId8, 'No Never','No Never'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId8, 'I have but Less than 5 times','I have but Less than 5 times'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId8, 'I have taken More than 5 surveys where I was paid to complete them','I have taken More than 5 surveys where I was paid to complete them'
	 
--15-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 14
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
--16-----------------------------------------------
	
	DECLARE @QuestionId9 INT  
	SET @QuestionId9 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'When was the most recent research study in which you participated?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 15 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId9 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId9, 'More than 1 year ago','More than 1 year ago'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId9, 'More than 2 months but less than 1 year ago','More than 2 months but less than 1 year ago'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId9, 'Less than 2 months ago','Less than 2 months ago'
	
--17-----------------------------------------------

	DECLARE @QuestionId10 INT  
	SET @QuestionId10 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What was the topic of the study? (select one or more)' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 16
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'MultiSelect'

	SET @QuestionId10 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Financial','Financial' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Consumer Product','Consumer Product' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Music','Music' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Political','Political' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Television','Television' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Health / Medical','Health / Medical' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Radio','Radio' 
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId10, 'Other','Other' 

--18-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 17
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
--19-----------------------------------------------	

	DECLARE @QuestionId11 INT  
	SET @QuestionId11 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Congratulations!  We would like to invite you to take part in an online music survey where you will be able to rate songs and give your opinions about music and entertainment that you like.  No one will attempt to sell you anything, and I think you will find the survey to be fun and rewarding.     The survey will take approximately 2 hours, and is self-directed.  You can work at your own pace, starting and stopping at your convenience when you are connected to the internet.  We ask that you complete the survey within 48 hours of starting it and that you give the survey your full attention.     Importantly, we also require that the survey is totally completed by you alone and that you do not forward nor allow anyone other than you to access the survey.     Will you participate?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 18 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId11 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId11, 'Yes, sounds like fun','Yes, sounds like fun'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId11, 'No','No'
	
--20-----------------------------------------------
	
	DECLARE @QuestionId12 INT  
	SET @QuestionId12 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your favorite radio station to listen to FOR MUSIC?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 19
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

--21-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 20
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'


---**********************************************************************

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Welcome and Thank You for accepting our invitation to share your thoughts and feelings about the music you like to listen to.In this survey you will listen to and rate songs, and you may hear the same song a couple of times.  If at any time you cannot see the NEXT button, scroll down on the page you are viewing.  During the survey you are going to listen to short clips of songs and vote on those songs. You do not need to complete the survey in one sitting. Take as many breaks as you need, and come back when you are ready to continue.When you return, the survey will pick up right where you left off as long as you continue on the same computer using the same browser (i.e. Internet Explorer, Firefox, Chrome, or whatever browser you started with).   Your stopping point is saved by the survey system placing a ''cookie'' in your temporary folder to mark your progress so that your computer can communicate with the system. Please Do Not remove your cookies or delete your internet history until you have completed the survey.Click NEXT and lets begin with a few questions that will lead you into the music.' AS QuestionText,
		1 AS ForceResponse, 0 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 21
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'Welcome'
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 0 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 22
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
	
--22-----------------------------------------------

	DECLARE @QuestionId13 INT  
	SET @QuestionId13 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What radio station has been getting BETTER lately in terms of MUSIC?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 23 
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

--23-----------------------------------------------
	
	DECLARE @QuestionId14 INT  
	SET @QuestionId14 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What radio station has been getting WORSE lately, in terms of its MUSIC?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 24
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
	
--24-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 25
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
--25-----------------------------------------------

	DECLARE @QuestionId15 INT  
	SET @QuestionId15 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has Click 98.9 been:' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 26 
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

--26-----------------------------------------------

	DECLARE @QuestionId16 INT  
	SET @QuestionId16 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has 107.7 The End been:' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 27
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
 
 --27-----------------------------------------------
 
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 28
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

--28-----------------------------------------------

	DECLARE @QuestionId17 INT  
	SET @QuestionId17 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has 106.1 Kiss FM been:' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 29 
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
 
--29-----------------------------------------------

	DECLARE @QuestionId18 INT  
	SET @QuestionId18 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thinking about the past few months, has Star 101.5 been:' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 30 
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
 
 --30-----------------------------------------------
 
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 31
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
--31-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Good news!  It is time for the music. You will hear song clips of about 6-8 seconds each.   After you listen to each clip, we will ask you to give a vote for each song:1=LOVE IT - One of your favorites.  You can have many favorites2=LIKE IT  - Not one of your favorites, but you like it3=JUST OK - not positive or negative toward the song4=TIRED OF-  it’s a song you’re so tired of hearing it that it may cause you to switch radio stations.5=HATE IT - it’s a song that you don’t like.6=I DON''T KNOW THIS SONG - you have never heard this song beforeVoting opens after you have listened to at least the first few seconds of the song clip.  If you wish to listen to that song clip again before voting, you can hit the ''play'' button again.Remember that this survey involves the playing of song clips through your computer''s speakers.  If you are taking this survey in an office or other public place, make sure to wear headphones!  Ready?  Let''s Go!  Click the ''next'' ( > ) button to get to the first song.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 32
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'MediaIntro'
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 33
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

	------------------ MEDIA --------------------------
	DECLARE @QuestionId19 INT  
	SET @QuestionId19 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo,PlayListId 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 34,4
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
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'Tired of','Tired of'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'Hate it','Hate it'
	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId19,'I don''t know this song','I don''t know this song'
	
	
	DECLARE @QuestionId35 INT  
	SET @QuestionId35 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'How much are you tried of it ?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 35
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

--32-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 36
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
--33-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'There are just a few more questions we would like to ask before the end of this survey.  Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.  Click the >> button when you are ready to proceed.' AS QuestionText,
		1 AS ForceResponse, 0 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 37 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'ThankYou'


	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 38
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'



----------------------------------------------

	DECLARE @QuestionId20 INT  
	SET @QuestionId20 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Here is the next group of songs. Click the ''Play'' button when you are ready to listen to the music.  (remember to wear headphones if you are listening in a public place)           When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:  If a radio station played the kind of music you just heard, would you:' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 39
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PerceptIntro'
	
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
	
--34-----------------------------------------------

	DECLARE @QuestionId21 INT  
	SET @QuestionId21 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 40 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PerceptIntro'
	
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

--35-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 41
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

--36-----------------------------------------------

	DECLARE @QuestionId22 INT  
	SET @QuestionId22 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.    Click the &#39;Play&#39; button when you are ready to listen to the music.  (remember to wear headphones if you are listening in a public place)        When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:     If a radio station played the kind of music you just heard, would you:' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 42 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PerceptIntro'
	
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
   
--37-----------------------------------------------

	DECLARE @QuestionId23 INT  
	SET @QuestionId23 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 43 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PerceptIntro'
	
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
	
--38-----------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 44
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

 --39-----------------------------------------------
 
	DECLARE @QuestionId24 INT  
	SET @QuestionId24 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'There are just a few more questions we would like to ask before the end of this survey.Next, please listen to this group of songs.  You do NOT need to vote on the individual songs.        When the music is finished playing, please answer two questions...only thinking about the group of songs you just heard:  If a radio station played the kind of music you just heard, would you:' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 45
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PerceptIntro'
	
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
	
--40-----------------------------------------------

	DECLARE @QuestionId25 INT  
	SET @QuestionId25 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Is there a radio station that sounds like what you just heard?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 46 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PerceptIntro'
	
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
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText,
		1 AS ForceResponse, 0 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 47
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	
	
	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo 
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Thank you so much for your participation' AS QuestionText,
		1 AS ForceResponse, 0 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 48 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'ThankYou'
	
	
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,1,1,'True')--BTN_BACK
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,2,1,'True')--BTN_SAVECONTIUNE
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,3,1,'True')--CB_DEFAULTEOS
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,4,1,'True')--CB_OPENACCESS
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,5,1,'True')--ALLOW_ANONYMOUS
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,6,1,'False')--ALLOW_REPEAT
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,7,1,'True')--ALLOW_SAVE_CONTINUE
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,8,1,'Verdana')--ANSWER_FONT
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,9,1,'#191970')--ANSWER_FONT_COLOR
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,10,1,'12px')--ANSWER_FONT_SIZE
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,12,1,'False')--BY_INVITE
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,13,1,'False')--E_O_S_EMAIL
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,14,1,'False')--E_O_S_MESSAGE
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,15,1,'')--E_O_S_EMAIL_ID
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,16,1,'6')--E_O_S_MESSAGE_ID
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,17,1,'')--E_O_S_REDIRECT_URL
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,18,1,'Verdana')--HEADER_FONT
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,19,1,'20px')--HEADER_FONT_SIZE
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,20,1,'True')--HEADER_SHOW_DATE_TIME
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,21,1,'True')--HEADER_TEXT_COLOR
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,22,1,'False')--INVITE_HAS_PSW
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,23,1,'Verdana')--QUESTION_FONT
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,24,1,'#fff')--QUESTION_FONT_COLOR
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,25,1,'14px')--QUESTION_FONT_SIZE
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,26,1,'True')--AutoAdvance
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,27,1,'')--BackGroundColor
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,28,1,'False')--E_O_S_REDIRECT
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,29,1,'')--LogoFile
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,30,1,'surveyEngine1.html')--SurveyTemplateName
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,31,1,'surveyEngine1_ThankYou.html')--SurveyThankuPage
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,32,1,'surveyEngine1_welcome.html')--SurveyWelcomePage
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,33,1,'#fff')--HEADER_FONT_COLOR
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,34,1,'False')--PipingIn
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,36,1,'True')--ValidationAnswerValues
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,37,1,'False')--CheckQuotas
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,38,1,'False')--NextBackTextLink
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,39,1,'True')--CheckSurveyEnd
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,40,1,'False')--RewardSet
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,41,1,'True')--FollowupMTBQue
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,42,1,'False')--VerificationQuestion
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,43,1,'False')--2ndValidation
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,44,1,'True')--SkipLogic
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,47,1,'SurveyEngine1_Expired.html')--SurveyExpiredPage
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,48,1,'surveyEngine1_Rewards.html')--SurveyRewardPage
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,49,1,'True') --RandomizeTestList
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) VALUES (@SurveyId,50,1,'25')--TestListRandomNo 

	SELECT @SurveyId AS NewSurveyId

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END