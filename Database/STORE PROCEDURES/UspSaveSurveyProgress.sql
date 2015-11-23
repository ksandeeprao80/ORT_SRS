IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyProgress]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveSurveyProgress
GO 
-- EXEC UspSaveSurveyProgress 3,'123121311D1A23DS1ASDF23SDF13'
CREATE PROCEDURE DBO.UspSaveSurveyProgress
	@QuestionId INT,
	@SessionId VARCHAR(100),
	@RespondentId INT,
	@SongId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	IF NOT EXISTS
	(
		SELECT 1 FROM DBO.TR_SurveyProgress
		WHERE QuestionId = @QuestionId 
		AND LTRIM(RTRIM(SessionId)) = LTRIM(RTRIM(@SessionId))
		AND ISNULL(RespondentId,0) = ISNULL(@RespondentId,0)
		AND ISNULL(SongId,0) = ISNULL(@SongId,0)
	)
	BEGIN
		INSERT INTO DBO.TR_SurveyProgress	
		(SessionId, QuestionId, RespondentId, SongId)
		VALUES(@SessionId, @QuestionId, @RespondentId, @SongId)
	END

	SELECT 1 AS RetValue, 'Successfully Inserted/Updated' AS Remark
						
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
