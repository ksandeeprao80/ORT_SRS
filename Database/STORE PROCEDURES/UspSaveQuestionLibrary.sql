IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveQuestionLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveQuestionLibrary
GO
/*
EXEC UspSaveQuestionLibrary '<?xml version="1.0" encoding="utf-16"?>
<QuestionLibrary>
	<LibraryId>2</LibraryId>
	<LibType>Question</LibType>
	<LibraryName>QUESTION</LibraryName>
	<Customer>
		<CustomerId>1</CustomerId>
		<IsActive>false</IsActive>
	</Customer>
	<QuestionLibraryId>undefine</QuestionLibraryId>
	<QuestionInLibrary />
	<QuestionLibraryName>Golden Era Songs</QuestionLibraryName>
	<Category />
</QuestionLibrary>'
*/
CREATE PROCEDURE DBO.UspSaveQuestionLibrary
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	-------------------------------------------------------------------------------------
	CREATE TABLE #QuestionLibrary
	(
		 LibraryId VARCHAR(20), LibType VARCHAR(30), LibraryName VARCHAR(100), QuestionLibraryId VARCHAR(150), QuestionInLibrary VARCHAR(150),
		 QuestionLibraryName VARCHAR(150), Category VARCHAR(150), CustomerId VARCHAR(20), IsActive VARCHAR(20)
	)
	INSERT INTO #QuestionLibrary
	(
		LibraryId, LibType, LibraryName, QuestionLibraryId, QuestionInLibrary,
		QuestionLibraryName, Category, CustomerId, IsActive
	)
	SELECT
		-- QuestionLibrary
		Parent.Elm.value('(LibraryId)[1]','VARCHAR(20)') AS LibraryId,
		Parent.Elm.value('(LibType)[1]','VARCHAR(30)') AS LibType,
		Parent.Elm.value('(LibraryName)[1]','VARCHAR(100)') AS LibraryName,
		Parent.Elm.value('(QuestionLibraryId)[1]','VARCHAR(150)') AS QuestionLibraryId,
		Parent.Elm.value('(QuestionInLibrary)[1]','VARCHAR(150)') AS QuestionInLibrary,
		Parent.Elm.value('(QuestionLibraryName)[1]','VARCHAR(150)') AS QuestionLibraryName,
		Parent.Elm.value('(Category)[1]','VARCHAR(150)') AS Category,
		-- Customer
		Child.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Child.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive
	--INTO #QuestionLibrary
	FROM @input.nodes('/QuestionLibrary') AS Parent(Elm)
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
		MLT.LibTypeId, LTRIM(RTRIM(QL.QuestionLibraryName)), CONVERT(INT,QL.CustomerId), 1 AS IsActive
	FROM #QuestionLibrary QL
	INNER JOIN DBO.MS_LibraryType MLT
		ON LTRIM(RTRIM(QL.LibType)) = LTRIM(RTRIM(MLT.TypeName))
	WHERE LTRIM(RTRIM(QL.QuestionLibraryId)) = 'undefined'

	SET @LibraryId = @@IDENTITY

	SELECT CASE WHEN @LibraryId = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN @LibraryId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark, 
		@LibraryId AS LibraryId

	DROP TABLE #QuestionLibrary

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END


