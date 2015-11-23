IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveBulkSoundClipInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveBulkSoundClipInfo
GO
CREATE PROCEDURE DBO.UspSaveBulkSoundClipInfo
	@SessionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	INSERT INTO DBO.TR_SoundClipInfoException
	(
		FileLibId, Title, Artist, FileLibYear, FilePath, [Status], StatusMessage, SessionId, UserId, CustomerId
	)
	SELECT 
		FileLibId, Title, Artist, FileLibYear, FilePath, [Status], StatusMessage, SessionId, UserId, CustomerId
	FROM DBO.TempSoundClipInfo
	WHERE SessionId = @SessionId
		AND [Status] = 'E'

	INSERT INTO DBO.TR_SoundClipInfo
	(
		FileLibId, Title, Artist, FileLibYear, FilePath
	)
	SELECT 
		FileLibId, Title, Artist, FileLibYear, FilePath
	FROM DBO.TempSoundClipInfo
	WHERE SessionId = @SessionId
		AND [Status] = 'O'	 

	DELETE FROM TempSoundClipInfo WHERE SessionId = @SessionId

	SELECT 1 AS RetValue, 'Successfully Inserted/Updated' AS Remark

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
