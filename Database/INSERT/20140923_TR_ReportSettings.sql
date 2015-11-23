INSERT INTO DBO.TR_ReportSettings
(ReportId,SettingId,Value,TabType)
SELECT DISTINCT ReportId,1,'True','TrendRanker' FROM TR_Report WHERE ReportType = 'T'
UNION
SELECT DISTINCT ReportId,2,'False','TrendRanker' FROM TR_Report WHERE ReportType = 'T'
UNION
SELECT DISTINCT ReportId,1,'True','TrendChart' FROM TR_Report WHERE ReportType = 'T'
UNION
SELECT DISTINCT ReportId,2,'False','TrendChart' FROM TR_Report WHERE ReportType = 'T'
UNION
SELECT DISTINCT ReportId,1,'True','TrendOption' FROM TR_Report WHERE ReportType = 'T'
UNION
SELECT DISTINCT ReportId,2,'False','TrendOption' FROM TR_Report WHERE ReportType = 'T'

