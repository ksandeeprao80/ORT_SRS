IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteSurvey]
GO

-- EXEC UspDeleteSurvey 6

CREATE PROCEDURE DBO.UspDeleteSurvey
	@SurveyId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	UPDATE DBO.TR_Survey
	SET IsActive = 0
	WHERE SurveyId = @SurveyId
	
	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
	
/* --Commented due to few doubts to get clear
	
	--/*Before Delete From Invite Table, Invite should get deleted from below tables*/
	DELETE FROM TR_Invite WHERE InviteId IN(SELECT InviteId FROM DBO.MS_Invite WHERE SurveyId = @SurveyId)
	DELETE FROM DBO.MS_Invite WHERE SurveyId = @SurveyId
	--/*Before Delete From Invite Table, Invite should get deleted from below tables*/

	DELETE FROM DBO.TR_Reward WHERE SurveyId = @SurveyId
	DELETE FROM DBO.TR_SkipLogic WHERE SurveyId = @SurveyId
	--/*Before Delete From Question Table, Question should get deleted from below tables*/
	DELETE FROM DBO.TR_EmailTrigger WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId)
	DELETE FROM DBO.TR_EmailDetails WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId)
	DELETE FROM DBO.TR_MediaInfo WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId)
	DELETE FROM DBO.TR_MediaSkipLogic WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId)
	DELETE FROM DBO.TR_QuestionSettings WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId)
	DELETE FROM DBO.TR_Responses WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId)
	DELETE FROM DBO.TR_SurveyAnswers WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId)
	--/*End Before Delete From Question Table, Question should get deleted from below tables*/

	DELETE FROM DBO.TR_SurveyQuestions WHERE SurveyId = @SurveyId
	DELETE FROM DBO.TR_SurveyQuota WHERE SurveyId = @SurveyId
	DELETE FROM DBO.TR_SurveySettings WHERE SurveyId = @SurveyId
	DELETE FROM DBO.TR_Translations WHERE SurveyId = @SurveyId

	DECLARE @RowId INT
	SET @RowId = 0
	
	DELETE FROM DBO.TR_Survey WHERE SurveyId = @SurveyId

	SET @RowId = @@ROWCOUNT
		
	SELECT CASE WHEN ISNULL(@RowId,0)= 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Access Denied' ELSE 'Successfully Deleted' END AS Remark
*/					
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

