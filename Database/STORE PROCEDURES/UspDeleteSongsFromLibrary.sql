IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteSongsFromLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteSongsFromLibrary]
GO

--EXEC UspDeleteSongsFromLibrary  

CREATE PROCEDURE DBO.UspDeleteSongsFromLibrary
	@FileLibIdes AS VARCHAR(1000), -- Comma Seprator (125,25,369,118)
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
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
	(RowId INT, Value INT, Exist CHAR(1) DEFAULT('N'))
	INSERT INTO #FileLibIdes
	(RowId, Value)
	SELECT * FROM DBO.Split(',',@FileLibIdes)
		
	SELECT @TotalCount = COUNT(1) FROM #FileLibIdes
	
	UPDATE FLI
	SET FLI.Exist = 'Y' 
	FROM #FileLibIdes FLI
	INNER JOIN DBO.TR_PlayList TPL
		ON FLI.Value = TPL.FileLibId
		
	UPDATE FLI
	SET FLI.Exist = 'Y' 
	FROM #FileLibIdes FLI
	INNER JOIN 
	(
		SELECT TQS.* FROM DBO.MS_QuestionSettings MQS
		INNER JOIN DBO.TR_QuestionSettings TQS
			ON MQS.SettingId = TQS.SettingId
			AND MQS.SettingName = 'SongFileLibId'
			AND TQS.Value NOT IN('','True','False','0')
	) TQS
		ON CONVERT(VARCHAR(12),FLI.Value) = LTRIM(RTRIM(TQS.Value))
		
	DELETE TSCI
	FROM DBO.TR_SoundClipInfo TSCI
	INNER JOIN #FileLibIdes FLI
		ON TSCI.FileLibId = FLI.Value 
		AND FLI.Exist = 'N'
	INNER JOIN DBO.TR_FileLibrary TFL
		ON TSCI.FileLibId = TFL.FileLibId
	INNER JOIN DBO.TR_Library TL
		ON TFL.LIBID = TL.LibId
		AND TL.CustomerId = (CASE WHEN @RoleDesc = 'SA' THEN TL.CustomerId ELSE @CustomerId END)
		AND TFL.CreatedBy  = (CASE WHEN @RoleDesc IN( 'SA','GU') THEN TFL.CreatedBy ELSE @UserId END)

	UPDATE TFL
	SET TFL.IsDeleted = 'Y',
		TFL.ModifiedBy = @UserId,
		TFL.ModifiedOn = GETDATE()
	FROM DBO.TR_FileLibrary TFL
	INNER JOIN #FileLibIdes FLI
		ON TFL.FileLibId = FLI.Value
		AND FLI.Exist = 'N'
	INNER JOIN DBO.TR_Library TL
		ON TFL.LIBID = TL.LibId
		AND TL.CustomerId = (CASE WHEN @RoleDesc = 'SA' THEN TL.CustomerId ELSE @CustomerId END)
		AND TFL.CreatedBy  = (CASE WHEN @RoleDesc IN( 'SA','GU') THEN TFL.CreatedBy ELSE @UserId END)
		
	SET @DeleteCount = @@ROWCOUNT
		
	SELECT 1 AS RetValue, CONVERT(VARCHAR(12),@DeleteCount) +' Deleted Out Of :'+ CONVERT(VARCHAR(12),@TotalCount) AS Remark
	
	DROP TABLE #FileLibIdes
	
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

