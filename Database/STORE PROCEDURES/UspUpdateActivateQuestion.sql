IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdateActivateQuestion]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdateActivateQuestion
GO
--   EXEC UspUpdateActivateQuestion 8934

CREATE PROCEDURE DBO.UspUpdateActivateQuestion
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
	
	SET @QuestionNo = 0
		
	SELECT @SurveyId = SurveyId FROM DBO.TR_SurveyQuestions WHERE QuestionId = @QuestionId
	SELECT @QuestionNo = MAX(ISNULL(QuestionNo,0)) FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId

	UPDATE DBO.TR_SurveyQuestions 
	SET IsDeleted = 1,
		QuestionNo = @QuestionNo+1
	WHERE SurveyId = @SurveyId
		AND QuestionId = @QuestionId
	
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

