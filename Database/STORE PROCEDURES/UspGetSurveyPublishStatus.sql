IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyPublishStatus]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSurveyPublishStatus]

GO

-- UspGetSurveyPublishStatus 1160
CREATE PROCEDURE DBO.UspGetSurveyPublishStatus
	@SurveyId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT PublishStatus FROM DBO.TR_Survey WHERE SurveyId = @SurveyId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END