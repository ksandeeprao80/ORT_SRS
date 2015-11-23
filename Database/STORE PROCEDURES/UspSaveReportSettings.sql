IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveReportSettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveReportSettings]
GO
/*
EXEC UspSaveReportSettings @ReportId='12119',@XmlData='<?xml version="1.0" encoding="utf-16"?>
<ArrayOfSetting>
  <Setting>
	<SettingId></SettingId>
    <SettingName>HasSkipLogic</SettingName>
    <Value>True</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
	<SettingId></SettingId>
    <SettingName>ReportTagId</SettingName>
    <Value>2</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
	<SettingId></SettingId>
    <SettingName>HasImage</SettingName>
    <Value>False</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
</ArrayOfSetting>'
*/
CREATE PROCEDURE DBO.UspSaveReportSettings
	@ReportId AS INT,
	@TabType VARCHAR(50),
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	 
	CREATE TABLE #ReportSettings
	(SettingName VARCHAR(50), Value VARCHAR(1000), IsAassigned VARCHAR(20))
	INSERT INTO #ReportSettings
	(SettingName, Value, IsAassigned)
	SELECT 
		Child.Elm.value('(SettingName)[1]','VARCHAR(50)') AS SettingName,
		Child.Elm.value('(Value)[1]','VARCHAR(1000)') AS Value,
		Child.Elm.value('(IsAassigned)[1]','VARCHAR(20)') AS IsAassigned
	FROM @input.nodes('/ArrayOfSetting') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Setting') AS Child(Elm)
	
	DELETE FROM DBO.TR_ReportSettings WHERE ReportId = @ReportId and TabType = @TabType
	
	DECLARE @Row INT
	SET @Row = 0
	
	INSERT INTO DBO.TR_ReportSettings
	(ReportId, SettingId, Value,TabType)
	SELECT 
		@ReportId, MRS.SettingId, RS.Value,@TabType
	FROM #ReportSettings RS
	INNER JOIN DBO.MS_ReportSettings MRS
		ON LTRIM(RTRIM(RS.SettingName)) = LTRIM(RTRIM(MRS.SettingName))
		
	SET @Row = @@ROWCOUNT

	SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
		
	DROP TABLE #ReportSettings
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
