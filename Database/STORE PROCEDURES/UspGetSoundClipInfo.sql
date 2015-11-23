IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSoundClipInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetSoundClipInfo]

GO

-- EXEC UspGetSoundClipInfo 2
CREATE PROCEDURE DBO.UspGetSoundClipInfo 
	@FileLibId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TSI.FileLibId, LTRIM(RTRIM(ISNULL(TSI.Title,''))) AS Title,
		LTRIM(RTRIM(ISNULL(TSI.Artist,''))) AS Artist,
		LTRIM(RTRIM(ISNULL(TSI.FileLibYear,''))) AS FileLibYear,
		LTRIM(RTRIM(ISNULL(TSI.FilePath,''))) AS FilePath,
		LTRIM(RTRIM(ISNULL(TFL.FileLibName,''))) AS FileLibName,
		LTRIM(RTRIM(ISNULL(TFL.Category,''))) AS Category,
		LTRIM(RTRIM(ISNULL(TFL.[FileName],''))) AS [FileName],
		LTRIM(RTRIM(ISNULL(TFL.FileType,''))) AS FileType
	FROM DBO.TR_SoundClipInfo TSI
	INNER JOIN DBO.TR_FileLibrary TFL
		ON TSI.FileLibId = TFL.FileLibId
 	WHERE TSI.FileLibId = ISNULL(@FileLibId,TSI.FileLibId)
 		AND TFL.IsDeleted = 'N'

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

