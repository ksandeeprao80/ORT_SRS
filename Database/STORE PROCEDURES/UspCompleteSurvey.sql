IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCompleteSurvey]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspCompleteSurvey
GO

--  EXEC UspCompleteSurvey @SurveyId='2016',@SessionId='tmuft055a3qpfm55szajzsrb',@RespondentId='0'

CREATE PROCEDURE DBO.UspCompleteSurvey
	@SurveyId INT,
	@SessionId VARCHAR(100),
	@RespondentId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	UPDATE TR
	SET TR.[Status] = 'C'
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.PB_TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
		AND 
		( 
			(
				ISNULL(@RespondentId,0) = 0 
				AND LTRIM(RTRIM(TR.SessionId)) = LTRIM(RTRIM(@SessionId))
			)
			OR
			(
				(ISNULL(@RespondentId,0) <> 0 AND TR.RespondentId = @RespondentId)
			)
		)
	
	IF ISNULL(@RespondentId,0) <> 0
	BEGIN
		UPDATE DBO.TR_SurveyRequestDetails
		SET ResponseStatus = 'C'
		WHERE SurveyId = @SurveyId
		AND RespondentId = @RespondentId
	END	
	
	DECLARE @PlayListId VARCHAR(12)
	DECLARE @RowCount INT

	SELECT 
		@PlayListId = LTRIM(RTRIM(TSS.Value))
	FROM DBO.PB_TR_SurveyQuestions TSQ WITH(NOLOCK)	
	INNER JOIN DBO.TR_QuestionSettings TSS  WITH(NOLOCK) 
		ON TSQ.QuestionId = TSS.QuestionId AND TSS.SettingId = 7 
		AND TSQ.SurveyId = @SurveyId AND ISNULL(LTRIM(RTRIM(TSS.Value)),'') NOT IN('','0') 
		
	INSERT INTO DBO.TR_SurveySanityCheck	
	(SurveyId, RespondentId, SessionId, SongId, PlayListId)
	SELECT 
		@SurveyId, ISNULL(@RespondentId,0), @SessionId, TPL.FileLibId, @PlayListId
	FROM DBO.TR_PlayList TPL WITH(NOLOCK)	
	LEFT JOIN 
	(
		SELECT TR.SongId
		FROM DBO.PB_TR_SurveyQuestions TSQ WITH(NOLOCK)	
		INNER JOIN DBO.TR_Responses TR  WITH(NOLOCK)	
			ON TSQ.QuestionId = TR.QuestionId 
			AND TSQ.SurveyId = @SurveyId AND TR.SongId <> 0
			AND 
			( 
				(ISNULL(@RespondentId,0) = 0 AND LTRIM(RTRIM(TR.SessionId)) = LTRIM(RTRIM(@SessionId)))
				OR
				((ISNULL(@RespondentId,0) <> 0 AND TR.RespondentId = @RespondentId))
			)
	) TR	
		ON TPL.FileLibId = TR.SongId
	WHERE CONVERT(VARCHAR(12),TPL.PlayListId) = @PlayListId
		AND TR.SongId IS NULL	
	
	SET @RowCount = @@ROWCOUNT	 
	
	IF @RowCount > 0
	BEGIN
		UPDATE TSSC
		SET TSSC.IpAddress = TSBMD.IpAddress, 
		    TSSC.Browser = TSBMD.Browser,
		    TSSC.BrowserVersion = TSBMD.BrowserVersion,
		    TSSC.OperatingSystem = TSBMD.OperatingSystem,
		    TSSC.ScreenResolution = TSBMD.ScreenResolution,
		    TSSC.FlashVersion = TSBMD.FlashVersion,
		    TSSC.JavaSupport = TSBMD.JavaSupport,
		    TSSC.SupportCookies = TSBMD.SupportCookies,
		    TSSC.UserAgent = TSBMD.UserAgent
		FROM DBO.TR_SurveySanityCheck TSSC
		INNER JOIN DBO.TR_SurveyBrowserMetaData TSBMD
			ON TSSC.SurveyId = TSBMD.SurveyId
			AND TSSC.RespondentId = TSBMD.RespondentId
			AND TSSC.SessionId = TSBMD.RespondentSessionId
		WHERE TSSC.SurveyId = @SurveyId
			AND LTRIM(RTRIM(TSSC.SessionId)) = LTRIM(RTRIM(@SessionId))	
			AND TSSC.RespondentId = ISNULL(@RespondentId,0)
	END	
	
	DECLARE @Annonymous INT
	DECLARE @AssociatedPanel INT

	SELECT @Annonymous = COUNT(1) FROM DBO.TR_Responses TR WITH(NOLOCK)
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK) ON TR.QuestionId = TSQ.QuestionId
	WHERE TSQ.SurveyId = @SurveyId AND LTRIM(RTRIM(TR.SessionId)) = LTRIM(RTRIM(@SessionId)) AND TR.RespondentId = 0
	
	SELECT @AssociatedPanel = MPM.PanelistId FROM DBO.MS_PanelMembers MPM 
	INNER JOIN DBO.TR_SurveySettings TSS ON CONVERT(VARCHAR(12),MPM.PanelistId) = LTRIM(RTRIM(TSS.Value)) 
	WHERE TSS.SurveyId = @SurveyId AND TSS.SettingId = 78 AND ISNULL(Value,'') <> ''

	IF (@Annonymous >= 1 AND ISNULL(@AssociatedPanel,0) <> 0)
	BEGIN
		EXEC DBO.UspSaveAutoPipoutRespondent @SurveyId, @SessionId, @AssociatedPanel
	END
	
	SELECT 1 AS RetValue, 'Successfully Response Completed' AS Remark 
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
 