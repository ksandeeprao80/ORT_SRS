IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSurveyLibrary]
GO
/*
EXEC UspSaveSurveyLibrary '<?xml version="1.0" encoding="utf-16"?>
<SurveyLibrary>
	<LibraryId>1</LibraryId>
	<LibType>Survey</LibType>
	<LibraryName>SURVEY</LibraryName>
	<Customer>
		<CustomerId>1</CustomerId>
		<IsActive>false</IsActive>
	</Customer>
	<SurveyLibraryId>undefine</SurveyLibraryId>
	<SurveyInLibrary />
	<SurveyLibraryName>Attention Filter</SurveyLibraryName>
	<Category />
</SurveyLibrary>
*/

CREATE PROCEDURE DBO.UspSaveSurveyLibrary
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	-------------------------------------------------------------------------------------
	CREATE TABLE #SurveyLibrary
	(
		LibraryId VARCHAR(20), LibType VARCHAR(30), LibraryName VARCHAR(100), SurveyLibraryId VARCHAR(20), SurveyInLibrary VARCHAR(150), 
		SurveyLibraryName VARCHAR(150), Category VARCHAR(100), CustomerId VARCHAR(20), IsActive VARCHAR(20)
	)
	INSERT INTO #SurveyLibrary
	(
		LibraryId, LibType, LibraryName, SurveyLibraryId, SurveyInLibrary, SurveyLibraryName, 
		Category, CustomerId, IsActive
	)
	SELECT
		-- SurveyLibrary
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibraryId,
		Parent.Elm.value('(LibType)[1]','VARCHAR(30)') AS LibType,
		Parent.Elm.value('(LibraryName)[1]','VARCHAR(100)') AS LibraryName,
		Parent.Elm.value('(SurveyLibraryId)[1]','VARCHAR(20)') AS SurveyLibraryId,
		Parent.Elm.value('(SurveyInLibrary)[1]','VARCHAR(150)') AS SurveyInLibrary,
		Parent.Elm.value('(SurveyLibraryName)[1]','VARCHAR(150)') AS SurveyLibraryName,
		Parent.Elm.value('(Category)[1]','VARCHAR(100)') AS Category,
		-- Customers 
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive
	--INTO #SurveyLibrary
	FROM @input.nodes('/SurveyLibrary') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Customer') AS Child(Elm)

	DECLARE @LibraryId INT
	SET @LibraryId = 0

	-- New Library insert query
	INSERT INTO DBO.TR_Library
	(
		LibTypeId, LibName, CustomerId, IsActive
	)
	SELECT 
		MLT.LibTypeId, LTRIM(RTRIM(SL.SurveyLibraryName)), CONVERT(INT,SL.CustomerId), 1 AS IsActive
	FROM #SurveyLibrary SL
	INNER JOIN DBO.MS_LibraryType MLT
		ON LTRIM(RTRIM(SL.LibType)) = LTRIM(RTRIM(MLT.TypeName))
	WHERE LTRIM(RTRIM(SL.SurveyLibraryId)) = 'undefine' 

	SET @LibraryId = @@IDENTITY

	SELECT CASE WHEN @LibraryId = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN @LibraryId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
		@LibraryId AS LibraryId

	DROP TABLE #SurveyLibrary	

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END