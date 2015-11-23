IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteLibrary]
GO

--EXEC UspDeleteLibrary 

CREATE PROCEDURE DBO.UspDeleteLibrary
	@LibraryId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	IF EXISTS(SELECT 1 FROM DBO.TR_LibraryCategory WHERE LibId = @LibraryId)
	BEGIN
		SELECT 1 AS RetValue, 'Library Can Not Deleted' AS Remark
	END
	ELSE
	BEGIN
		DECLARE @LibTypeId INT,
				@TypeName VARCHAR(100)
		SET @LibTypeId = 0
		SET @TypeName = ''
		
		SELECT @LibTypeId = LibTypeId FROM DBO.TR_Library WHERE LibId = @LibraryId
		SELECT @TypeName = TypeName FROM DBO.MS_LibraryType WHERE LibTypeId = @LibTypeId
		
		IF LTRIM(RTRIM(@TypeName)) = 'MESSAGE'
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_MessageLibrary WHERE LibId = @LibraryId)
			BEGIN
				SELECT 1 AS RetValue, 'Library Can Not Deleted' AS Remark
			END
			ELSE
			BEGIN
				DELETE FROM DBO.TR_Library WHERE LibId = @LibraryId 
				SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
			END
		END

		IF LTRIM(RTRIM(@TypeName)) = 'FILE'
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_FileLibrary WHERE LibId = @LibraryId)
			BEGIN
				SELECT 1 AS RetValue, 'Library Can Not Deleted' AS Remark
			END
			ELSE
			BEGIN
				DELETE FROM DBO.TR_Library WHERE LibId = @LibraryId 
				SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
			END
		END

		IF LTRIM(RTRIM(@TypeName)) = 'GRAPHIC'
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_GraphicLibrary WHERE LibId = @LibraryId)
			BEGIN
				SELECT 1 AS RetValue, 'Library Can Not Deleted' AS Remark
			END
			ELSE
			BEGIN
				DELETE FROM DBO.TR_Library WHERE LibId = @LibraryId 
				SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
			END
		END
		
		IF LTRIM(RTRIM(@TypeName)) = 'QUESTION'
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_QuestionLibrary WHERE LibId = @LibraryId)
			BEGIN
				SELECT 1 AS RetValue, 'Library Can Not Deleted' AS Remark
			END
			ELSE
			BEGIN
				DELETE FROM DBO.TR_Library WHERE LibId = @LibraryId 
				SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
			END
		END

		IF LTRIM(RTRIM(@TypeName)) = 'SURVEY'
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_SurveyLibrary WHERE LibId = @LibraryId)
			BEGIN
				SELECT 1 AS RetValue, 'Library Can Not Deleted' AS Remark
			END
			ELSE
			BEGIN
				DELETE FROM DBO.TR_Library WHERE LibId = @LibraryId 
				SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
			END
		END

		IF LTRIM(RTRIM(@TypeName)) = 'PANEL'
		BEGIN
			IF EXISTS(SELECT 1 FROM DBO.TR_PanelCategory WHERE LibId = @LibraryId)
			BEGIN
				SELECT 1 AS RetValue, 'Library Can Not Deleted' AS Remark
			END
			ELSE
			BEGIN
				DELETE FROM DBO.TR_Library WHERE LibId = @LibraryId 
				SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
			END
		END
	END
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

