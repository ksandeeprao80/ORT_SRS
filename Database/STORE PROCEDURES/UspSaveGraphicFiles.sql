IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveGraphicFiles]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveGraphicFiles

GO  
/*
EXEC UspSaveGraphicFiles '<?xml version="1.0" encoding="utf-16"?>
<Upload>
	<FileType>Graphics</FileType>
	<FileName>FolioDetails.JPG</FileName>
	<CustomerId>1</CustomerId>
	<UploadedBy>5</UploadedBy>
	<UploadedDate>2012-09-14</UploadedDate>
	<ParentId>6</ParentId> -- LibId
	<FolderPath>E:\Nilesh\SRS\ORT_FrontEnd\ORT_FrontEnd\ORT_APPLICATION\GraphicLibFiles</FolderPath>
	<Extension>.JPG</Extension>
	<Category>3</Category>
</Upload>'
*/

CREATE PROCEDURE DBO.UspSaveGraphicFiles
	@XmlData AS NTEXT,
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

	DECLARE @input XML = @XmlData
	----------------------------------------------------------------------

	CREATE TABLE #GraphicFiles
	(
		FileType VARCHAR(50), GraphicFileName VARCHAR(100), CustomerId VARCHAR(20),
		UploadedBy VARCHAR(20), UploadedDate VARCHAR(50), LibId VARCHAR(20),
		FilePath VARCHAR(100), Extension VARCHAR(50), CategoryId VARCHAR(20)
	)
	INSERT INTO #GraphicFiles
	(
		FileType, GraphicFileName, CustomerId, UploadedBy, UploadedDate, 
		LibId, FilePath, Extension, CategoryId
	)
	SELECT 
		Parent.Elm.value('FileType[1]','VARCHAR(50)') AS FileType,
		Parent.Elm.value('FileName[1]','VARCHAR(100)') AS GraphicFileName,
		Parent.Elm.value('CustomerId[1]','VARCHAR(20)') AS CustomerId,
		Parent.Elm.value('UploadedBy[1]','VARCHAR(20)') AS UploadedBy,
		Parent.Elm.value('UploadedDate[1]','VARCHAR(50)') AS UploadedDate,
		Parent.Elm.value('ParentId[1]','VARCHAR(20)') AS LibId,
		Parent.Elm.value('FolderPath[1]','VARCHAR(100)') AS FilePath,
		Parent.Elm.value('Extension[1]','VARCHAR(50)') AS Extension,
		Parent.Elm.value('Category[1]','VARCHAR(20)') AS CategoryId
	--INTO #GraphicFiles
	FROM @input.nodes('/Upload') AS Parent(Elm)

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SLU')
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END

	DECLARE @GraphicFileId INT
	SET @GraphicFileId = 0
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc = 'SA')
	BEGIN
		INSERT INTO DBO.TR_GraphicFiles
		(LibId, CategoryId, GraphicFileName, Extension, FilePath, CustomerId, UploadedBy, UploadedDate)
		SELECT  
			CONVERT(INT,LibId), CONVERT(INT,CategoryId), LTRIM(RTRIM(GraphicFileName)),
			LTRIM(RTRIM(Extension)), LTRIM(RTRIM(FilePath)), CONVERT(INT,CustomerId),
			CONVERT(INT,UploadedBy), GETDATE()
		FROM #GraphicFiles
		
		SET @GraphicFileId = @@IDENTITY

		IF @GraphicFileId = 0
		BEGIN
			SELECT 0 AS RetValue, 'Insert Failed' AS Remark
		END
		ELSE
		BEGIN
			SELECT 
				1 AS RetValue, 'Successfully Inserted' AS Remark, 
				GraphicFileId, LibId, CategoryId, GraphicFileName, Extension, FilePath, CustomerId, UploadedBy, 
				UploadedDate
			FROM TR_GraphicFiles WHERE GraphicFileId = @GraphicFileId
		END   
	END
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('GU','SU'))
	BEGIN
		IF EXISTS
		(
			SELECT 1 FROM DBO.TR_LibraryCategory TLC
			INNER JOIN DBO.TR_Library TL
				ON TLC.LibId = TL.LibId 
			INNER JOIN #GraphicFiles GF 
				ON TLC.CategoryId = CONVERT(INT,GF.CategoryId)
			INNER JOIN @UserInfo UI
				ON TL.CreatedBy = CONVERT(INT,UI.UserId) 
				AND TL.CustomerId = CONVERT(INT,UI.CustomerId)
		)	
		BEGIN
			INSERT INTO DBO.TR_GraphicFiles
			(LibId, CategoryId, GraphicFileName, Extension, FilePath, CustomerId, UploadedBy, UploadedDate)
			SELECT  
				CONVERT(INT,LibId), CONVERT(INT,CategoryId), LTRIM(RTRIM(GraphicFileName)),
				LTRIM(RTRIM(Extension)), LTRIM(RTRIM(FilePath)), CONVERT(INT,CustomerId),
				CONVERT(INT,UploadedBy), GETDATE()
			FROM #GraphicFiles
			
			SET @GraphicFileId = @@IDENTITY

			IF @GraphicFileId = 0
			BEGIN
				SELECT 0 AS RetValue, 'Insert Failed' AS Remark
			END
			ELSE
			BEGIN
				SELECT 
					1 AS RetValue, 'Successfully Inserted' AS Remark, 
					GraphicFileId, LibId, CategoryId, GraphicFileName, Extension, FilePath, CustomerId, UploadedBy, 
					UploadedDate
				FROM TR_GraphicFiles WHERE GraphicFileId = @GraphicFileId
			END   
		END
		ELSE
		BEGIN
			 SELECT 0 AS RetValue, 'Access Denied' AS Remark
		END
	END

	DROP TABLE #GraphicFiles
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
