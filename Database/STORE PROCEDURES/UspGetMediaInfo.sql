IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetMediaInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetMediaInfo]

GO

-- EXEC UspGetMediaInfo 
CREATE PROCEDURE DBO.UspGetMediaInfo
	@QuestionId INT = NULL,
	@FileLibId INT = NULL,
	@CustomerId INT = NULL,
	@SurveyId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TMI.QuestionId, TMI.FileLibId, TMI.CustomerId, ISNULL(TMI.Randomize,0) AS Randomize,
		ISNULL(TMI.AutoAdvance,0) AS AutoAdvance, ISNULL(TMI.ShowTitle,0) AS ShowTitle,
		ISNULL(TMI.Autoplay,0) AS Autoplay, ISNULL(TMI.HideForSeconds,0) AS HideForSeconds,
		TSQ.SurveyId
	FROM DBO.TR_MediaInfo TMI
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ
		ON TMI.QuestionId = TSQ.QuestionId
		AND TSQ.IsDeleted = 1
		AND TMI.QuestionId = ISNULL(@QuestionId,TMI.QuestionId)
		AND TMI.FileLibId = ISNULL(@FileLibId,TMI.FileLibId)
		AND TMI.CustomerId = ISNULL(@CustomerId,TMI.CustomerId)
		AND TSQ.SurveyId = ISNULL(@SurveyId,TSQ.SurveyId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END