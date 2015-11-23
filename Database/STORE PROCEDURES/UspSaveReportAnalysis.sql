IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveReportAnalysis]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveReportAnalysis]

GO

-- EXEC UspSaveReportAnalysis '0oxngpvc3o1zxo55xfzbk355'

CREATE PROCEDURE DBO.UspSaveReportAnalysis
	@SessionId VARCHAR(100)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @RowId INT
	SET @RowId = 0
 	DECLARE @Collate VARCHAR(2000)
	SET @Collate = ''
	
	SELECT 
		@Collate = COALESCE(@Collate+'~','')+CASE WHEN ISNULL(CONVERT(VARCHAR(12),AnswerId),'0') = '0' THEN AnswerText ELSE CONVERT(VARCHAR(12),AnswerId) END
	FROM TR_Responses WHERE SessionId = @SessionId AND ISNULL(SongId,0) = 0 

	SET @Collate = @Collate+'~'

	INSERT INTO DBO.TR_ReportAnalysis
	(SurveyId, SongId, AnswerId, MediaAnswer, SessionId, CreatedOn)
	SELECT 
		TSQ.SurveyId, TR.SongId, @Collate, AnswerId AS MediaAnswer, @SessionId, GETDATE() 
	FROM TR_Responses TR
	INNER JOIN TR_SurveyQuestions TSQ ON TR.QuestionId = TSQ.QuestionId 
		AND TR.Status = 'C' AND TR.SessionId = @SessionId --AND ISNULL(TR.SongId,0) <> 0 

	SET @RowId = @@ROWCOUNT
	
	SELECT CASE WHEN ISNULL(@RowId,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN ISNULL(@RowId,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END