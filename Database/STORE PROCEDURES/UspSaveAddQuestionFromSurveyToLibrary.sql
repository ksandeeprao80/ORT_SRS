IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveAddQuestionFromSurveyToLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveAddQuestionFromSurveyToLibrary]

GO 
/*   
EXEC UspSaveAddQuestionFromSurveyToLibrary
*/  
   
CREATE PROCEDURE DBO.UspSaveAddQuestionFromSurveyToLibrary  
	@QuestionId INT,
	@LibraryId INT,
	@CategoryId INT,
	@XmlUserInfo AS NTEXT
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  
  
	BEGIN TRAN

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo
	
	DECLARE @UserId INT
	SELECT @UserId = CONVERT(INT,UserId) FROM @UserInfo
	
	DECLARE @QuestionLibId INT  
	SET @QuestionLibId = 0  
  
	INSERT INTO DBO.TR_QuestionLibrary
	(
		LibId, QuestionId, QuestionLibName, Category, IsActive, CreatedBy, CreatedOn, CategoryId, 
		QuestionTypeId, QuestionText
	)  
	SELECT   
		@LibraryId, @QuestionId, NULL, NULL, 1, @UserId, GETDATE(), @CategoryId, QuestionTypeId, QuestionText 
	FROM DBO.TR_SurveyQuestions 
	WHERE QuestionId = @QuestionId
	
	SET @QuestionLibId = @@IDENTITY  
	
	IF ISNULL(@QuestionLibId,0) <> 0
	BEGIN
		INSERT INTO DBO.TR_QuestionLibraryAnswers
		(QuestionLibId, Answer, AnswerText)
		SELECT @QuestionLibId, Answer, AnswerText
		FROM DBO.TR_SurveyAnswers TSA
		WHERE QuestionId = @QuestionId
		
		INSERT INTO DBO.TR_QuestionLibrarySetting
		(QuestionLibId, SettingId, Value)
		SELECT @QuestionLibId, SettingId, Value
		FROM DBO.TR_QuestionSettings
		WHERE QuestionId = @QuestionId
	END
   
	SELECT CASE WHEN ISNULL(@QuestionLibId,0) = 0 THEN 0 ELSE 1 END AS RetValue,      
			CASE WHEN ISNULL(@QuestionLibId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
			@QuestionLibId AS QuestionLibId
			
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
