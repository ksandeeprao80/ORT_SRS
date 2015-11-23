IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyQuestionsBySession]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyQuestionsBySession]

GO
-- EXEC UspGetSurveyQuestionsBySession 1080,'Jd Test'

CREATE PROCEDURE DBO.UspGetSurveyQuestionsBySession
	@SurveyId INT,
	@SessionId VARCHAR(100)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TSQ.QuestionId, TSQ.SurveyId, TSQ.CustomerId, TSQ.QuestionTypeId, 
		LTRIM(RTRIM(ISNULL(MQT.QuestionCode,''))) AS QuestionCode, 
		LTRIM(RTRIM(ISNULL(MQT.QuestionName,''))) AS QuestionName, 
		LTRIM(RTRIM(ISNULL(TSQ.QuestionText,''))) AS QuestionText,  
		TSQ.IsDeleted, ISNULL(TSQ.DefaultAnswerId,'') AS DefaultAnswerId,
		ISNULL(TSQ.QuestionNo,0) AS QuestionNo
	FROM DBO.PB_TR_SurveyQuestions TSQ
	INNER JOIN DBO.MS_QuestionTypes MQT
		ON TSQ.QuestionTypeId = MQT.QuestionTypeId
		AND TSQ.SurveyId = @SurveyId 
		AND TSQ.IsDeleted = 1
	LEFT OUTER JOIN 
	(
		SELECT QuestionId FROM DBO.TR_Responses 
		WHERE LTRIM(RTRIM(SessionId)) = LTRIM(RTRIM(@SessionId)) 
	) TR
		ON TSQ.QuestionId = TR.QuestionId
	WHERE TR.QuestionId IS NULL
	ORDER BY TSQ.QuestionNo, TSQ.QuestionId  

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

