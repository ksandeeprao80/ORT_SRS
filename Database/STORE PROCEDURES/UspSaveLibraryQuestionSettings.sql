IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveLibraryQuestionSettings]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveLibraryQuestionSettings]
GO
/*
EXEC UspSaveLibraryQuestionSettings @QuestionLibId='16',@XmlData='<?xml version="1.0" encoding="utf-16"?>
<ArrayOfSetting>
  <Setting>
	<SettingId></SettingId>
    <SettingName>HasSkipLogic</SettingName>
    <Value>True</Value>
    <IsAassigned>false</IsAassigned>
  </Setting>
  <Setting>
	<SettingId></SettingId>
    <SettingName>QuestionTagId</SettingName>
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
CREATE PROCEDURE DBO.UspSaveLibraryQuestionSettings
	@QuestionLibId AS INT,
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	 
	CREATE TABLE #QuestionSettings
	(SettingName VARCHAR(50), Value VARCHAR(1000), IsAassigned VARCHAR(20))
	INSERT INTO #QuestionSettings
	(SettingName, Value, IsAassigned)
	SELECT 
		Child.Elm.value('(SettingName)[1]','VARCHAR(50)') AS SettingName,
		Child.Elm.value('(Value)[1]','VARCHAR(1000)') AS Value,
		Child.Elm.value('(IsAassigned)[1]','VARCHAR(20)') AS IsAassigned
	--INTO #QuestionSettings
	FROM @input.nodes('/ArrayOfSetting') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('Setting') AS Child(Elm)
	
	DECLARE @Row INT
	SET @Row = 0
	
	INSERT INTO DBO.TR_QuestionLibrarySetting
	(QuestionLibId, SettingId, Value)
	SELECT 
		@QuestionLibId, MQS.SettingId, QS.Value
	FROM #QuestionSettings QS
	INNER JOIN DBO.MS_QuestionSettings MQS
		ON LTRIM(RTRIM(QS.SettingName)) = LTRIM(RTRIM(MQS.SettingName))
		
	SET @Row = @@ROWCOUNT
			 
	SELECT CASE WHEN @Row = 0 THEN 0 ELSE 1 END AS RetValue, 
		CASE WHEN @Row = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
		
	DROP TABLE #QuestionSettings
		
	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
