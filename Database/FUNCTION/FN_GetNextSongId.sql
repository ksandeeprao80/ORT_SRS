/****** Object:  UserDefinedFunction [dbo].[FN_GetNextSongId]    Script Date: 04/12/2013 10:02:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_GetNextSongId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FN_GetNextSongId]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetNextSongId]    Script Date: 04/12/2013 10:02:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SELECT DBO.[FN_GetNextSongId] (1990,17359,1122,1)

CREATE FUNCTION [dbo].[FN_GetNextSongId]
(
	@SurveyId INT,
	@QuestionId INT,
	@SongId INT,
	@AnswerId INT
)
RETURNS VARCHAR(30)
AS
BEGIN
	DECLARE @NextSongId INT
	DECLARE @PlayListId VARCHAR(12)
	DECLARE @SongRowId INT
		
	IF (ISNULL(@SongId,0)>0 AND @AnswerId IN(1,2,3,4,5,6))
	BEGIN
		SELECT @PlayListId = TSS.Value FROM DBO.TR_QuestionSettings TSS WHERE TSS.QuestionId = @QuestionId
		AND TSS.SettingId = 7 AND ISNULL(TSS.Value,'') <> '' 
		
		IF ISNULL(@PlayListId,'') <> ''
		BEGIN
			IF EXISTS
			(
				SELECT 1 FROM DBO.TR_QuestionSettings TSS WHERE TSS.QuestionId = @QuestionId
				AND TSS.SettingId = 19 AND TSS.Value = 'True'
			)
			BEGIN
				SELECT @SongRowId = RowId FROM DBO.TR_Respondent_PlayList 
				WHERE SurveyId = @SurveyId AND FileLibId = @SongId
					
				SELECT @NextSongId = FileLibId FROM DBO.TR_Respondent_PlayList 
				WHERE SurveyId = @SurveyId AND RowId = @SongRowId+1
			END 
			ELSE
			BEGIN
				SELECT @SongRowId = RowId FROM DBO.TR_PlayList 
				WHERE CONVERT(VARCHAR(12),PlayListId) = @PlayListId AND FileLibId = @SongId
				
				SELECT @NextSongId = FileLibId FROM DBO.TR_PlayList 
				WHERE CONVERT(VARCHAR(12),PlayListId) = @PlayListId AND RowId = @SongRowId+1
			END
		END
	END  
	
	RETURN @NextSongId
END