IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSoundClipInfoException]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveSoundClipInfoException
GO
CREATE PROCEDURE DBO.UspSaveSoundClipInfoException
	@SessionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @RowCount INT
	SET @RowCount = 0

	INSERT INTO DBO.TR_SoundClipInfoException
	(
		FileLibId, Title, Artist, FileLibYear, FilePath, Status, StatusMessage, SessionId, UserId, CustomerId
	)
	SELECT 
		FileLibId, Title, Artist, FileLibYear, FilePath, Status, StatusMessage, SessionId, UserId, CustomerId
	FROM DBO.TempSoundClipInfo
	WHERE SessionId = @SessionId
		AND Status = 'E'
	
	SET @RowCount = @@ROWCOUNT

	IF @RowCount > 0
	BEGIN 
		DELETE FROM DBO.TempSoundClipInfo WHERE Status = 'E' AND SessionId = @SessionId  
	END
	
	SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark, ISNULL(@RowCount,0) AS ExceptionCount

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END