SET IDENTITY_INSERT MS_GeneralMaster ON
INSERT INTO MS_GeneralMaster
(RowId, GeneralDescription, TrailDays, CreatedDate)
SELECT 1,'Job on Table TR_ReportAnalysis to archive data in archive table Trail_ReportAnalysis after trail days mentioned',90,GETDATE()
SET IDENTITY_INSERT MS_GeneralMaster OFF
 