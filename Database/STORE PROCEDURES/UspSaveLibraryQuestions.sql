IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveLibraryQuestions]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveLibraryQuestions]
GO
/*
-- EXEC UspSaveLibraryQuestions 5,'<?xml version="1.0" encoding="utf-16"?>
<Question>
	<Customer>
		<CustomerId>1</CustomerId>
		<IsActive>false</IsActive>
		</Customer>
	<QuestionId>8943</QuestionId>
	<QuestionType>SingleChoice</QuestionType>
	<Answers>
		<Answer>
			<AnswerDesc>Singer</AnswerDesc>
			<AnswerText>Singer</AnswerText>
		</Answer>
		<Answer>
			<AnswerDesc>Dancer</AnswerDesc>
			<AnswerText>Dancer</AnswerText>
		</Answer>
		<Answer>
			<AnswerDesc>Musician</AnswerDesc>
			<AnswerText>Musician</AnswerText>
		</Answer>
	</Answers>
	<QuestionText>Johnny Testing Que Library</QuestionText>
	<IsDeleted>false</IsDeleted>
	<IsMediaFollowUp>false</IsMediaFollowUp>
	<QuestionTag>Undefined</QuestionTag>
	<QuestionNo>1</QuestionNo>
	<PreviousQuestionNo>16</PreviousQuestionNo>
</Question>'
*/

CREATE PROCEDURE DBO.UspSaveLibraryQuestions
	@XmlData AS NTEXT,
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
	
	DECLARE @CreatedBy INT
	SELECT @CreatedBy = CreatedBy FROM DBO.TR_Library WHERE LibId = @LibraryId

	DECLARE @input XML = @XmlData
	
	CREATE TABLE #SurveyQuestionsLibrary
	(QuestionLibId VARCHAR(20), QuestionType VARCHAR(100), QuestionText VARCHAR(2000))
	INSERT INTO #SurveyQuestionsLibrary
	(QuestionLibId, QuestionType, QuestionText)
	SELECT 
		Parent.Elm.value('(QuestionId)[1]','VARCHAR(100)') AS QuestionLibId,
		Parent.Elm.value('(QuestionType)[1]','VARCHAR(100)') AS QuestionType,
		Parent.Elm.value('(QuestionText)[1]','VARCHAR(2000)') AS QuestionText
	FROM @input.nodes('/Question') AS Parent(Elm)

	DECLARE @QuestionLibId INT 
	SET @QuestionLibId = 0 
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN ('GU','SU'))
	BEGIN
		IF @UserId <> @CreatedBy
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END
		ELSE
		BEGIN
			IF EXISTS
			(
				SELECT 1 FROM DBO.TR_QuestionLibrary TQL 
				INNER JOIN #SurveyQuestionsLibrary SQLR
					ON TQL.QuestionLibId = CONVERT(INT,SQLR.QuestionLibId)
			)
			BEGIN
				UPDATE TQL
				SET TQL.CategoryId = @CategoryId,
					TQL.LibId = @LibraryId,
					TQL.QuestionTypeId = MQT.QuestionTypeId,
					TQL.QuestionText = SQLR.QuestionText
				FROM DBO.TR_QuestionLibrary TQL 
				INNER JOIN #SurveyQuestionsLibrary SQLR
					ON TQL.QuestionLibId = CONVERT(INT,SQLR.QuestionLibId)
				INNER JOIN DBO.MS_QuestionTypes MQT
					ON LTRIM(RTRIM(SQLR.QuestionType)) = LTRIM(RTRIM(MQT.QuestionCode))
					
				SELECT @QuestionLibId = QuestionLibId FROM #SurveyQuestionsLibrary
			END
			ELSE
			BEGIN
				INSERT INTO DBO.TR_QuestionLibrary
				(
					LibId, QuestionId, QuestionLibName, Category, IsActive, CreatedBy, CreatedOn, 
					CategoryId, QuestionTypeId, QuestionText
				)
				SELECT  
					 @LibraryId, NULL AS QuestionId, NULL AS QuestionLibName, NULL AS Category, 1 AS IsActive, 
					 @UserId AS CreatedBy, GETDATE() AS CreatedOn, @CategoryId, MQT.QuestionTypeId, SQLR.QuestionText
				FROM #SurveyQuestionsLibrary SQLR
				INNER JOIN DBO.MS_QuestionTypes MQT
						ON LTRIM(RTRIM(SQLR.QuestionType)) = LTRIM(RTRIM(MQT.QuestionCode))
						AND ISNULL(SQLR.QuestionType,'') <> '' 
						AND ISNULL(SQLR.QuestionText,'') <> ''		 
			 
				SET @QuestionLibId = @@IDENTITY
			END
			 
			SELECT 
				CASE WHEN ISNULL(@QuestionLibId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
				CASE WHEN ISNULL(@QuestionLibId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
				@QuestionLibId AS QuestionLibId 
		END
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM DBO.TR_QuestionLibrary TQL 
			INNER JOIN #SurveyQuestionsLibrary SQLR
				ON TQL.QuestionLibId = CONVERT(INT,SQLR.QuestionLibId)
		)
		BEGIN
			UPDATE TQL
			SET TQL.CategoryId = @CategoryId,
				TQL.LibId = @LibraryId,
				TQL.QuestionTypeId = MQT.QuestionTypeId,
				TQL.QuestionText = SQLR.QuestionText
			FROM DBO.TR_QuestionLibrary TQL 
			INNER JOIN #SurveyQuestionsLibrary SQLR
				ON TQL.QuestionLibId = CONVERT(INT,SQLR.QuestionLibId)
			INNER JOIN DBO.MS_QuestionTypes MQT
				ON LTRIM(RTRIM(SQLR.QuestionType)) = LTRIM(RTRIM(MQT.QuestionCode))
				
			SELECT @QuestionLibId = QuestionLibId FROM #SurveyQuestionsLibrary
		END
		ELSE
		BEGIN
			INSERT INTO DBO.TR_QuestionLibrary
			(
				LibId, QuestionId, QuestionLibName, Category, IsActive, CreatedBy, CreatedOn, 
				CategoryId, QuestionTypeId, QuestionText
			)
			SELECT  
				 @LibraryId, NULL AS QuestionId, NULL AS QuestionLibName, NULL AS Category, 1 AS IsActive, 
				 @UserId AS CreatedBy, GETDATE() AS CreatedOn, @CategoryId, MQT.QuestionTypeId, SQLR.QuestionText
			FROM #SurveyQuestionsLibrary SQLR
			INNER JOIN DBO.MS_QuestionTypes MQT
					ON LTRIM(RTRIM(SQLR.QuestionType)) = LTRIM(RTRIM(MQT.QuestionCode))
					AND ISNULL(SQLR.QuestionType,'') <> '' 
					AND ISNULL(SQLR.QuestionText,'') <> ''		 
		 
			SET @QuestionLibId = @@IDENTITY
		END
		 
		SELECT 
			CASE WHEN ISNULL(@QuestionLibId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@QuestionLibId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
			@QuestionLibId AS QuestionLibId
	END

	DROP TABLE #SurveyQuestionsLibrary
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

