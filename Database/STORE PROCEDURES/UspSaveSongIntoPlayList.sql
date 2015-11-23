IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSongIntoPlayList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSongIntoPlayList]

GO 
/*
-- EXEC UspSaveSongIntoPlayList '3','91,92,93,792,793,794,801'
*/
CREATE PROCEDURE DBO.UspSaveSongIntoPlayList
	@PlayListId NVARCHAR(20),
	@Songs VARCHAR(MAX)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	CREATE TABLE #PlayList
	(RowId INT, FileLibId VARCHAR(20))
	INSERT INTO #PlayList
	SELECT RowId, Value FROM [dbo].[Split] (',',@Songs)
	-- Split Function used to split the data

	DECLARE @Row INT
	SET @Row = 0

	IF EXISTS
	(	
		SELECT 1 FROM DBO.MS_QuestionSettings MQS WITH(NOLOCK)
		INNER JOIN DBO.TR_QuestionSettings TQS WITH(NOLOCK)
			ON MQS.SettingId = TQS.SettingId
			AND MQS.SettingName = 'PlayListId'
		INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
			ON TQS.QuestionId = TSQ.QuestionId
		INNER JOIN DBO.TR_Survey TS WITH(NOLOCK)
			ON TSQ.SurveyId = TS.SurveyId
			AND ISNULL(TS.SurveyEndDate,'2050-01-01') > CONVERT(VARCHAR(10),GETDATE(),121)
			AND TS.PublishStatus = 'P'
		INNER JOIN #PlayList PL
			ON LTRIM(RTRIM(TQS.Value)) = CONVERT(VARCHAR(12),FileLibId)
	)
	BEGIN
		SELECT 0 AS RetValue, 'Cannot add song, TestList is being used in an Active Survey' AS Remark	
	END
	ELSE
	BEGIN
		-- TR_PlayList insert query 
		INSERT INTO DBO.TR_PlayList
		(PlayListId, FileLibId)
		SELECT @PlayListId, CONVERT(INT,PL.FileLibId) 
		FROM #PlayList PL  
		LEFT OUTER JOIN DBO.TR_PlayList TPL
			ON CONVERT(VARCHAR(12),TPL.FileLibId) = LTRIM(RTRIM(PL.FileLibId))
			AND TPL.PlayListId = @PlayListId
		WHERE TPL.FileLibId IS NULL

		SET @Row = @@ROWCOUNT

		SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
			   CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark 
	END

	DROP TABLE #PlayList
		
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
