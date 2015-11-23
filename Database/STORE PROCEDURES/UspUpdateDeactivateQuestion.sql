IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdateDeactivateQuestion]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdateDeactivateQuestion
GO
--   EXEC UspUpdateDeactivateQuestion 8934

CREATE PROCEDURE DBO.UspUpdateDeactivateQuestion
	@QuestionId INT,
	@XmlUserInfo AS NTEXT
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	DECLARE @UserId INT
	SELECT @UserId = CONVERT(INT,UserId) FROM @UserInfo
	
	BEGIN TRAN  
  
	DECLARE @QuestionNo INT 
	DECLARE @SurveyId INT 
	
	SELECT @SurveyId = SurveyId, @QuestionNo = QuestionNo FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId
	
	UPDATE DBO.TR_SurveyQuestions 
	SET QuestionNo = QuestionNo-1
	WHERE SurveyId = @SurveyId
		AND QuestionNo > @QuestionNo 
	
	UPDATE DBO.TR_SurveyQuestions  
	SET IsDeleted = 0,
		QuestionNo = 0
	WHERE QuestionId = @QuestionId

	UPDATE DBO.TR_Survey SET ModifiedBy = @UserId, ModifiedDate = GETDATE() WHERE SurveyId = @SurveyId
		
	SELECT 1 AS RetValue, 'Successfully Updated' AS Remark
	
	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 

