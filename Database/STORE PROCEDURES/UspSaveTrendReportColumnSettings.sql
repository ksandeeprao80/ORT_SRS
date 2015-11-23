IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveTrendReportColumnSettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveTrendReportColumnSettings]

GO
-- UspSaveTrendReportColumnSettings
CREATE PROCEDURE DBO.UspSaveTrendReportColumnSettings
	 @ReportId INT, 
	 @ColumnName VARCHAR(500), 
	 @Setting VARCHAR(500), 
	 @SettingId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @Row INT
	SET @Row = 0
	
	INSERT INTO DBO.TR_TrendReportColumnSettings  
	(ReportId, ColumnName, Setting, SettingId)
	VALUES  
	(@ReportId, @ColumnName, @Setting, @SettingId)
	
	SET @Row = @@ROWCOUNT
		 
	SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
		   CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark 

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
