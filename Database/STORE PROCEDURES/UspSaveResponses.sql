IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveResponses]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveResponses]

GO
-- EXEC UspSaveResponses 
CREATE PROCEDURE DBO.UspSaveResponses
	@SurveyId INT,
	@SessionId VARCHAR(100)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	UPDATE TR
	SET TR.[Status] = 'C' /*I--In Process , C--Complete */
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		ON TR.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId
		AND LTRIM(RTRIM(TR.SessionId)) = LTRIM(RTRIM(@SessionId))

	SELECT 1 AS RetValue, 'Successfully Updated' AS Remark

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark, 0 AS ResponseId
END CATCH 

SET NOCOUNT OFF
END