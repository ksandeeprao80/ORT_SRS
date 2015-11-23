IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTransReportSettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetTransReportSettings

GO

-- EXEC UspGetTransReportSettings NULL,1090

CREATE PROCEDURE DBO.UspGetTransReportSettings
	@SettingId INT = NULL,
	@ReportId INT = NULL,
	@TabType VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		ISNULL(TRS.ReportId,'') AS ReportId, MRS.SettingId, 
		LTRIM(RTRIM(ISNULL(MRS.SettingName,''))) AS SettingName, 
		LTRIM(RTRIM(ISNULL(TRS.Value,''))) AS Value
	FROM DBO.MS_ReportSettings MRS
	LEFT OUTER JOIN 
	(
		SELECT * FROM DBO.TR_ReportSettings  
		WHERE SettingId = ISNULL(@SettingId,SettingId)
			AND ReportId = ISNULL(@ReportId,ReportId)
			AND TabType = @TabType
	) TRS
		ON MRS.SettingId = TRS.SettingId
	ORDER BY SettingId ASC

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END