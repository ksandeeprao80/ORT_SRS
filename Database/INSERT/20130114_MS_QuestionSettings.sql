BEGIN TRAN

DECLARE @AutoAdvance INT
DECLARE @AutoPlay INT
DECLARE @RandomizeTestList INT
DECLARE @TestListRandomNo INT

SET IDENTITY_INSERT MS_QuestionSettings ON
	INSERT INTO dbo.MS_QuestionSettings
	(SettingId, SettingName)
	SELECT 17,'AutoAdvance'
	SET @AutoAdvance = @@IDENTITY
SET IDENTITY_INSERT MS_QuestionSettings OFF

SET IDENTITY_INSERT MS_QuestionSettings ON
	INSERT INTO dbo.MS_QuestionSettings
	(SettingId, SettingName)
	SELECT 18,'AutoPlay'
	SET @AutoPlay = @@IDENTITY
SET IDENTITY_INSERT MS_QuestionSettings OFF

SET IDENTITY_INSERT MS_QuestionSettings ON
	INSERT INTO dbo.MS_QuestionSettings
	(SettingId, SettingName)
	SELECT 19,'RandomizeTestList'
	SET @RandomizeTestList = @@IDENTITY
SET IDENTITY_INSERT MS_QuestionSettings OFF

SET IDENTITY_INSERT MS_QuestionSettings ON
	INSERT INTO dbo.MS_QuestionSettings
	(SettingId, SettingName)
	SELECT 20,'TestListRandomNo'
	SET @TestListRandomNo = @@IDENTITY
SET IDENTITY_INSERT MS_QuestionSettings OFF


INSERT INTO dbo.TR_QuestionSettings
(QuestionId, SettingId, Value)
SELECT DISTINCT QuestionId, @AutoAdvance AS SettingId, 'False' AS Value FROM TR_QuestionSettings
UNION
SELECT DISTINCT QuestionId, @AutoPlay AS SettingId, 'False' AS Value FROM TR_QuestionSettings
UNION
SELECT DISTINCT QuestionId, @RandomizeTestList AS SettingId, 'False' AS Value FROM TR_QuestionSettings
UNION
SELECT DISTINCT QuestionId, @TestListRandomNo AS SettingId, '' AS Value FROM TR_QuestionSettings

COMMIT TRAN
