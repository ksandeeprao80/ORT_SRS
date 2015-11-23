IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteLibraryAnswers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteLibraryAnswers]
GO

-- EXEC UspDeleteLibraryAnswers 12163

CREATE PROCEDURE DBO.UspDeleteLibraryAnswers
	@QuestionLibId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @RowId INT
	SET @RowId = 0
	
	IF EXISTS(SELECT 1 FROM DBO.TR_QuestionLibraryAnswers WHERE QuestionLibId = @QuestionLibId)
	BEGIN
		DELETE FROM DBO.TR_QuestionLibraryAnswers WHERE QuestionLibId = @QuestionLibId
	
		SET @RowId = @@ROWCOUNT
		SELECT 
				CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
				CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Delete Failed' ELSE 'Successfully Deleted' END AS Remark
	END
	ELSE
	BEGIN
		SELECT 1 AS RetValue, 'No data found' AS Remark
	END	 

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
