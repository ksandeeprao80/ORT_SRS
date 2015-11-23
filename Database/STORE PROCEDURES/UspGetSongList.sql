IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetSongList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetSongList

GO

-- EXEC UspGetSongList 4
CREATE PROCEDURE DBO.UspGetSongList
	@PlayListId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TPL.PlayListId, TPL.FileLibId, TL.LibId, TLC.CategoryId, TFL.CreatedBy, TFL.CreatedOn, TFL.ModifiedBy, 
		TFL.ModifiedOn, TFL.FileType, TSCI.Title, TSCI.Artist, TSCI.FileLibYear AS	[Year],TFL.FileName as SongFileName
	FROM DBO.TR_PlayList TPL
	INNER JOIN dbo.TR_FileLibrary TFL 
		ON TPL.FileLibId = TFL.FileLibId
	INNER JOIN DBO.TR_SoundClipInfo TSCI
		ON TPL.FileLibId = TSCI.FileLibId		
	INNER JOIN dbo.TR_Library TL 
		ON TFL.LIBID = TL.LibId
	LEFT JOIN dbo.TR_LibraryCategory TLC 
		ON TLC.LibId = TL.LibId
		AND TLC.CategoryId = TFL.Category
	WHERE TPL.PlayListId = ISNULL(@PlayListId,TPL.PlayListId)
		AND TFL.IsDeleted = 'N'
	ORDER BY TPL.FileLibId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

