IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSession]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSession]

GO 
/*   
EXEC UspSaveSession '<?xml version="1.0" encoding="utf-16"?>
<Upload>
	<FileType>Panel</FileType>
	<FileName>Book1.xls</FileName>
	<CustomerId>1</CustomerId>
	<UploadedBy>5</UploadedBy>
	<UploadedDate>2012-09-01</UploadedDate>
	<Extension>1<Extension>	
  	<ParentId>2</ParentId>
</Upload>'  
*/ -- select * from TR_UploadSession Truncate table TR_UploadSession  
   
CREATE PROCEDURE DBO.UspSaveSession  
	@XmlData AS NTEXT  
AS  
SET NOCOUNT ON  
BEGIN  
BEGIN TRY  
  
	BEGIN TRAN

	DECLARE @input XML = @XmlData  
	---------------------------------------------------------------------

	CREATE TABLE #Session
	(
		FileType VARCHAR(50), [FileName] VARCHAR(150), CustomerId VARCHAR(50), UploadedBy VARCHAR(50),  
		UploadedDate VARCHAR(50), Extension VARCHAR(20), ParentId VARCHAR(50)
	)
	INSERT INTO #Session
	(
		FileType, [FileName], CustomerId, UploadedBy, UploadedDate, Extension, ParentId
	)
	SELECT  
		Parent.Elm.value('(FileType)[1]','VARCHAR(50)') AS FileType,  
		Parent.Elm.value('(FileName)[1]','VARCHAR(150)') AS [FileName],  
		Parent.Elm.value('(CustomerId)[1]','VARCHAR(50)') AS CustomerId,  
		Parent.Elm.value('(UploadedBy)[1]','VARCHAR(50)') AS UploadedBy,  
		Parent.Elm.value('(UploadedDate)[1]','VARCHAR(50)') AS UploadedDate,  
		Parent.Elm.value('(Extension)[1]','VARCHAR(20)') AS Extension,
  		Parent.Elm.value('(ParentId)[1]','VARCHAR(50)') AS ParentId
	--INTO #Session  
	FROM @input.nodes('/Upload') AS Parent(Elm)  
  
	DECLARE @SessionId INT  
	SET @SessionId = 0  
  
	INSERT INTO DBO.TR_UploadSession  
	(
		FileType, [FileName], CustomerId, UploadedBy, UploadedDate, ParentId, Extension
	)  
	SELECT   
		LTRIM(RTRIM(FileType)) AS FileType, LTRIM(RTRIM([FileName])) AS [FileName], CONVERT(INT,CustomerId) AS CustomerId,   
		CONVERT(INT,UploadedBy) AS UploadedBy, GETDATE() AS UploadedDate,  CONVERT(INT,ParentId) AS ParentId,
		LTRIM(RTRIM(Extension))  
	FROM #Session  
  
	SET @SessionId = @@IDENTITY  
   
	SELECT   
		1 AS RetValue, SessionId, FileType, [FileName], CustomerId, UploadedBy, UploadedDate, ParentId, Extension  
	FROM DBO.TR_UploadSession  
	WHERE SessionId = @SessionId   

	DROP TABLE #Session
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
