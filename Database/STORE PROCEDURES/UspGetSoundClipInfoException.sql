IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSoundClipInfoException]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSoundClipInfoException]

GO

--EXEC UspGetSoundClipInfoException 
CREATE PROCEDURE DBO.UspGetSoundClipInfoException
	@SessionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		ExceptionId, ISNULL(FileLibId,0) AS FileLibId, ISNULL(Title,'') AS Title, ISNULL(Artist,'') AS Artist, 
		ISNULL(FileLibYear,'') AS FileLibYear, ISNULL(FilePath,'') AS FilePath, ISNULL([Status],'') AS [Status], 
		ISNULL(StatusMessage,'') AS StatusMessage, ISNULL(SessionId,0) AS SessionId, ISNULL(UserId,'') AS UserId,
		ISNULL(CustomerId,'') AS CustomerId
	FROM DBO.TR_SoundClipInfoException WITH(NOLOCK)
	WHERE SessionId = @SessionId 
	ORDER BY ExceptionId ASC	

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

