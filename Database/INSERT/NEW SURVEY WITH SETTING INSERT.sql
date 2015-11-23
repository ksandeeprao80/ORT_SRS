BEGIN
BEGIN TRY
BEGIN TRAN

	DECLARE @SurveyId INT
	SET @SurveyId = 0 

	INSERT INTO DBO.TR_Survey
	(
		SurveyName,CustomerId,StarMarked,RewardEnabled,CreatedBy,CreatedDate,
		IsActive,StatusId,CategoryId,LanguageId
	)
	SELECT 
		'Hemant Kumar Music Survey' AS SurveyName, 1 AS CustomerId, 1 AS StarMarked, 1 AS RewardEnabled,
		1 AS CreatedBy, GETDATE() AS CreatedDate, 1 AS InActive, 1 AS StatusId,
		1 AS CategoryId, 1 AS LanguageId

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
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please indicate your Gender.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 1 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId, 'Female','Female' UNION
	SELECT @QuestionId, 'Male','Male' 

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'SingleChoicePageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 2 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

--2-------------------------------------------------------------------

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your Birthdate? (please answer in the format: mm/dd/yyyy)' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 3 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'TextInput'

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'What is your exact age?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 4 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'TextInput'


	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'TextInputPageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 5 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

--3-------------------------------------------------------------------

	DECLARE @QuestionId1 INT
	SET @QuestionId1 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please select all the radio station you listen to in a typical WEEK for MUSIC?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 6
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'MultiSelect'

	SET @QuestionId1 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId1, 'Magic 106.7','Magic 106.7' UNION
	SELECT @QuestionId1, 'Mix 104.1','Mix 104.1' UNION
	SELECT @QuestionId1, 'Kiss 108','Kiss 108' UNION
	SELECT @QuestionId1, 'WROR at 105.7FM','WROR at 105.7FM' UNION
	SELECT @QuestionId1, 'Other','Other' 	

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'MultiSelectPageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 7 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'


--4-------------------------------------------------------------------------

	DECLARE @QuestionId2 INT
	SET @QuestionId2 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Best voice?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 8 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'Boolean'
	
	SET @QuestionId2 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'Women','Good Singers' UNION
	SELECT @QuestionId2, 'Men','Good Singers'


	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'BooleanPageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 9 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

--6-------------------------------------------------------------------------------

	DECLARE @QuestionId3 INT
	SET @QuestionId3 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Which singer you want to hear in media' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 10 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId3 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, 'Mukesh','All Time Best' UNION
	SELECT @QuestionId3, 'Manna Dey','Best forever' UNION
	SELECT @QuestionId3, 'Lata','Koyal of India' UNION
	SELECT @QuestionId3, 'LataAsha','Koyal of India' UNION
	SELECT @QuestionId3, 'LataMukesh','Koyal of India' UNION
	SELECT @QuestionId3, 'LataRafi','Koyal of India' UNION
	SELECT @QuestionId3, 'Asha','Unique singer' 

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'SingleChoicePageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 11 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	--7-------------------------------------
----------------------------------------------------------------------------------------------------------
	DECLARE @QuestionId4 INT
	SET @QuestionId4 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Which singer you want to hear in media' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 12 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId4 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'Mukesh','All Time Best' UNION
	SELECT @QuestionId4, 'Manna Dey','Best forever' UNION
	SELECT @QuestionId4, 'Lata','Koyal of India' UNION
	SELECT @QuestionId4, 'LataAsha','Koyal of India' UNION
	SELECT @QuestionId4, 'LataMukesh','Koyal of India' UNION
	SELECT @QuestionId4, 'LataRafi','Koyal of India' UNION
	SELECT @QuestionId4, 'Asha','Unique singer' 

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'SingleChoicePageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 13 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'

	--8--------------------------------
	DECLARE @QuestionId5 INT
	SET @QuestionId5 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Which singer you want to hear in media' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 14 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId5 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Mukesh','All Time Best' UNION
	SELECT @QuestionId5, 'Manna Dey','Best forever' UNION
	SELECT @QuestionId5, 'Lata','Koyal of India' UNION
	SELECT @QuestionId5, 'LataAsha','Koyal of India' UNION
	SELECT @QuestionId5, 'LataMukesh','Koyal of India' UNION
	SELECT @QuestionId5, 'LataRafi','Koyal of India' UNION
	SELECT @QuestionId5, 'Asha','Unique singer' 

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'SingleChoicePageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 15
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	--9--------------------------------
	DECLARE @QuestionId6 INT
	SET @QuestionId6 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Which singer you want to hear in media' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 16
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId6 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId6, 'Mukesh','All Time Best' UNION
	SELECT @QuestionId6, 'Manna Dey','Best forever' UNION
	SELECT @QuestionId6, 'Lata','Koyal of India' UNION
	SELECT @QuestionId6, 'LataAsha','Koyal of India' UNION
	SELECT @QuestionId6, 'LataMukesh','Koyal of India' UNION
	SELECT @QuestionId6, 'LataRafi','Koyal of India' UNION
	SELECT @QuestionId6, 'Asha','Unique singer' 

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'SingleChoicePageBreak' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 17
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'PageBreak'
	--10--------------------------------
	DECLARE @QuestionId7 INT
	SET @QuestionId7 = 0

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Which singer you want to hear in media' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 18
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId7 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId7, 'Mukesh','All Time Best' UNION
	SELECT @QuestionId7, 'Manna Dey','Best forever' UNION
	SELECT @QuestionId7, 'Lata','Koyal of India' UNION
	SELECT @QuestionId7, 'LataAsha','Koyal of India' UNION
	SELECT @QuestionId7, 'LataMukesh','Koyal of India' UNION
	SELECT @QuestionId7, 'LataRafi','Koyal of India' UNION
	SELECT @QuestionId7, 'Asha','Unique singer' 

----------------------------------------------------------------------------------------------------------
	---------------------------------------------------
	INSERT INTO TR_SurveySettings
	(SurveyId, SettingId,CustomerId,Value)
	SELECT @SurveyId,SettingId,1,'True' 
	FROM MS_SurveySettings 
	---------------------------------------------------

COMMIT TRAN
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END





	
 
