IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyResponse]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveSurveyResponse

GO  
/*
EXEC UspSaveSurveyResponse '<?xml version="1.0" encoding="utf-16"?>
<ArrayOfResponses>
	<Responses>
		<SurveyId>1134</SurveyId>
		<SessionId>Jd Test</SessionId>
		<Question>
			<QuestionId>10494</QuestionId>
			<QuestionType>SingleChoice</QuestionType>
			<ForceResponse>false</ForceResponse>
			<HasSkipLogic>false</HasSkipLogic>
			<HasEmailTrigger>false</HasEmailTrigger>
			<HasMedia>false</HasMedia>
			<IsDeleted>false</IsDeleted>
			<SongId>1</SongId>
			<Config> 
				<IsPipedOut>True</IsPipedOut>
				<QuestionTagId>Sex</QuestionTagId>
				<IsPipedIn>True</IsPipedIn>
			</Config>
		</Question>
		<Answer>
			<Answer>
				<AnswerId>108729</AnswerId>
				<AnswerText>Female</AnswerText>
			</Answer>
		</Answer>
		<Respondent>
			<RespondentId>1</RespondentId>
			<IsRespondentDeleted>false</IsRespondentDeleted>
			<IsRespondentActive>false</IsRespondentActive>
		</Respondent>
		<ResponseSessionId>fthy5q45c0enuo55zaswrw55</ResponseSessionId>
		<IpAddress></IpAddress>
	</Responses>
	<Responses>
		<SurveyId>1134</SurveyId>
		<SessionId>abc</SessionId>
		<Question>
			<QuestionId>10496</QuestionId>
			<QuestionType>TextInput</QuestionType>
			<ForceResponse>false</ForceResponse>
			<HasSkipLogic>false</HasSkipLogic>
			<HasEmailTrigger>false</HasEmailTrigger>
			<HasMedia>false</HasMedia>
			<IsDeleted>false</IsDeleted>
			<SongId>1</SongId>
			<Config> 
				<IsPipedOut>True</IsPipedOut>
				<QuestionTagId>Age</QuestionTagId>
				<IsPipedIn>True</IsPipedIn>
			</Config>
		</Question>
		<Answer>
			<Answer>
				<AnswerId>0</AnswerId>
				<AnswerText>51</AnswerText>
			</Answer>
		</Answer>
		<Respondent>
			<RespondentId>1</RespondentId>
			<IsRespondentDeleted>false</IsRespondentDeleted>
			<IsRespondentActive>false</IsRespondentActive>
		</Respondent>
		<ResponseSessionId>fthy5q45c0enuo55zaswrw55</ResponseSessionId>
		<IpAddress></IpAddress>
	</Responses>
	<Responses>
		<SurveyId>1134</SurveyId>
		<SessionId>abc</SessionId>
		<Question>
			<QuestionId>8657</QuestionId>
			<QuestionType>TextInput</QuestionType>
			<ForceResponse>false</ForceResponse>
			<HasSkipLogic>false</HasSkipLogic>
			<HasEmailTrigger>false</HasEmailTrigger>
			<HasMedia>false</HasMedia>
			<IsDeleted>false</IsDeleted>
			<SongId>1</SongId>
			<Config> 
				<IsPipedOut></IsPipedOut>
				<QuestionTagId></QuestionTagId>
				<IsPipedIn>True</IsPipedIn>
			</Config>
		</Question>
		<Answer>
			<Answer>
				<AnswerId>104190</AnswerId>
				<AnswerText>104181</AnswerText>
			</Answer>
		</Answer>
		<Respondent>
			<RespondentId>1</RespondentId>
			<IsRespondentDeleted>false</IsRespondentDeleted>
			<IsRespondentActive>false</IsRespondentActive>
		</Respondent>
		<ResponseSessionId>fthy5q45c0enuo55zaswrw55</ResponseSessionId>
		<IpAddress></IpAddress>
	</Responses>
</ArrayOfResponses>'
*/

CREATE PROCEDURE DBO.UspSaveSurveyResponse
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	------------------------------------------------------------------------------
	CREATE TABLE #Responses
	(
		SurveyId INT, SessionId VARCHAR(100), QuestionId INT, QuestionType VARCHAR(50),
		ForceResponse VARCHAR(50), HasSkipLogic VARCHAR(50), HasEmailTrigger VARCHAR(50), HasMedia VARCHAR(50),
		IsDeleted VARCHAR(12), AnswerId INT, AnswerText VARCHAR(250), RespondentId INT,
		IsRespondentDeleted VARCHAR(50), IsRespondentActive VARCHAR(50), SongId INT,
		IsPipedOut VARCHAR(20), QuestionTagId VARCHAR(20), IsPipedIn VARCHAR(20), IpAddress VARCHAR(30),
		ResAnswer VARCHAR(250)
	)
	INSERT INTO #Responses
	(
		SurveyId, SessionId, QuestionId, QuestionType, ForceResponse, HasSkipLogic, HasEmailTrigger, HasMedia,
		IsDeleted, SongId, AnswerId, AnswerText, RespondentId, IsRespondentDeleted, IsRespondentActive,
		IsPipedOut, QuestionTagId, IsPipedIn, IpAddress
	)
	SELECT
		Child.Elm.value('(SurveyId)[1]','VARCHAR(12)') AS SurveyId, 
		Child.Elm.value('(ResponseSessionId)[1]','VARCHAR(100)') AS SessionId,
		Child1.Elm.value('(QuestionId)[1]','VARCHAR(12)') AS QuestionId,
		Child1.Elm.value('(QuestionType)[1]','VARCHAR(50)') AS QuestionType,
		Child1.Elm.value('(ForceResponse)[1]','VARCHAR(50)') AS ForceResponse,
		Child1.Elm.value('(HasSkipLogic)[1]','VARCHAR(50)') AS HasSkipLogic,
		Child1.Elm.value('(HasEmailTrigger)[1]','VARCHAR(50)') AS HasEmailTrigger,
		Child1.Elm.value('(HasMedia)[1]','VARCHAR(50)') AS HasMedia,
		Child1.Elm.value('(IsDeleted)[1]','VARCHAR(12)') AS IsDeleted,
		Child1.Elm.value('(SongId)[1]','VARCHAR(12)') AS SongId,
		Child3.Elm.value('(AnswerId)[1]','VARCHAR(12)') AS AnswerId,
 		Child3.Elm.value('(AnswerText)[1]','VARCHAR(250)') AS AnswerText,
		Child4.Elm.value('(RespondentId)[1]','VARCHAR(12)') AS RespondentId,
		Child4.Elm.value('(IsRespondentDeleted)[1]','VARCHAR(50)') AS IsRespondentDeleted,
		Child4.Elm.value('(IsRespondentActive)[1]','VARCHAR(50)') AS IsRespondentActive,
		LTRIM(RTRIM(Child5.Elm.value('(IsPipedOut)[1]','VARCHAR(20)'))) AS IsPipedOut,
		Child5.Elm.value('(QuestionTagId)[1]','VARCHAR(20)') AS QuestionTagId,
		LTRIM(RTRIM(Child5.Elm.value('(IsPipedIn)[1]','VARCHAR(20)'))) AS IsPipedIn,
		Child.Elm.value('(IpAddress)[1]','VARCHAR(30)') AS IpAddress
	FROM @input.nodes('/ArrayOfResponses') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Responses') AS Child(Elm)
	CROSS APPLY
		Child.Elm.nodes('Question') AS Child1(Elm)
	CROSS APPLY
		Child.Elm.nodes('Answer') AS Child2(Elm)
	CROSS APPLY
		Child2.Elm.nodes('Answer') AS Child3(Elm)
	CROSS APPLY
		Child.Elm.nodes('Respondent') AS Child4(Elm)
	CROSS APPLY
		Child1.Elm.nodes('Config') AS Child5(Elm)
	
	DECLARE @IsDuplicate INT
	
	DELETE TR
	FROM #Responses R
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
		ON TR.QuestionId = R.QuestionId 
		AND 
		(
			(
				TR.RespondentId = ISNULL(R.RespondentId,0)
				AND TR.SessionId = R.SessionId
			)
			OR
			(
				TR.RespondentId = R.RespondentId AND TR.RespondentId > 0
			)		
		) 
		AND 
		(
			(ISNULL(R.SongId,0) > 0 AND R.SongId = TR.SongId)
			OR
			ISNULL(R.SongId,0) = 0
		)
		
	SET @IsDuplicate = @@ROWCOUNT	
		
	INSERT INTO DBO.TR_Responses
	(QuestionId, AnswerId, RespondentId, SessionId, [Status], AnswerText, ResponseDate, SongId, IpAddress)
	SELECT 
		R.QuestionId, R.AnswerId, ISNULL(R.RespondentId,0), LTRIM(RTRIM(R.SessionId)), 
		'I' AS Status, R.AnswerText, GETDATE(), CONVERT(INT,SongId), IpAddress  /*I--In Process , C--Complete */
	FROM #Responses R
	
	DECLARE @LastSongId INT
	DECLARE @RespondentId INT
	DECLARE @SessionId VARCHAR(100)
	DECLARE @QuestionId INT
	DECLARE @IsMTB INT
	 
	SELECT @LastSongId = SongId, @RespondentId = RespondentId, @SessionId = SessionId, @QuestionId = QuestionId 
	FROM #Responses WHERE ISNULL(SongId,0) > 0

	SELECT @IsMTB = COUNT(1) FROM DBO.TR_QuestionSettings TSS WITH(NOLOCK)
	WHERE QuestionId = @QuestionId AND TSS.SettingId IN(4,17,19) AND TSS.Value = 'True'
		
	IF @IsMTB = 3
	BEGIN
		IF @RespondentId >= 1
		BEGIN
			INSERT INTO DBO.TRL_Respondent_PlayList
			(SurveyId, SessionId, FileLibId, RespondentId, QuestionId)
			SELECT
				DISTINCT TRP.SurveyId, TRP.SessionId, TRP.FileLibId, TRP.RespondentId, TRP.QuestionId
			FROM DBO.TR_Respondent_PlayList TRP WITH(NOLOCK)
 			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
				ON TRP.RespondentId = TR.RespondentId 
				AND TRP.QuestionId = TR.QuestionId
				AND TRP.FilelibId = TR.SongId 
				AND TRP.QuestionId = @QuestionId 
				AND TRP.RespondentId = @RespondentId
			LEFT JOIN DBO.TRL_Respondent_PlayList TLRP WITH(NOLOCK)
				ON TRP.RespondentId = TLRP.RespondentId 
				AND TRP.QuestionId = TLRP.QuestionId
				AND TRP.FilelibId = TLRP.FilelibId 	
			WHERE TRP.FileLibId = @LastSongId 
				AND TLRP.FilelibId IS NULL
			
			DELETE TRP
			FROM DBO.TR_Respondent_PlayList TRP WITH(NOLOCK)
 			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
				ON TRP.RespondentId = TR.RespondentId 
				AND TRP.QuestionId = TR.QuestionId
				AND TRP.FilelibId = TR.SongId 
			WHERE TRP.QuestionId = @QuestionId 
				AND TRP.RespondentId = @RespondentId
				AND TRP.FileLibId = @LastSongId 
		END
		ELSE
		BEGIN
			INSERT INTO DBO.TRL_Respondent_PlayList
			(SurveyId, SessionId, FileLibId, RespondentId, QuestionId)
			SELECT
				DISTINCT TRP.SurveyId, TRP.SessionId, TRP.FileLibId, TRP.RespondentId, TRP.QuestionId
			FROM DBO.TR_Respondent_PlayList TRP WITH(NOLOCK)
 			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
				ON TRP.SessionId = TR.SessionId 
				AND TRP.QuestionId = TR.QuestionId
				AND TRP.FilelibId = TR.SongId 
				AND TRP.QuestionId = @QuestionId
				AND TRP.SessionId = @SessionId
				AND TRP.RespondentId = 0	
			LEFT JOIN DBO.TRL_Respondent_PlayList TLRP WITH(NOLOCK)
				ON TRP.SessionId = TLRP.SessionId 
				AND TRP.QuestionId = TLRP.QuestionId
				AND TRP.FilelibId = TLRP.FilelibId 	
			WHERE TRP.FileLibId = @LastSongId 
				AND TLRP.FilelibId IS NULL
				
			DELETE TRP
			FROM DBO.TR_Respondent_PlayList TRP WITH(NOLOCK)
 			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
				ON TRP.SessionId = TR.SessionId 
				AND TRP.QuestionId = TR.QuestionId
				AND TRP.FilelibId = TR.SongId 
			WHERE TRP.QuestionId = @QuestionId 
				AND TRP.SessionId = @SessionId
				AND TRP.FileLibId = @LastSongId 
				AND TRP.RespondentId = 0	
		END
	END	
			
	IF EXISTS(SELECT 1 FROM dbo.TR_Survey TS WITH(NOLOCK) INNER JOIN #Responses R ON TS.SurveyId = R.SurveyId AND TS.StatusId = 0)
	BEGIN
		UPDATE TS
		SET TS.StatusId = 1 -- 0 Inactive, 1 Active, 2 Completed
		FROM dbo.TR_Survey TS
		INNER JOIN #Responses R
			ON TS.SurveyId = R.SurveyId
	END
	
	UPDATE R
	SET R.ResAnswer = CASE WHEN R.AnswerId = TSA.AnswerId THEN TSA.Answer ELSE R.AnswerText END
	FROM #Responses R
	LEFT OUTER JOIN DBO.TR_SurveyAnswers TSA WITH(NOLOCK)
		ON R.AnswerId = TSA.AnswerId
	
	--/***************************************************/
	-- Start IsPipedOut 
	UPDATE MS -- Age
	SET MS.Age = CONVERT(INT,R.ResAnswer) 
	FROM #Responses R
	INNER JOIN DBO.MS_Respondent MS  WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Age'

	UPDATE MS -- BirthDate
	SET MS.BirthDate = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'DateOfBirth'
		
	UPDATE MS -- Sex
	SET MS.Gender = LOWER(R.ResAnswer) 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Gender'
		
	UPDATE MS -- FirstName
	SET MS.FirstName = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'FirstName'
	
	UPDATE MS -- LastName
	SET MS.LastName = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'LastName'
	
	UPDATE MS -- EmailId
	SET MS.EmailId = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'EmailId'
	
	UPDATE MS -- Ethnicity
	SET MS.UDF2 = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Ethnicity'
	
	UPDATE MS -- City
	SET MS.UDF3 = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'City'

	UPDATE MS -- Region
	SET MS.UDF4 = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Region'

	UPDATE MS -- Region
	SET MS.UDF5 = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Country'
		
	-- End IsPipedOut 
	
	--/***************************************************/
	
	-- Start IsPipedIn
	UPDATE MS -- Age
	SET MS.Age = CONVERT(INT,R.ResAnswer) 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Age'
		AND ISNULL(MS.Age,'') = ''
		
	UPDATE MS -- BirthDate
	SET MS.BirthDate = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'DateOfBirth'
		AND ISNULL(MS.BirthDate,'') = ''
		
	UPDATE MS -- Gender
	SET MS.Gender = LOWER(R.ResAnswer) 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Gender'
		AND ISNULL(MS.Gender,'') = ''

	UPDATE MS -- FirstName
	SET MS.FirstName = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'FirstName'
		AND ISNULL(MS.FirstName,'') = ''
		
	UPDATE MS -- LastName
	SET MS.LastName = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'LastName'
		AND ISNULL(MS.LastName,'') = ''
		
	UPDATE MS -- EmailId
	SET MS.EmailId = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'EmailId'
		AND ISNULL(MS.EmailId,'') = ''	
	
	UPDATE MS -- Ethnicity
	SET MS.UDF2 = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Ethnicity'
		AND ISNULL(MS.UDF2,'') = ''	

	UPDATE MS -- City
	SET MS.UDF3 = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'City'
		AND ISNULL(MS.UDF3,'') = ''	

	UPDATE MS -- Region
	SET MS.UDF4 = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Region'
		AND ISNULL(MS.UDF4,'') = ''		
	
	UPDATE MS -- Region
	SET MS.UDF5 = R.ResAnswer 
	FROM #Responses R 
	INNER JOIN DBO.MS_Respondent MS WITH(NOLOCK)
		ON R.RespondentId = MS.RespondentId
		AND R.IsPipedIn = 'True'
		AND R.IsPipedOut = 'True'
		AND R.QuestionTagId = 'Country'
		AND ISNULL(MS.UDF5,'') = ''	
		
	-- End IsPipedIn 
	
	--/***************************************************/

	SELECT 1 AS RetValue, 'Successfully Response Inserted' AS Remark, 
		CASE WHEN ISNULL(@IsDuplicate,0) = 0 THEN 0 ELSE 1 END AS IsDuplicate 

	DROP TABLE #Responses

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END




