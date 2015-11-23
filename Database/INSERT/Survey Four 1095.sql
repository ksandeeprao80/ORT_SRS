-- Suvey No = 4 -- PROD 1095
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
		'Asha Music Survey' AS SurveyName, 1 AS CustomerId, 1 AS StarMarked, 1 AS RewardEnabled,
		1 AS CreatedBy, GETDATE() AS CreatedDate, 1 AS InActive, 1 AS StatusId,
		1 AS CategoryId, 1 AS LanguageId, GETDATE()+22

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
	WHERE QuestionCode = 'Boolean'

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
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'BooleanPageBreak' AS QuestionText,
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
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Best Rock Artist?' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 0 AS HasMedia, 1 AS IsDeleted, 8 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'
	
	SET @QuestionId2 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId2, 'Michalel Jackson','Michalel Jackson' UNION
	SELECT @QuestionId2, 'Cliff Richard','Cliff Richard' UNION
	SELECT @QuestionId2, 'Pat Boonie','Pat Boonie' UNION
	SELECT @QuestionId2, 'Steve Wonder','Steve Wonder'

	INSERT INTO DBO.TR_SurveyQuestions
	(
		SurveyId,CustomerId,QuestionTypeId,QuestionText,ForceResponse,HasSkipLogic,
		HasEmailTrigger,HasMedia,IsDeleted, QuestionNo
	)
	SELECT 
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'SingleChoicePageBreak' AS QuestionText,
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
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 10 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId3 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId3, 'Mukesh','Love it' UNION
	SELECT @QuestionId3, 'Manna Dey','Like it' UNION
	SELECT @QuestionId3, 'Lata','Just OK' UNION
	SELECT @QuestionId3, 'LataAsha','Tired of' UNION
	SELECT @QuestionId3, 'LataMukesh','Hate it' UNION
	SELECT @QuestionId3, 'Asha','I don''t know this song' 

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
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 12 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId4 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId4, 'Mukesh','Love it' UNION
	SELECT @QuestionId4, 'Manna Dey','Like it' UNION
	SELECT @QuestionId4, 'Lata','Just OK' UNION
	SELECT @QuestionId4, 'LataAsha','Tired of' UNION
	SELECT @QuestionId4, 'LataMukesh','Hate it' UNION
	SELECT @QuestionId4, 'Asha','I don''t know this song' 

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
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 14 
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId5 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId5, 'Mukesh','Love it' UNION
	SELECT @QuestionId5, 'Manna Dey','Like it' UNION
	SELECT @QuestionId5, 'Lata','Just OK' UNION
	SELECT @QuestionId5, 'LataAsha','Tired of' UNION
	SELECT @QuestionId5, 'LataMukesh','Hate it' UNION
	SELECT @QuestionId5, 'Asha','I don''t know this song' 

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
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 16
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId6 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId6, 'Mukesh','Love it' UNION
	SELECT @QuestionId6, 'Manna Dey','Like it' UNION
	SELECT @QuestionId6, 'Lata','Just OK' UNION
	SELECT @QuestionId6, 'LataAsha','Tired of' UNION
	SELECT @QuestionId6, 'LataMukesh','Hate it' UNION
	SELECT @QuestionId6, 'Asha','I don''t know this song' 

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
		@SurveyId, 1 AS CustomerId, QuestionTypeId, 'Please tell me how much you like this song.' AS QuestionText,
		1 AS ForceResponse, 1 AS HasSkipLogic, 1 AS HasEmailTrigger, 1 AS HasMedia, 1 AS IsDeleted, 18
	FROM MS_QuestionTypes 
	WHERE QuestionCode = 'SingleChoice'

	SET @QuestionId7 = @@IDENTITY

	INSERT INTO DBO.TR_SurveyAnswers
	(QuestionId,Answer,AnswerText)
	SELECT @QuestionId7, 'Mukesh','Love it' UNION
	SELECT @QuestionId7, 'Manna Dey','Like it' UNION
	SELECT @QuestionId7, 'Lata','Just OK' UNION
	SELECT @QuestionId7, 'LataAsha','Tired of' UNION
	SELECT @QuestionId7, 'LataMukesh','Hate it' UNION
	SELECT @QuestionId7, 'Asha','I don''t know this song' 

	----------------------------------------------------------------------------------------------------------
	---------------------------------------------------
	-- TR_SurveySettings
-- 	INSERT INTO TR_SurveySettings
-- 	(SurveyId, SettingId,CustomerId,Value)
-- 	SELECT @SurveyId,SettingId,1,'True' FROM MS_SurveySettings 

	INSERT INTO TR_SurveySettings -- Back Button False
	(SurveyId, SettingId,CustomerId,Value)
	SELECT @SurveyId,SettingId,1,
		CASE WHEN LTRIM(RTRIM(SettingName)) = 'BTN_BACK' THEN 'False' ELSE 'True' END Value
	FROM MS_SurveySettings WHERE SettingName NOT LIKE '%FONT%'

	UPDATE TS
	SET TS.Value = CASE WHEN MS.SettingName = 'SurveyTemplateName' THEN 'surveyEngine1.html'
					WHEN MS.SettingName = 'SurveyThankuPage' THEN 'surveyEngine1_ThankYou.html' 
					WHEN MS.SettingName = 'SurveyWelcomePage' THEN 'surveyEngine1_welcome.html'  END
					--WHEN MS.SettingName = 'AutoAdvance' THEN 'False' END
	FROM TR_SurveySettings TS
	INNER JOIN MS_SurveySettings MS
		ON TS.SettingId = MS.SettingId	
	WHERE MS.SettingName IN('SurveyTemplateName','SurveyThankuPage','SurveyWelcomePage')

	
	INSERT INTO TR_SurveySettings
	(SurveyId, SettingId,CustomerId,Value)
	SELECT 
		@SurveyId,SettingId,1,
		CASE WHEN SettingName = 'ANSWER_FONT' THEN 'Sylfaen'
			WHEN SettingName = 'ANSWER_FONT_COLOR' THEN '#D6A869' 	  	
			WHEN SettingName = 'ANSWER_FONT_SIZE' THEN '12px'
			WHEN SettingName = 'HEADER_FONT' THEN 'Sylfaen'
			WHEN SettingName = 'HEADER_FONT_SIZE' THEN '18px'
			WHEN SettingName = 'HEADER_FONT_COLOR' THEN '#FFB0B0'   	 	
			WHEN SettingName = 'QUESTION_FONT' THEN 'Sylfaen'
			WHEN SettingName = 'QUESTION_FONT_COLOR' THEN '#FFDEAD' 
			WHEN SettingName = 'QUESTION_FONT_SIZE' THEN '14px' END AS Value
	FROM MS_SurveySettings WHERE SettingName LIKE '%FONT%'

	--SELECT * FROM MS_SurveySettings WHERE SettingName LIKE '%FONT%'
	--SELECT * FROM TR_SurveySettings WHERE SurveyId = 1095
	-- UPDATE TR_SurveySettings SET Value = '12px' WHERE SurveyId = 1095 AND SettingId = 8 -- ans
	-- UPDATE TR_SurveySettings SET Value = '#D6A869' WHERE SurveyId = 1095 AND SettingId = 9 -- ans
	-- UPDATE TR_SurveySettings SET Value = '#FFB0B0' WHERE SurveyId = 1095 AND SettingId = 33 -- hea
	-- UPDATE TR_SurveySettings SET Value = '#FFDEAD' WHERE SurveyId = 1095 AND SettingId = 24 -- que

	--------------------------------------------------- 
	
	-- TR_Library
	DECLARE @LibId INT
	SET @LibId = 0
	INSERT INTO DBO.TR_Library
	(LibTypeId,LibName,CustomerId,IsActive)
	SELECT LibTypeId,'File',1,1 FROM MS_LibraryType WHERE TypeName = 'GRAPHIC'

	SET @LibId = @@IDENTITY
	
	---- File Library
	DECLARE @FileLibId1 INT
	SET @FileLibId1 = 0
	INSERT INTO  TR_FileLibrary
	(LIBID,FileLibName,Category,FileName,FileType)
	VALUES(@LibId,'Disappeared_in_the_Wind_030_sec_preview','File','Disappeared_in_the_Wind_030_sec_preview.mp3',1) 
	SET @FileLibId1 = @@IDENTITY

	DECLARE @FileLibId2 INT
	SET @FileLibId2 = 0
	INSERT INTO  TR_FileLibrary
	(LIBID,FileLibName,Category,FileName,FileType)
	VALUES(@LibId,'Bonded_for_Life_030_sec_preview','File','Bonded_for_Life_030_sec_preview.mp3',1)
	SET @FileLibId2= @@IDENTITY

	DECLARE @FileLibId3 INT
	SET @FileLibId3 = 0
	INSERT INTO  TR_FileLibrary
	(LIBID,FileLibName,Category,FileName,FileType)
	VALUES(@LibId,'Box_of_Chocolates_030_sec_preview','File','Box_of_Chocolates_030_sec_preview.mp3',1)
	SET @FileLibId3= @@IDENTITY

	DECLARE @FileLibId4 INT
	SET @FileLibId4 = 0
	INSERT INTO  TR_FileLibrary
	(LIBID,FileLibName,Category,FileName,FileType)
	VALUES(@LibId,'Crazy_Motel_030_sec_preview','File','Crazy_Motel_030_sec_preview.mp3',1)
	SET @FileLibId4= @@IDENTITY

	DECLARE @FileLibId5 INT
	SET @FileLibId5 = 0
	INSERT INTO  TR_FileLibrary
	(LIBID,FileLibName,Category,FileName,FileType)
	VALUES(@LibId,'NeeleNeeleAmbarPar','File','NeeleNeeleAmbarPar.mp3',1)
	SET @FileLibId5= @@IDENTITY
	---------------------------------------

	INSERT INTO TR_MediaInfo -- AutoAdvance False
	(QuestionId,FileLibId,CustomerId,Randomize,AutoAdvance,ShowTitle,Autoplay,HideForSeconds)
	SELECT @QuestionId3,@FileLibId1,1,1,0,1,1,5 UNION
	SELECT @QuestionId4,@FileLibId2,1,1,0,1,1,5 UNION
	SELECT @QuestionId5,@FileLibId3,1,1,0,1,1,5 UNION
	SELECT @QuestionId6,@FileLibId4,1,1,0,1,1,5 UNION
	SELECT @QuestionId7,@FileLibId5,1,1,0,1,1,5

	INSERT INTO TR_SoundClipInfo
	(FileLibId,Title,Artist,FileLibYear,FilePath)
	SELECT FileLibId, FileName,'Sahgal','1950','' FROM TR_FileLibrary WHERE FileLibId = @FileLibId1 UNION
	SELECT FileLibId, FileName,'Hemant','1955','' FROM TR_FileLibrary WHERE FileLibId = @FileLibId2 UNION
	SELECT FileLibId, FileName,'Mukesh','1960','' FROM TR_FileLibrary WHERE FileLibId = @FileLibId3 UNION
	SELECT FileLibId, FileName,'Rafi','1965','' FROM TR_FileLibrary WHERE FileLibId = @FileLibId4 UNION
	SELECT FileLibId, FileName,'Lata','1970','' FROM TR_FileLibrary  WHERE FileLibId = @FileLibId5

	SELECT @SurveyId AS NewSurveyId

COMMIT TRAN
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END





	
 
