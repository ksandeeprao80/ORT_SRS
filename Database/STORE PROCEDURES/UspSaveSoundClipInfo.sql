IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSoundClipInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSoundClipInfo]
GO
-- EXEC UspSaveSoundClipInfo 
CREATE PROCEDURE DBO.UspSaveSoundClipInfo
	@FileLibId INT,
	@Title VARCHAR(100),
	@Artist VARCHAR(100),
	@FileLibYear  VARCHAR(4),
	@FilePath VARCHAR(1000)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_SoundClipInfo WITH(NOLOCK)
		WHERE FileLibId = @FileLibId AND Title = @Title AND Artist = @Artist
			AND FileLibYear = @FileLibYear AND FilePath = @FilePath
	) 
	BEGIN
		SELECT 1 AS RetValue, 'Already Exist In The System' AS Remark
		
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TR_SoundClipInfo
		(		
			FileLibId, Title, Artist, FileLibYear, FilePath
		)
		VALUES
		(
			@FileLibId, @Title, @Artist, @FileLibYear, @FilePath
	 	)
	
		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark 
		
		RETURN
	END
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END