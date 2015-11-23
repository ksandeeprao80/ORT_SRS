IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptSaveReport]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptSaveReport]

GO
-- EXEC UspRptSaveReport 'Johnny Test', 1168, 1, 5 

CREATE PROCEDURE DBO.UspRptSaveReport
	@ReportName VARCHAR(100),
	@SurveyId INT,
	@CustomerId INT,
	@UserId INT,
	@ReportType CHAR(1)	  
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @ReportId INT
	SET @ReportId = 0
	
	INSERT INTO DBO.TR_Report
	(ReportName, CustomerId, CreatedBy, CreatedOn,IsActive, ReportType)
	VALUES
	(@ReportName, @CustomerId, @UserId, GETDATE(), CASE WHEN @ReportType = 'T' THEN 0 ELSE 1 END, ISNULL(@ReportType,'P'))
	
	SET @ReportId = @@IDENTITY
	
	DECLARE @RDSId INT
	SET @RDSId = 0
		
	INSERT INTO DBO.TR_ReportDataSource
	(ReportId, SurveyId, SurveyName)
	VALUES
	(@ReportId, @SurveyId, NULL)
	
	SET @RDSId = @@IDENTITY
		
	CREATE TABLE #NotAllowedQuestions (QuestionId INT)
	
	INSERT INTO #NotAllowedQuestions (QuestionId)
	SELECT TSQ.QuestionId FROM DBO.TR_SurveyQuestions TSQ
	INNER JOIN DBO.TR_QuestionSettings TQS
		ON TSQ.QuestionId = TQS.QuestionId
		AND TSQ.IsDeleted = 1
		AND TSQ.SurveyId = @SurveyId
	INNER JOIN dbo.MS_QuestionSettings MQS   
		ON MQS.SettingId = TQS.SettingId
		AND MQS.SettingName IN('VerfiyDefaultAnswer')
		AND TQS.Value = 'True'
	--WHERE TSQ.SurveyId = @SurveyId
		
	UNION
	
	SELECT TSQ.QuestionId FROM DBO.TR_SurveyQuestions TSQ
	INNER JOIN DBO.TR_QuestionSettings TQS
		ON TSQ.QuestionId = TQS.QuestionId
		AND TSQ.IsDeleted = 1
		AND TSQ.SurveyId = @SurveyId
	INNER JOIN dbo.MS_QuestionSettings MQS   
		ON MQS.SettingId = TQS.SettingId
		AND MQS.SettingName IN('IsMTBQuestion')
		AND TQS.Value = 'True'
	--WHERE TSQ.SurveyId = @SurveyId

	INSERT INTO DBO.TR_ReportQuestions
	(RDSId, ReportId, QuestionId, StatusId, CreatedBy, CreatedOn)	
	SELECT  
		@RDSId, @ReportId, QuestionId, 1, @UserId, GETDATE()
	FROM DBO.TR_SurveyQuestions TSQ
	INNER JOIN DBO.MS_QuestionTypes MQT
		ON TSQ.QuestionTypeId = MQT.QuestionTypeId 
		AND MQT.QuestionTypeId IN (1,2,3,5,6,7,8,9)
		AND TSQ.IsDeleted = 1
		AND TSQ.SurveyId = @SurveyId
	WHERE TSQ.QuestionId NOT IN (SELECT QuestionId FROM #NotAllowedQuestions)
 
	DROP TABLE #NotAllowedQuestions
	
	SELECT 
		CASE WHEN @ReportId = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN @ReportId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
		@ReportId AS ReportId  

 	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END