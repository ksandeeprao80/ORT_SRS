BEGIN
BEGIN TRY

	BEGIN TRAN

	DELETE FROM TR_Invite WHERE InviteId IN(SELECT InviteId FROM DBO.MS_Invite WHERE SurveyId <=1100)
	DELETE FROM DBO.MS_Invite WHERE SurveyId <=1100 
	--/*Before Delete From Invite Table, Invite should get deleted from below tables*/

	DELETE FROM DBO.TR_Reward WHERE SurveyId <=1100 
	DELETE FROM DBO.TR_SkipLogic WHERE SurveyId <=1100 
	--/*Before Delete From Question Table, Question should get deleted from below tables*/
	DELETE FROM DBO.TR_EmailTrigger WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId <=1100 )
	DELETE FROM DBO.TR_EmailDetails WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId <=1100 )
	DELETE FROM DBO.TR_MediaInfo WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId <=1100 )
	DELETE FROM DBO.TR_MediaSkipLogic WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId <=1100 )
	DELETE FROM DBO.TR_QuestionSettings WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId <=1100 )
	DELETE FROM DBO.TR_Responses WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId <=1100 )
	DELETE FROM DBO.TR_SurveyAnswers WHERE QuestionId IN (SELECT QuestionId FROM DBO.TR_SurveyQuestions WHERE SurveyId <=1100 )
	--/*End Before Delete From Question Table, Question should get deleted from below tables*/

	DELETE FROM DBO.TR_SurveyQuestions WHERE SurveyId <=1100 
	DELETE FROM DBO.TR_SurveyQuota WHERE SurveyId <=1100 
	DELETE FROM DBO.TR_SurveySettings WHERE SurveyId <=1100 
	DELETE FROM DBO.TR_Translations WHERE SurveyId <=1100 

	DELETE FROM DBO.TR_Survey WHERE SurveyId <=1100 

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

-- UPDATE TR_Survey SET StatusId = 0 WHERE SurveyId >=1175