INSERT INTO DBO.TR_SongTrendReportColumn
(ReportId,ColumnText,Hidden)
SELECT DISTINCT TR.ReportId, TMA.Answer AS ColumnText, 'False'  AS Hidden FROM TR_MediaAnswers TMA
CROSS JOIN TR_Report TR
UNION
SELECT 
	DISTINCT 
	ReportId, ColumnName AS ColumnText,'False' AS Hidden  
FROM dbo.TR_TrendReportColumns WHERE ISNULL(ColumnName,'') <> ''
UNION
SELECT 
	DISTINCT  
	ReportId, ISNULL(OptionDisplayText,MTBOptionName) AS ColumnText,'False' AS Hidden 
FROM DBO.TR_TrendCrossTabs  WHERE ISNULL(MTBOptionName,'') <> '' 

