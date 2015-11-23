IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetRespondentPlayList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetRespondentPlayList]
  
GO

--EXEC UspGetRespondentPlayList @SessionId='u3cm1c55eo4sid3s5tr0jz55',@SurveyId='1658',@RespondentId=5310,@QuestionId =15280

CREATE PROCEDURE DBO.UspGetRespondentPlayList
	@SurveyId INT,
	@SessionId VARCHAR(100),
	@RespondentId INT,
	@QuestionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	IF @RespondentId IS NULL
	SET @RespondentId = 0	

	DECLARE @CompleteCount INT
	DECLARE @NewCount INT
	
	IF @RespondentId = 0
	BEGIN
		SELECT @CompleteCount = COUNT(1) FROM DBO.TR_Responses WITH(NOLOCK) 
		WHERE QuestionId = @QuestionId AND [Status] = 'C' AND SessionId = @SessionId
		
		SELECT @NewCount = COUNT(1) FROM DBO.TR_Responses WITH(NOLOCK) 
		WHERE QuestionId = @QuestionId AND SessionId = @SessionId
	END
	ELSE
	BEGIN
		SELECT @CompleteCount = COUNT(1) FROM DBO.TR_Responses WITH(NOLOCK) 
		WHERE QuestionId = @QuestionId AND [Status] = 'C' AND RespondentId = @RespondentId
		
		SELECT @NewCount = COUNT(1) FROM DBO.TR_Responses WITH(NOLOCK) 
		WHERE QuestionId = @QuestionId AND RespondentId = @RespondentId
	END
	
	IF (@CompleteCount > 0 OR @NewCount = 0)
	BEGIN
	   IF NOT EXISTS
	(
		SELECT 1 FROM DBO.TR_Respondent_PlayList WITH(NOLOCK) 
		WHERE SurveyId = @SurveyId AND QuestionId = @QuestionId
		AND 
		(
			(
				@RespondentId = 0 AND SessionId = @SessionId
			)
			OR
			(
				RespondentId = @RespondentId AND @RespondentId <> 0
			)		
		) 
	)
	BEGIN
		DECLARE @PlayListId INT

		SELECT @PlayListId = TQS.Value
		FROM DBO.MS_QuestionSettings MQS  WITH(NOLOCK) 
		INNER JOIN DBO.PB_TR_QuestionSettings TQS WITH(NOLOCK) 
			ON TQS.SettingId = MQS.SettingId 
			AND MQS.SettingName = 'PlayListId'
		INNER JOIN DBO.PB_TR_SurveyQuestions TSQ WITH(NOLOCK) 
			ON TSQ.QuestionId = TQS.QuestionId 
			AND TSQ.QuestionId = @QuestionId
			AND TQS.Value NOT IN ('0','')
			AND TSQ.IsDeleted = 1

		BEGIN TRAN	
		
		DECLARE @RowCount INT

		INSERT INTO DBO.TR_Respondent_PlayList
		(SurveyId, SessionId, FileLibId, RespondentId, QuestionId)
		SELECT 
			@SurveyId, @SessionId, TP.FileLibId, @RespondentId, @QuestionId 
		FROM DBO.TR_PlayList TP WITH(NOLOCK) 
		INNER JOIN DBO.TR_FileLibrary TFL WITH(NOLOCK) 
			ON TP.FileLibId = TFL.FileLibId
			AND TP.PlayListId = @PlayListId
			AND  
			(	TFL.[FileName] NOT LIKE '%&%' 
				AND TFL.[FileName] NOT LIKE '%~%' 
				AND TFL.[FileName] NOT LIKE '%!%' 
				AND TFL.[FileName] NOT LIKE '%@%' 
				AND TFL.[FileName] NOT LIKE '%#%' 
				AND TFL.[FileName] NOT LIKE '%$%' 
				AND TFL.[FileName] NOT LIKE '%^%' 
				AND TFL.[FileName] NOT LIKE '%*%'
				AND TFL.[FileName] NOT LIKE '%+%' 
				AND TFL.[FileName] NOT LIKE '%:%'
				AND TFL.[FileName] NOT LIKE '%''%'
				AND TFL.[FileName] NOT LIKE '%"%'
			) 
		ORDER BY TP.PlayListId, NEWID()
		
		SET @RowCount = @@ROWCOUNT
		
		IF @RowCount = 0
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		COMMIT TRAN
		END
	END
	
	DECLARE @Value INT 
	DECLARE @SQL NVARCHAR(MAX)   
	SELECT @Value = LTRIM(RTRIM(Value)) FROM PB_TR_SurveySettings WHERE SurveyId = @SurveyId AND SettingId = 80
    
	IF @RespondentId = 0
	BEGIN
		SET @SQL ='
		SELECT   
			TOP '+CONVERT(VARCHAR(12),@Value)+ '
			TPL.SurveyId, TPL.SessionId, TPL.FileLibId, TL.LibId, TLC.CategoryId, TFL.CreatedBy, TFL.CreatedOn, 
			TFL.ModifiedBy, TFL.ModifiedOn, TFL.FileType, TPL.RespondentId, TPL.QuestionId,
			TSCI.Title, TSCI.Artist, TSCI.FileLibYear AS Year ,TFL.FileName AS SongFileName
		FROM DBO.TR_Respondent_PlayList TPL WITH(NOLOCK) 
		INNER JOIN dbo.TR_FileLibrary TFL WITH(NOLOCK) 
			ON TPL.FileLibId = TFL.FileLibId
		INNER JOIN DBO.TR_SoundClipInfo TSCI WITH(NOLOCK) 
			ON TPL.FileLibId = TSCI.FileLibId	
		INNER JOIN dbo.TR_Library TL WITH(NOLOCK)  
			ON TFL.LIBID = TL.LibId
		LEFT OUTER JOIN dbo.TR_LibraryCategory TLC WITH(NOLOCK)  
			ON TLC.LibId = TL.LibId
			AND TLC.CategoryId = TFL.Category
		WHERE TPL.SurveyId = '+CONVERT(VARCHAR(12),@SurveyId)+' 
			AND TPL.QuestionId = '+CONVERT(VARCHAR(12),@QuestionId)+'
			AND TPL.SessionId = '+''''+@SessionId+''''+'
		ORDER BY TPL.RowId'	
		
		EXEC Sp_Executesql @SQL
	END
	ELSE
	BEGIN
		SET @SQL ='
		SELECT   
			TOP '+CONVERT(VARCHAR(12),@Value)+ '
			TPL.SurveyId, TPL.SessionId, TPL.FileLibId, TL.LibId, TLC.CategoryId, TFL.CreatedBy, TFL.CreatedOn, 
			TFL.ModifiedBy, TFL.ModifiedOn, TFL.FileType, TPL.RespondentId, TPL.QuestionId,
			TSCI.Title, TSCI.Artist, TSCI.FileLibYear AS [Year] ,TFL.[FileName] AS SongFileName
		FROM DBO.TR_Respondent_PlayList TPL WITH(NOLOCK) 
		INNER JOIN dbo.TR_FileLibrary TFL WITH(NOLOCK) 
			ON TPL.FileLibId = TFL.FileLibId
		INNER JOIN DBO.TR_SoundClipInfo TSCI WITH(NOLOCK) 
			ON TPL.FileLibId = TSCI.FileLibId	
		INNER JOIN dbo.TR_Library TL WITH(NOLOCK)  
			ON TFL.LIBID = TL.LibId
		LEFT OUTER JOIN dbo.TR_LibraryCategory TLC WITH(NOLOCK)  
			ON TLC.LibId = TL.LibId
			AND TLC.CategoryId = TFL.Category
		WHERE TPL.SurveyId = '+CONVERT(VARCHAR(12),@SurveyId)+' 
			AND TPL.QuestionId = '+CONVERT(VARCHAR(12),@QuestionId)+'
			AND TPL.RespondentId = '+CONVERT(VARCHAR(12),@RespondentId)+'
		ORDER BY TPL.RowId'	
		
		EXEC Sp_Executesql @SQL
	END
    
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
