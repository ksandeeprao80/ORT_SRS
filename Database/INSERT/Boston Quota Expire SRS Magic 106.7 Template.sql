-- 1157
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
		'Boston SRS Magic 106.7 Template' AS SurveyName, 1 AS CustomerId, 1 AS StarMarked, 1 AS RewardEnabled,
		1 AS CreatedBy, GETDATE() AS CreatedDate, 1 AS InActive, 1 AS StatusId,
		1 AS CategoryId, 1 AS LanguageId, GETDATE()+25

	SET @SurveyId = @@IDENTITY
	
--------------------------------------------------------------------

	DECLARE @VALIDATION INT
	SET @VALIDATION = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please enter the first name of the person who hosts our popular “MAGIC NIGHTSHIFT”.' AS QuestionText,
		1 AS IsDeleted, 1
	FROM MS_QuestionTypes WHERE QuestionCode = 'TextInput'
	
	SET @VALIDATION = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @VALIDATION, SettingId, 
			CASE WHEN SettingId IN(1,3,14) THEN 'True'  
				WHEN SettingId IN(2,4,5,6,10,11,13,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,12) THEN '' 
				WHEN SettingId IN(15) THEN 'MICHAEL' 
				END AS Value  
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 2
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'	


--------------------------------------------------------------------

	--Q1 
	DECLARE @Q1 INT
	SET @Q1 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'THANK YOU for accepting our invitation to help shape the sound of Magic 106.7!       We are excited to hear what you have to say about the music we play.     In this survey you will be listening to and rating songs according to how much you love them, love them...like them...or hate them.  Don''t be surprised if you hear the same song more than once.  If at any time you cannot see the NEXT button, scroll down on the page you are viewing.  We value your time, so we want to make taking this survey convenient for you.  Here''s the deal:  You don''t need to complete this survey in one sitting.  Take as many breaks as you need and come back when you are ready to continue.       When you return, the survey will pick up right where you left off.  But there''s one important detail to remember:  Make sure you are using the same computer and the same browser you started with (i.e. Internet Explorer, Firefox, Chrome or whatever browser you started with).  Your stopping point is saved by the survey system, which places a ''cookie'' in your temporary folder to mark your progress.  That''s how your computer communicates with the system.  So, please do NOT remove your cookies or delete your internet history until you have completed the survey.       During the survey you are going to listen to short clips of songs and vote on those songs. You do not need to complete the survey in one sitting. Take as many breaks as you need, and come back when you are ready to continue.     Are you ready to begin?  Just click NEXT and let''s get started with a few questions that will lead you to the good part...THE MUSIC!     Click NEXT and lets begin with a few questions that will lead you into the music.' AS QuestionText,
		1 AS IsDeleted, 3
	FROM MS_QuestionTypes WHERE QuestionCode = 'Welcome'
	
	SET @Q1 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q1, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,12,15) THEN '' END AS Value  
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 4
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'	
--------------------------------------------------------------------
	--	-- Q2
	--	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	--Q2 Browser Meta Info
	--Browser (1)
	--Version (2)
	--Operating System (3)
	--Screen Resolution (4)
	--Flash Version (5)
	--Java Support (6)
	--User Agent (7)
--------------------------------------------------------------------

	DECLARE @ImageDisplay INT
	SET @ImageDisplay = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, '(Image Display, Single Choice). Identify the object in the image below' AS QuestionText,
		1 AS IsDeleted, 5
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @ImageDisplay = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @ImageDisplay, SettingId, 
			CASE WHEN SettingId IN(1,3,6) THEN 'True'  
				WHEN SettingId IN(2,4,5,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(9,12,15) THEN '' 
				WHEN SettingId IN(8) THEN '353' 
				END AS Value  
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @ImageDisplay, 'Flower','Flower' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @ImageDisplay, 'Animal','Animal' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @ImageDisplay, 'Other','Other' 

	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 6
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'	

--------------------------------------------------------------------

	-- Q4
	DECLARE @4 INT
	SET @4 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please indicate your Gender:' AS QuestionText, 1 AS IsDeleted, 7
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'
	
	SET @4 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @4, 'Male','Male' 
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @4, 'Female','Female' 
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @4, SettingId, 
			CASE WHEN SettingId IN(1,2,3,10,11) THEN 'True'  
				WHEN SettingId IN(4,5,6,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,15) THEN '' 
				WHEN SettingId IN (12) THEN '3'
				END AS Value  
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 8
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
		
--------------------------------------------------------------------
	-- Q7
	DECLARE @Q7 INT
	SET @Q7 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your exact age?' AS QuestionText, 1 AS IsDeleted, 9
	FROM MS_QuestionTypes WHERE QuestionCode = 'NumberInput'
	
	SET @Q7 = @@IDENTITY

	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q7, SettingId, 
			CASE WHEN SettingId IN(1,2,3,10,11) THEN 'True'  
				WHEN SettingId IN(4,5,6,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,15) THEN '' 
				WHEN SettingId IN (12) THEN '1'
				END AS Value  
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 10
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
		
--------------------------------------------------------------------
	-- Q9
 	DECLARE @Q9 INT
	SET @Q9 = 0

	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please select ALL the radio stations you listen to in a typical WEEK for MUSIC.' AS QuestionText,
		1 AS IsDeleted, 11
	FROM MS_QuestionTypes WHERE QuestionCode = 'MultiSelect'

	SET @Q9 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q9,'Magic 106.7','Magic 106.7'  
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q9,'Mix 104.1','Mix 104.1'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q9,'Kiss 108','Kiss 108'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q9,'WROR at 105.7FM','WROR at 105.7FM'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q9,'Other','Other'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q9, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,12,15) THEN '' END AS Value  
	FROM MS_QuestionSettings
	

	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 12
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
--------------------------------------------------------------------
	-- Q66
	DECLARE @Q66 INT
	SET @Q66 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please select the radio station that is your FAVORITE to listen to when you can make the choice?' AS QuestionText,
		1 AS IsDeleted, 13
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q66 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q66,'Magic 106.7','Magic 106.7'  
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q66,'Mix 104.1','Mix 104.1'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q66,'Kiss 108','Kiss 108'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q66,'WROR at 105.7FM','WROR at 105.7FM'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q66,'Other','Other'
 
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q66, SettingId, 
			CASE WHEN SettingId IN(1,2,3) THEN 'True'  
				WHEN SettingId IN(4,5,6,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,12,15) THEN '' END AS Value  
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 14
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
--------------------------------------------------------------------
	-- Q87
	DECLARE @Q87 INT
	SET @Q87 = 0
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
 		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'I would like you to listen to a short group of song clips.  Listen to the music and please let me know what you think of the music you have just heard.    If there were a radio station in your area that played this type of music, would you listen to that station Often, Once in a While or Never.    When you are ready to listen to the music, click the ''play'' button on your audio player (the ''>'' button).  Remember, if you are listening to this music in a public setting, please wear headphones.   (Please listen to the entire group of song clips before you vote.)' AS QuestionText,
		1 AS IsDeleted, 15
 	FROM MS_QuestionTypes 
 	WHERE QuestionCode = 'SingleChoice'

	SET @Q87 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q87, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,6,10,11,13,14,16) THEN 'False'  
				WHEN SettingId IN(5) THEN 'True'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,12,15) THEN '' 
				WHEN SettingId IN(9) THEN '703' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q87,'Listen Often','Listen Often'  
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q87,'Listen Sometimes','Listen Sometimes'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q87,'Never Listen','Never Listen'
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 16
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
--------------------------------------------------------------------
	-- Q15
	DECLARE @Q15 INT
	SET @Q15 = 0
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'It is time for you to listen to and rate music.   You will be hearing song clips that are each about 6-8 seconds long.   After you listen to each clip, we''ll ask you to give a vote on each song:1=LOVE IT - One of your favorites.  You can have as many favorites as you want!2=LIKE IT  - Not one of your favorites, but you like it3=JUST OK - You don''t have any positive or negative feelings about the song4=TIRED OF-  It’s a song you’re so sick of hearing...it may cause you to switch radio stations5=HATE IT - It’s a song that makes you switch stations - you don''t like it at all!6=I DON''T KNOW THIS SONG - You have never heard this song beforeVoting opens after you have listened to at least the first few seconds of the song clip.  If you wish to listen to that song clip again before voting, you can hit the ''play'' button again.Remember that this survey involves playing song clips through your computer''s speakers.  If you are taking this survey in your  office or other public place, you might want to wear headphones!  Ready?  Let''s Go!  Click the ''next'' ( > ) button to get to the first song.' AS QuestionText,
		1 AS IsDeleted, 17
	FROM MS_QuestionTypes WHERE QuestionCode = 'MediaIntro'
	
	SET @Q15 = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q15, SettingId, 
		CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,12,15) THEN '' END AS Value 
	FROM MS_QuestionSettings

	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 18
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
	
--------------------------------------------------------------------
	-- Q152
	DECLARE @Q152 INT
	SET @Q152 = 0

	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS IsDeleted, 19
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q152 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q152,'Love it','Love it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q152,'Like it','Like it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q152,'Just OK','Just OK'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q152,'Tired of','Tired of'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q152,'Hate it','Hate it'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q152,'I don''t know this song','I don''t know this song'
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q152, SettingId, 
			CASE WHEN SettingId IN(1,2,3,4,5) THEN 'True'  
				WHEN SettingId IN(6,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '4'
				WHEN SettingId IN(8,9,12,15) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 20
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'	
	
--------------------------------------------------------------------
	-- Q69
	DECLARE @Q69 INT
	SET @Q69 = 0

	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'How would you rate your survey experience, with ''5'' meaning it was ''Very Negative'' and ''1'' meaning ''Very Positive'' and anywhere in between?' AS QuestionText,
		1 AS IsDeleted, 21
	FROM MS_QuestionTypes WHERE QuestionCode = 'SingleChoice'

	SET @Q69 = @@IDENTITY
	
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q69,'Very Positive(1)','Very Positive(1)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q69,'2(2)','2(2)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q69,'3(3)','3(3)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q69,'4(4)','4(4)'
	INSERT INTO DBO.TR_SurveyAnswers (QuestionId,Answer,AnswerText)
	SELECT @Q69,'Very Negative(5)','Very Negative(5)'
	 
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @Q69, SettingId, 
		CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,12,15) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
	INSERT INTO DBO.TR_SurveyQuestions (SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT @SurveyId, 1 AS CustomerId, QuestionTypeId, 'PageBreak' AS QuestionText, 1 AS IsDeleted, 22
	FROM MS_QuestionTypes WHERE QuestionCode = 'PageBreak'
		
--------------------------------------------------------------------
	-- Q68
	--	INSERT INTO DBO.TR_SurveyQuestions--Q1.2 
	--	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	--Answer IfPanelEmailIsNot Equal to1
	-- Tell us a little about yourself.  This information will be kept confidential.  If you would like to participate in future surveys for Magic 106.7, please include the best email address for participation.  Click 'Next' when finished.
	--First Name (1)
	--Last Name (2)
	--Email (3)
	--Gender (4)
	--------------------------------------------------------------------

	-------------------------------
	
	DECLARE @AddThanku INT 
	SET @AddThanku = 0
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 
		'<p>IMPORTANT:Please click the NEXT button to submit your completed survey!<br /> Thank you so much for your participation!</p>
		<p>Tina Paolella<br />Music Research Department</p>' AS QuestionText,
		1 AS IsDeleted, 23 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'ThankYou'
	
	SET @AddThanku = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @AddThanku, SettingId, 
		CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,12,15) THEN '' END AS Value 
	FROM MS_QuestionSettings
	--------------------------------------------------

	DECLARE @EndOfBlock INT
	SET @EndOfBlock = 0
	INSERT INTO DBO.TR_SurveyQuestions
	(SurveyId,CustomerId,QuestionTypeId,QuestionText,IsDeleted, QuestionNo)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId,	'Sorry you did not qualify for survey, better luck next time.',
		1,24
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'EndOfBlock'
	
	SET @EndOfBlock = @@IDENTITY
	
	INSERT INTO TR_QuestionSettings(QuestionId,SettingId,Value)
	SELECT @EndOfBlock, SettingId, 
		CASE WHEN SettingId IN(1,3) THEN 'True'  
				WHEN SettingId IN(2,4,5,6,10,11,13,14,16) THEN 'False'
				WHEN SettingId IN(7) THEN '0'
				WHEN SettingId IN(8,9,12,15) THEN '' END AS Value 
	FROM MS_QuestionSettings
	
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
	-- If CheckQuota is true then there should be value in QuotaCount 
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings WHERE SettingName = 'CheckQuota'
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value) SELECT @SurveyId,SettingId,1,'3' FROM MS_SurveySettings WHERE SettingName = 'QuotaCount' 
	-- Quota Expire
	INSERT INTO TR_SurveySettings(SurveyId,SettingId,CustomerId,Value)SELECT @SurveyId,SettingId,1,'surveyEngine1_QuotaExpire.html' FROM MS_SurveySettings WHERE SettingName = 'QuotaExpirePage' 
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
