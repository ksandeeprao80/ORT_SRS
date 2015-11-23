IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteQuestionLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteQuestionLibrary]
GO

--EXEC UspDeleteQuestionLibrary 1 

CREATE PROCEDURE DBO.UspDeleteQuestionLibrary
	@QuestionLibId INT,
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
	
	DECLARE @CreatedBy INT, @CustomerId INT
	SELECT @CreatedBy = CONVERT(INT,UserId) FROM @UserInfo
	SELECT @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_QuestionLibrary TQL 
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TQL.QuestionId = TSQ.QuestionId
			AND TQL.QuestionLibId = @QuestionLibId
		INNER JOIN DBO.TR_Survey TS
			ON TSQ.SurveyId = TS.SurveyId
			AND TS.IsActive = 1
	) 
	BEGIN
		SELECT 1 AS RetValue, 'Question Library Can not Deleted' AS Remark
	END
	ELSE
	BEGIN
	
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SU')
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_QuestionLibrary WHERE QuestionLibId = @QuestionLibId AND CreatedBy = @CreatedBy)	
			BEGIN	
				DELETE FROM DBO.TR_QuestionLibrary WHERE QuestionLibId = @QuestionLibId AND CreatedBy = @CreatedBy
				
				SELECT 1 AS RetValue, 'Successfully Question Library Deleted' AS Remark
			END
			ELSE
			BEGIN
				SELECT 0 AS RetValue, 'Access Denied' AS Remark
			END
		END
	
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
		BEGIN
			DELETE TQL
			FROM DBO.TR_QuestionLibrary TQL 
			INNER JOIN DBO.TR_Library TL
				ON TQL.LibId = TL.LibId
			WHERE TL.CustomerId = @CustomerId
				AND TQL.QuestionLibId = @QuestionLibId
				
			SELECT 1 AS RetValue, 'Successfully Question Library Deleted' AS Remark
		END
	
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
		BEGIN
			DELETE FROM DBO.TR_QuestionLibrary WHERE QuestionLibId = @QuestionLibId

			SELECT 1 AS RetValue, 'Successfully Question Library Deleted' AS Remark
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
		BEGIN
			SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END
	END
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

