IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSongList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSongList]

GO
/*
EXEC UspSaveSongList '<?xml version="1.0" encoding="utf-16"?>
<TestList>
	<SongList>
		<PlayListId>2</PlayListId>
		<FileLibrary>
			<FileLibId>91</FileLibId>
		</FileLibrary>
	</SongList>
	<SongList>
		<PlayListId>2</PlayListId>
		<FileLibrary>
			<FileLibId>92</FileLibId>
		</FileLibrary>
	</SongList>
	<SongList>
		<PlayListId>2</PlayListId>
		<FileLibrary>
			<FileLibId>93</FileLibId>
		</FileLibrary>
	</SongList>
	<SongList>
		<PlayListId>2</PlayListId>
		<FileLibrary>
			<FileLibId>94</FileLibId>
		</FileLibrary>
	</SongList>
</TestList>'
*/
CREATE PROCEDURE DBO.UspSaveSongList
	@XmlData NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData

	CREATE TABLE #PlayList
	(
		PlayListId VARCHAR(20), FileLibId VARCHAR(20)
	)
	INSERT INTO #PlayList
	(	
		PlayListId, FileLibId
	)
	SELECT
		Child.Elm.value('(PlayListId)[1]','VARCHAR(20)') AS PlayListId,
		Child1.Elm.value('(FileLibId)[1]','VARCHAR(20)') AS FileLibId
	--INTO #PlayList
	FROM @input.nodes('/TestList') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('SongList') AS Child(Elm)
	CROSS APPLY
		Child.Elm.nodes('FileLibrary') AS Child1(Elm)

	/*-- If Playlist id exist than delete and insert new one as per xml*/
	DELETE TPL FROM DBO.TR_PlayList TPL INNER JOIN #PlayList PL 
	ON CONVERT(VARCHAR(12),TPL.PlayListId) = LTRIM(RTRIM(PL.PlayListId))
	
	DECLARE @Row INT
	SET @Row = 0
	
	-- TR_PlayList insert query 
	INSERT INTO DBO.TR_PlayList
	(
		PlayListId, FileLibId
	)
	SELECT 
		PL.PlayListId, PL.FileLibId
	FROM #PlayList PL
	INNER JOIN DBO.MS_PlayList MPL
		ON LTRIM(RTRIM(PL.PlayListId)) = CONVERT(VARCHAR(12),MPL.PlayListId) 
	INNER JOIN DBO.TR_FileLibrary TFL
		ON LTRIM(RTRIM(PL.FileLibId)) = CONVERT(VARCHAR(12),TFL.FileLibId)

	SET @Row = @@ROWCOUNT

	SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark 

	DROP TABLE #PlayList
		
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

