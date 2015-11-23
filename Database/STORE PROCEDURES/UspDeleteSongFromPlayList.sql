IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSongFromPlayList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteSongFromPlayList]
GO

--EXEC UspDeleteSongFromPlayList  

CREATE PROCEDURE DBO.UspDeleteSongFromPlayList
	@PlayListId INT,
	@FileLibId INT,
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

		DECLARE @RowId INT
		SET @RowId = 0
		
		DECLARE @UserId INT, @CustomerId INT
		SELECT @UserId = CONVERT(INT,UserId), @CustomerId = CONVERT(INT,CustomerId) FROM @UserInfo
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
		BEGIN
			DELETE FROM DBO.TR_PlayList WHERE PlayListId = @PlayListId AND FileLibId = @FileLibId
			
			SET @RowId = @@ROWCOUNT
			
			SELECT CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Deletion Failed' ELSE 'Successfully Deleted' END AS Remark	
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'GU')
		BEGIN
			DELETE TPL 
			FROM DBO.TR_PlayList TPL
			INNER JOIN DBO.MS_PlayList MPL
				ON TPL.PlayListId = MPL.PlayListId AND TPL.PlayListId = @PlayListId
				AND TPL.FileLibId = @FileLibId AND MPL.CustomerId = @CustomerId
			
			SET @RowId = @@ROWCOUNT
			
			SELECT CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Access Denied' ELSE 'Successfully Deleted' END AS Remark	
		END
		
		IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','SLU'))
		BEGIN
			DELETE TPL 
			FROM DBO.TR_PlayList TPL
			INNER JOIN DBO.MS_PlayList MPL
				ON TPL.PlayListId = MPL.PlayListId AND TPL.PlayListId = @PlayListId
				AND TPL.FileLibId = @FileLibId AND MPL.CreatedBy = @UserId
			
			SET @RowId = @@ROWCOUNT
			
			SELECT CASE WHEN ISNULL(@RowId,0)= 0 THEN 0 ELSE 1 END AS RetValue, 
					CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Access Denied' ELSE 'Successfully Deleted' END AS Remark	
		END	
	END	

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

