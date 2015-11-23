IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveGraphicInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveGraphicInfo]

GO
/*
EXEC UspSaveGraphicInfo '<?xml version="1.0" encoding="utf-16"?>
<GraphicLibrary>
	<GraphicLibId>1</GraphicLibId>
	<GraphicFileName>Ladder Scales Test</GraphicFileName>
	<FileType>jpg</FileType>
	<RelativePath>/test/test/test</RelativePath>
</GraphicLibrary>'
*/ 

CREATE PROCEDURE DBO.UspSaveGraphicInfo
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	-----------------------------------------------------------------------------

	CREATE TABLE #GraphicInfo
	(
		GraphicLibId VARCHAR(20), GraphicFileName VARCHAR(150), FileType VARCHAR(50), RelativePath VARCHAR(100)
	)
	INSERT INTO #GraphicInfo
	(
		GraphicLibId, GraphicFileName, FileType, RelativePath
	)
	SELECT
		Parent.Elm.value('(GraphicLibId)[1]','VARCHAR(20)') AS GraphicLibId,
		Parent.Elm.value('(GraphicFileName)[1]','VARCHAR(150)') AS GraphicFileName,
		Parent.Elm.value('(FileType)[1]','VARCHAR(50)') AS FileType,
		Parent.Elm.value('(RelativePath)[1]','VARCHAR(100)') AS RelativePath
	--INTO #GraphicInfo
	FROM @input.nodes('/GraphicLibrary') AS Parent(Elm)

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_GraphicInfo TGI 
		INNER JOIN #GraphicInfo GI 
		ON TGI.GraphicLibId = CONVERT(INT,GI.GraphicLibId)
	)
	BEGIN
		UPDATE TGI
		SET TGI.GraphicFileName = GI.GraphicFileName,
		    TGI.FileType = GI.FileType,
		    TGI.RelativePath = GI.RelativePath
		FROM DBO.TR_GraphicInfo TGI 
		INNER JOIN #GraphicInfo GI 
		ON TGI.GraphicLibId = CONVERT(INT,GI.GraphicLibId)
		
		SELECT 1 AS RetValue, 'Successfully Updated' AS Remark
	END
	ELSE
	BEGIN
		DECLARE @Row INT
		SET @Row = 0
		
		INSERT INTO DBO.TR_GraphicInfo
		(GraphicLibId, GraphicFileName, FileType, RelativePath)
		SELECT 
			CONVERT(INT,GraphicLibId), GraphicFileName, FileType, RelativePath
		FROM #GraphicInfo
		
		SET @Row = @@ROWCOUNT
		
		SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
			   CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
		
	END
	
	DROP TABLE #GraphicInfo

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

