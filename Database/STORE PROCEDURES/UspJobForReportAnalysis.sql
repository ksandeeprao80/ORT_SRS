IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspJobForReportAnalysis]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspJobForReportAnalysis]

GO
CREATE PROCEDURE DBO.UspJobForReportAnalysis 
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @Days INT
	SELECT @Days = TrailDays FROM MS_GeneralMaster WHERE RowId = 1

	INSERT INTO DBO.Trail_ReportAnalysis
	(SurveyId, SongId, AnswerId, MediaAnswer, SessionId, CreatedOn)
	SELECT  
		SurveyId, SongId, AnswerId, MediaAnswer, SessionId, CreatedOn
	FROM dbo.TR_ReportAnalysis 
	WHERE CONVERT(VARCHAR(10),CreatedOn,112) <= CONVERT(VARCHAR(10),GETDATE()-@Days,112)

	DELETE FROM dbo.TR_ReportAnalysis	
	WHERE CONVERT(VARCHAR(10),CreatedOn,112) <= CONVERT(VARCHAR(10),GETDATE()-@Days,112)
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END	

 