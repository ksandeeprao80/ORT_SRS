IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSavePanelCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSavePanelCategory
GO
/*
EXEC UspSavePanelCategory '<?xml version="1.0" encoding="utf-16"?>
<PanelCategory>
  <CategoryId>undefined</CategoryId>
  <CategoryName>HelloCategory</CategoryName>
  <CategoryDescription>19</CategoryDescription>
  <LibraryId>5</LibraryId>
</PanelCategory>'
*/

CREATE PROCEDURE DBO.UspSavePanelCategory
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	-----------------------------------------------------------------------------

	CREATE TABLE #PanelCategory
	(
		CategoryId VARCHAR(20), CategoryName VARCHAR(100), LibId VARCHAR(50)
	)
	INSERT INTO #PanelCategory
	(
		CategoryId, CategoryName, LibId
	)
	SELECT
		Parent.Elm.value('(CategoryId)[1]','VARCHAR(20)') AS CategoryId,
		Parent.Elm.value('(CategoryName)[1]','VARCHAR(100)') AS CategoryName,
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(50)') AS LibId
	--INTO #PanelCategory
	FROM @input.nodes('/PanelCategory') AS Parent(Elm)

	DECLARE @CategoryId INT
	SELECT @CategoryId = 0

	-- New Users insert query
	INSERT INTO DBO.TR_PanelCategory
	(CategoryName, LibId)
	SELECT 
		LTRIM(RTRIM(CategoryName)), CONVERT(INT,LibId)
	FROM #PanelCategory PM
	WHERE CategoryId = 'undefined' 

	SET @CategoryId = @@IDENTITY
	
	SELECT 1 AS RetValue, 'Successfully Inserted/Updated' AS Remark, @CategoryId AS CategoryId

	DROP TABLE #PanelCategory

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

