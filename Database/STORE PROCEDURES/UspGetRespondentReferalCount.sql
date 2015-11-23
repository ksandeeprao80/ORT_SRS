IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetRespondentReferalCount]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetRespondentReferalCount]

GO

-- EXEC UspGetRespondentReferalCount 
CREATE PROCEDURE DBO.UspGetRespondentReferalCount
	@SurveyId INT = NULL,
	@RefereeId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		 RowId, SurveyId, RespondentId, ReferalCount, Channel
	FROM DBO.TR_RespondentReferalCount
	WHERE SurveyId = ISNULL(@SurveyId,SurveyId)  
		AND RespondentId = ISNULL(@RefereeId,RespondentId)
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END