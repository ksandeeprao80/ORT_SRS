IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdateTempSoundClipInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdateTempSoundClipInfo
GO
/*  
EXEC UspUpdateTempSoundClipInfo '<?xml version="1.0" encoding="utf-16"?>
<ArrayOfSoundClip>
	<SoundClip>
		<FileLibId>36</FileLibId>
		<Title>Shriya</Title>
		<Artist>Updhaya</Artist>
		<Year>1960</Year>
		<FilePath>E:\Nilesh\SRS\CSVXmlMapping\Bonded_for_Life_030_sec_preview.mp3</FilePath>
		<TempId>29</TempId>
		<Status>O</Status>
		<StatusMessage>Success</StatusMessage>
		<SessionId>
		 	<SessionId>179</SessionId>
		</SessionId>
	</SoundClip>
	<SoundClip>
		<FileLibId>36</FileLibId>
		<Title>Prasanna</Title>
		<Artist>Kamble</Artist>
		<Year>1972</Year>
		<FilePath>E:\Nilesh\SRS\CSVXmlMapping\Box_of_Chocolates_030_sec_preview.mp3</FilePath>
		<TempId>30</TempId>
		<Status>O</Status>
		<StatusMessage>Success</StatusMessage>
		<SessionId>
		 	<SessionId>179</SessionId>
		</SessionId>
	</SoundClip>
	<SoundClip>
		<FileLibId>36</FileLibId>
		<Title>Vijay</Title>
		<Artist>Thorat</Artist>
		<Year>1988</Year>
		<FilePath>E:\Nilesh\SRS\CSVXmlMapping\Crazy_Motel_030_sec_preview.mp3</FilePath>
		<TempId>31</TempId>
		<Status>O</Status>
		<StatusMessage>Success</StatusMessage>
		<SessionId>
		 <	SessionId>179</SessionId>
		</SessionId>
	</SoundClip>
	<SoundClip>
		<FileLibId>36</FileLibId>
		<Title>Sudeep</Title>
		<Artist>Tavai</Artist>
		<Year>1960</Year>
		<FilePath>E:\Nilesh\SRS\CSVXmlMapping\Disappeared_in_the_Wind_030_sec_preview.mp3</FilePath>
		<TempId>32</TempId>
		<Status>O</Status>
		<StatusMessage>Success</StatusMessage>
		<SessionId>
		 	<SessionId>179</SessionId>
		</SessionId>
	</SoundClip>
</ArrayOfSoundClip>'  
*/  
   
CREATE PROCEDURE DBO.UspUpdateTempSoundClipInfo  
	@XmlData AS NTEXT  
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  

	BEGIN TRAN  
  
	DECLARE @input XML = @XmlData  
	------------------------------------------------------------------------

	CREATE TABLE #SoundClipInfo
	(
		FileLibId VARCHAR(20), Title VARCHAR(100), Artist VARCHAR(100), FileLibYear VARCHAR(50), FilePath VARCHAR(1000),  
		TempId VARCHAR(20), Status VARCHAR(50), StatusMessage VARCHAR(500), SessionId VARCHAR(50)
	)
	INSERT INTO #SoundClipInfo
	(
		FileLibId, Title, Artist, FileLibYear, FilePath, TempId, Status, StatusMessage, SessionId
	)
	SELECT  
		Child.Elm.value('(FileLibId)[1]','VARCHAR(20)') AS FileLibId,  
		Child.Elm.value('(Title)[1]','VARCHAR(100)') AS Title,  
		Child.Elm.value('(Artist)[1]','VARCHAR(100)') AS Artist,  
		Child.Elm.value('(Year)[1]','VARCHAR(50)') AS FileLibYear,  
		Child.Elm.value('(FilePath)[1]','VARCHAR(1000)') AS FilePath,  
		Child.Elm.value('(TempId)[1]','VARCHAR(20)') AS TempId,  
		Child.Elm.value('(Status)[1]','VARCHAR(50)') AS Status,  
		Child.Elm.value('(StatusMessage)[1]','VARCHAR(500)') AS StatusMessage,  
		Child1.Elm.value('(SessionId)[1]','VARCHAR(50)') AS SessionId
	--INTO #SoundClipInfo  
	FROM @input.nodes('/ArrayOfSoundClip') AS Parent(Elm)  
	CROSS APPLY  
		Parent.Elm.nodes('SoundClip') AS Child(Elm)  
	CROSS APPLY  
		Child.Elm.nodes('SessionId') AS Child1(Elm)  
  
	UPDATE TSCI  
	SET TSCI.FileLibId = SCI.FileLibId,
	    TSCI.Title = SCI.Title,
	    TSCI.Artist = SCI.Artist,
	    TSCI.FileLibYear = SCI.FileLibYear,
	    TSCI.FilePath = SCI.FilePath,
	    TSCI.Status = SCI.Status,
	    TSCI.StatusMessage = SCI.StatusMessage,
	    TSCI.SessionId = SCI.SessionId
	FROM DBO.TempSoundClipInfo TSCI  
	INNER JOIN #SoundClipInfo SCI  
		ON TSCI.TempId = SCI.TempId  
  
	DECLARE @SessionId VARCHAR(50)  
	DECLARE @TotalCount INT  
	DECLARE @TotalExceptionCount INT  
	DECLARE @TotalInsertCount INT  
	
	SET @TotalCount = 0  
	SET @TotalInsertCount = 0  
	SET @TotalExceptionCount = 0  
	SELECT @SessionId = SessionId FROM #SoundClipInfo   
 
	SELECT @TotalCount = COUNT(1) FROM DBO.TempSoundClipInfo WHERE SessionId = @SessionId  
	SELECT @TotalExceptionCount = COUNT(1) FROM DBO.TempSoundClipInfo WHERE SessionId = @SessionId AND Status = 'E'  
	SELECT @TotalInsertCount = COUNT(1) FROM DBO.TempSoundClipInfo WHERE SessionId = @SessionId AND Status = 'O'  
	
	SELECT 1 AS RetValue, 'Successfully Inserted/Updated' AS Remark, @SessionId AS SessionId,  
	ISNULL(@TotalCount,0) AS TotalCount, ISNULL(@TotalExceptionCount,0) AS TotalExceptionCount,   
	ISNULL(@TotalInsertCount,0) AS TotalInsertCount   
	
	DROP TABLE #SoundClipInfo

	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 

