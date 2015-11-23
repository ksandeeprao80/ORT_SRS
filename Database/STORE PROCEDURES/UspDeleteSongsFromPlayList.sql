IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSongsFromPlayList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteSongsFromPlayList]
GO

--EXEC UspDeleteSongsFromPlayList  
					  
CREATE PROCEDURE DBO.UspDeleteSongsFromPlayList
	@PlayListId INT, 
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	IF EXISTS
	(	
		SELECT 1 FROM DBO.MS_QuestionSettings MQS
		INNER JOIN DBO.TR_QuestionSettings TQS
			ON MQS.SettingId = TQS.SettingId AND MQS.SettingName = 'PlayListId'
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TQS.QuestionId = TSQ.QuestionId
			AND LTRIM(RTRIM(TQS.Value)) = CONVERT(VARCHAR(12),@PlayListId)
		INNER JOIN DBO.TR_Survey TS
			ON TSQ.SurveyId = TS.SurveyId AND TS.IsActive = 1 
	)
	BEGIN
		SELECT 0 AS RetValue, 'Cannot delete song, TestList is being used in an Active Survey' AS Remark	
	END
	ELSE
	BEGIN	
		DECLARE @UserInfo TABLE
		(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
		INSERT INTO @UserInfo
		(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
		EXEC DBO.UspGetLogedInUserData @XmlUserInfo
		
		DECLARE @UserId INT, @CustomerId INT, @RoleDesc VARCHAR(3)
		SELECT 
			@UserId = CONVERT(INT,UserId), 
			@CustomerId = CONVERT(INT,CustomerId), 
			@RoleDesc = LTRIM(RTRIM(RoleDesc))
		FROM @UserInfo
		
		DECLARE @TotalCount INT, @DeleteCount INT
		SET @TotalCount = 0
		SET @DeleteCount = 0

		CREATE TABLE #FileLibIdes
		(PlayListId INT, FileLibId INT, Exist CHAR(1) DEFAULT('N'))
		INSERT INTO #FileLibIdes
		(PlayListId, FileLibId)
		SELECT PlayListId, FileLibId FROM DBO.TR_PlayList WHERE PlayListId = @PlayListId
			
		SELECT @TotalCount = COUNT(1) FROM #FileLibIdes
		
		UPDATE FLI
		SET FLI.Exist = 'Y' 
		FROM #FileLibIdes FLI
		INNER JOIN 
		(
			SELECT TPL.FileLibId 
			FROM DBO.MS_QuestionSettings MQS WITH(NOLOCK)
			INNER JOIN DBO.TR_QuestionSettings TQS WITH(NOLOCK) 
				ON MQS.SettingId = TQS.SettingId AND MQS.SettingName = 'PlayListId'
			INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
				ON TQS.QuestionId = TSQ.QuestionId
				AND LTRIM(RTRIM(TQS.Value)) = CONVERT(VARCHAR(12),@PlayListId)
			INNER JOIN DBO.TR_PlayList TPL WITH(NOLOCK) 
				ON LTRIM(RTRIM(TQS.Value)) = CONVERT(VARCHAR(12),TPL.PlayListId)
				AND TPL.PlayListId = @PlayListId		
			INNER JOIN DBO.TR_Survey TS WITH(NOLOCK)
				ON TSQ.SurveyId = TS.SurveyId AND TS.IsActive = 1 
		) TQS
			ON FLI.FileLibId = TQS.FileLibId
			
		DELETE TR
		FROM DBO.TR_PlayList TR
		INNER JOIN #FileLibIdes FLI
			ON TR.PlayListId = FLI.PlayListId
			AND TR.FileLibId = FLI.FileLibId
			AND FLI.Exist = 'N'
		INNER JOIN DBO.TR_FileLibrary TFL WITH(NOLOCK)
			ON TR.FileLibId = TFL.FileLibId
		INNER JOIN DBO.TR_Library TL WITH(NOLOCK)
			ON TFL.LIBID = TL.LibId
			AND TL.CustomerId = (CASE WHEN @RoleDesc = 'SA' THEN TL.CustomerId ELSE @CustomerId END)
			AND TFL.CreatedBy  = (CASE WHEN @RoleDesc IN( 'SA','GU') THEN TFL.CreatedBy ELSE @UserId END)	
	 		
		SET @DeleteCount = @@ROWCOUNT
		
		IF @DeleteCount IS NULL
			SET @DeleteCount = 0
		IF @TotalCount IS NULL
			SET @TotalCount = 0
		
		IF NOT EXISTS(SELECT 1 FROM TR_PlayList WHERE PlayListId = @PlayListId)
		BEGIN
			DELETE FROM MS_PlayList WHERE PlayListId = @PlayListId
		END
			
		SELECT 1 AS RetValue, CONVERT(VARCHAR(12),@DeleteCount) +' Deleted Out Of :'+ CONVERT(VARCHAR(12),@TotalCount) AS Remark
		
		DROP TABLE #FileLibIdes
	
	END
	
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END