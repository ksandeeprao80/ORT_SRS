IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveAutoPipoutRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveAutoPipoutRespondent]

GO
--  EXEC UspSaveAutoPipoutRespondent 1591,'qdfdlo55clazo1m25amcgue3',49

CREATE PROCEDURE DBO.UspSaveAutoPipoutRespondent
	@SurveyId INT,
	@SessionId VARCHAR(100),
	@PanelistId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @DateOfBirth VARCHAR(20)
	DECLARE @Gender VARCHAR(20)
	DECLARE @FirstName VARCHAR(50)
	DECLARE @LastName VARCHAR(50)
	DECLARE @EmailId VARCHAR(50)
	
	DECLARE @DateOfBirthRemark VARCHAR(20)
	DECLARE @GenderRemark VARCHAR(20)
	DECLARE @FirstNameRemark VARCHAR(50)
	DECLARE @LastNameRemark VARCHAR(50)
	DECLARE @EmailIdRemark VARCHAR(50)
	
	DECLARE @CustomerId INT
	DECLARE @GenderAlias CHAR(1)
	DECLARE @RespondentId INT
	
	-- MS_QuestionTags
	SELECT @DateOfBirth = LTRIM(RTRIM(TR.AnswerText)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
	AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '2'
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.SessionId = @SessionId
	
	SELECT @Gender = LTRIM(RTRIM(TSA.Answer)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
	AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '3'
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId  
	INNER JOIN DBO.PB_TR_SurveyAnswers TSA WITH(NOLOCK) ON TR.QuestionId = TSA.QuestionId 
		AND TR.AnswerId = TSA.AnswerId AND TR.SessionId = @SessionId
	
	SELECT @FirstName = LTRIM(RTRIM(TR.AnswerText)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
	AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '4'
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.SessionId = @SessionId 
	
	SELECT @LastName = LTRIM(RTRIM(TR.AnswerText)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
	AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '5'
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.SessionId = @SessionId 
	
	SELECT @EmailId = LTRIM(RTRIM(TR.AnswerText)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
	AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '6'
	INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.SessionId = @SessionId 

	SELECT @CustomerId = CustomerId FROM DBO.MS_PanelMembers WHERE PanelistId = @PanelistId
	SELECT @GenderAlias = GenderAlias FROM DBO.MS_GenderMapping WHERE LTRIM(RTRIM(Gender)) = LTRIM(RTRIM(@Gender))

	IF ISNULL(@DateOfBirth,'') = '' 
	BEGIN
		SET @DateOfBirthRemark = 'DOB is null'
	END
	IF ISNULL(@Gender,'') =  ''
	BEGIN
		SET @GenderRemark = 'Gender is null'
	END
	IF ISNULL(@FirstName,'') =  ''
	BEGIN
		SET @FirstNameRemark= 'First Name is null'
	END
	IF ISNULL(@LastName,'') =  '' 
	BEGIN
		SET @LastNameRemark = 'Last Name is null'
	END
	IF ISNULL(@EmailId,'') = ''
	BEGIN
		SET @EmailIdRemark = 'Email is null'	
	END

	IF 
	(	ISNULL(@DateOfBirthRemark,'') = '' 
		AND ISNULL(@GenderRemark,'') = ''
		AND ISNULL(@FirstNameRemark,'') = ''
		AND ISNULL(@LastNameRemark,'') = ''
		AND ISNULL(@EmailIdRemark,'') = ''
	)
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM DBO.MS_Respondent WHERE LTRIM(RTRIM(EmailId)) = LTRIM(RTRIM(@EmailId)) AND CustomerId = @CustomerId
		)
		BEGIN
			INSERT INTO DBO.TRL_AutoPipoutRespondent
			(SurveyId, SessionId, PanelistId, ExceptionRemark, CreatedDate)	
			SELECT 
				@SurveyId, @SessionId, @PanelistId, 'Email Id exist in the system' AS ExceptionRemark, GETDATE() 
		
			UPDATE DBO.MS_Respondent
			SET FirstName = LTRIM(RTRIM(@FirstName)),
				LastName = LTRIM(RTRIM(@LastName)), 
				BirthDate = LTRIM(RTRIM(@DateOfBirth)),
				Gender = ISNULL(@GenderAlias,@Gender),
				ModifiedOn = GETDATE()
			WHERE LTRIM(RTRIM(EmailId)) = LTRIM(RTRIM(@EmailId)) AND CustomerId = @CustomerId	
		END
		ELSE
		BEGIN
			DECLARE @Ethnicity VARCHAR(150)
			DECLARE @City VARCHAR(100)
			DECLARE @Region VARCHAR(100)
			DECLARE @Country VARCHAR(100)
			DECLARE @Age VARCHAR(50)
			
			SELECT @Ethnicity = LTRIM(RTRIM(TSA.Answer)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
			INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
			AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '7'
			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId  
			INNER JOIN DBO.PB_TR_SurveyAnswers TSA WITH(NOLOCK) ON TR.QuestionId = TSA.QuestionId 
				AND TR.AnswerId = TSA.AnswerId AND TR.SessionId = @SessionId
			
			SELECT @City = LTRIM(RTRIM(TR.AnswerText)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
			INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
			AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '8'
			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.SessionId = @SessionId 
			
			SELECT @Region = LTRIM(RTRIM(TR.AnswerText)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
			INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
			AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '9'
			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.SessionId = @SessionId 
			
			SELECT @Country = LTRIM(RTRIM(TR.AnswerText)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
			INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
			AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '10'
			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.SessionId = @SessionId 
			
			SELECT @Age = LTRIM(RTRIM(TR.AnswerText)) FROM DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
			INNER JOIN DBO.PB_TR_SurveyQuestions TSQ  WITH(NOLOCK) ON TQS.QuestionId = TSQ.QuestionId 
			AND TSQ.SurveyId = @SurveyId AND TQS.SettingId = 12 AND ISNULL(TQS.Value,'') = '1'
			INNER JOIN DBO.TR_Responses TR WITH(NOLOCK) ON TSQ.QuestionId = TR.QuestionId AND TR.SessionId = @SessionId 
				
			INSERT INTO DBO.MS_Respondent
			(
				CustomerId, EmailId, PanelistId, IsActive, IsDeleted, FirstName, LastName, BirthDate, Gender, 
				Town, UDF1, UDF2, UDF3, UDF4, UDF5, CreatedBy, CreatedOn, Age
			)
			SELECT 
				@CustomerId AS CustomerId, LTRIM(RTRIM(@EmailId)) AS EmailId, @PanelistId AS PanelistId, 
				1 AS IsActive, 1 AS IsDeleted, LTRIM(RTRIM(@FirstName)) AS FirstName,
				LTRIM(RTRIM(@LastName)) AS LastName, LTRIM(RTRIM(@DateOfBirth)) AS BirthDate,
				ISNULL(@GenderAlias,@Gender) AS Gender, NULL AS Town, NULL AS UDF1, ISNULL(@Ethnicity,'') AS UDF2, 
				ISNULL(@City,'') AS UDF3, ISNULL(@Region,'') AS UDF4, ISNULL(@Country,'') AS UDF5,
				0 AS CreatedBy, GETDATE() AS CreatedOn, 
				ISNULL(@Age,'0') AS Age 
		
			SET @RespondentId = @@IDENTITY
			
			UPDATE DBO.MS_Respondent
			SET RespondentCode = 'Res'+CONVERT(VARCHAR(12),@RespondentId)
			WHERE RespondentId = @RespondentId
		END
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TRL_AutoPipoutRespondent
		(SurveyId, SessionId, PanelistId, ExceptionRemark, CreatedDate)	
		SELECT DISTINCT
			@SurveyId AS SurveyId, @SessionId AS SessionId, @PanelistId AS PanelistId,  
			SUBSTRING
			(
				CASE WHEN ISNULL(@DateOfBirthRemark,'') = '' THEN '' ELSE @DateOfBirthRemark+',' END
				+CASE WHEN ISNULL(@GenderRemark,'') = '' THEN '' ELSE @GenderRemark+',' END
				+CASE WHEN ISNULL(@FirstNameRemark,'') = '' THEN '' ELSE @FirstNameRemark+',' END 
				+CASE WHEN ISNULL(@LastNameRemark,'') = '' THEN '' ELSE @LastNameRemark+',' END,
				1,
				LEN(CASE WHEN ISNULL(@DateOfBirthRemark,'') = '' THEN '' ELSE @DateOfBirthRemark+',' END
				+CASE WHEN ISNULL(@GenderRemark,'') = '' THEN '' ELSE @GenderRemark+',' END
				+CASE WHEN ISNULL(@FirstNameRemark,'') = '' THEN '' ELSE @FirstNameRemark+',' END 
				+CASE WHEN ISNULL(@LastNameRemark,'') = '' THEN '' ELSE @LastNameRemark+',' END 
				+ISNULL(@EmailIdRemark,''))-1 
			) AS ExceptionRemark,
			GETDATE() AS CreatedDate	
	END

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark, 0 AS ResponseId
END CATCH 

SET NOCOUNT OFF
END