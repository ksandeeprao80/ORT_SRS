IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSurveyProgress]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetSurveyProgress

GO

CREATE PROCEDURE DBO.UspGetSurveyProgress
	@SessionId VARCHAR(100),
	@RespondentId INT,
	@SurveyId INT	
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

    DECLARE @SongId INT
	DECLARE @QuestionId INT
	DECLARE @IsMTB INT
	
	CREATE TABLE #Progress
	(
		ProgressId INT, SessionId VARCHAR(100), QuestionId INT, RespondentId INT,SongId INT
	)
	INSERT INTO #Progress(ProgressId,SessionId,QuestionId,RespondentId,SongId)
	SELECT 
		TOP 1 TSP.ProgressId, TSP.SessionId, TSQ.QuestionId, ISNULL(TSP.RespondentId,0) AS RespondentId, 
		ISNULL(TSP.SongId,0) AS SongId
	FROM DBO.TR_SurveyProgress TSP WITH(NOLOCK)
	INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		ON TSP.QuestionId = TSQ.QuestionId
		AND TSQ.SurveyId = @SurveyId
	AND 
	( 
		(
			ISNULL(@RespondentId,0) = 0 
			AND TSP.SessionId = @SessionId
		)
		OR
		(
			(ISNULL(@RespondentId,0) > 0 AND TSP.RespondentId = @RespondentId)
		)
	)
	ORDER BY TSP.ProgressId DESC
	
	IF EXISTS(SELECT 1 FROM #Progress WHERE SongId > 0)
	BEGIN
	    Select @QuestionId = QuestionId from #Progress
	    SELECT @IsMTB = COUNT(1) FROM DBO.TR_QuestionSettings TSS WITH(NOLOCK)
	    WHERE QuestionId = @QuestionId AND TSS.SettingId IN(4,17,19) AND TSS.Value = 'True'
	    IF @IsMTB = 3
	    BEGIN
	         
			SET @SongId = (SELECT TOP 1 FILELIBID FROM TR_Respondent_PlayList  WITH(NOLOCK)
			WHERE QuestionId = @QuestionId and SurveyId = @SurveyId
			AND 
			( 
				(
					ISNULL(@RespondentId,0) = 0 
					AND SessionId = @SessionId
				)
				OR
				(
					(ISNULL(@RespondentId,0) > 0 AND RespondentId = @RespondentId)
				)
			) 
			ORDER BY RowId)
			UPDATE #Progress SET SongId = @SongId
	    END
	END
	
	SELECT * FROM #Progress

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END