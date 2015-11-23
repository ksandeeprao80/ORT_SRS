SET IDENTITY_INSERT MS_ReportSettings ON
INSERT INTO DBO.MS_ReportSettings
(SettingId,SettingName)
SELECT 4,'SortColumn'  UNION
SELECT 5,'SortOrder'  
SET IDENTITY_INSERT MS_ReportSettings OFF

GO

INSERT INTO dbo.TR_ReportSettings
(ReportId,SettingId,Value,TabType)
SELECT DISTINCT ReportId,4,'','TrendRanker' FROM TR_ReportSettings UNION
SELECT DISTINCT ReportId,4,'','TrendChart' FROM TR_ReportSettings UNION
SELECT DISTINCT ReportId,4,'','TrendOption' FROM TR_ReportSettings UNION 
SELECT DISTINCT ReportId,5,'','TrendRanker' FROM TR_ReportSettings UNION
SELECT DISTINCT ReportId,5,'','TrendChart' FROM TR_ReportSettings UNION
SELECT DISTINCT ReportId,5,'','TrendOption' FROM TR_ReportSettings


