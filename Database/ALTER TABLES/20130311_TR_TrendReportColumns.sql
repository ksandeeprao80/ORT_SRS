ALTER TABLE DBO.TR_TrendReportColumns ADD TrendType VARCHAR(10)
ALTER TABLE DBO.TR_TrendCrossTabs ADD TrendType VARCHAR(10)
GO
UPDATE DBO.TR_TrendReportColumns SET TrendType = 'False'

UPDATE DBO.TR_TrendCrossTabs 
SET TrendType = CASE WHEN MTBText IN('Just OK','Like it','Love it') THEN 'true' else 'false' END

GO
ALTER TABLE DBO.TR_TrendCrossTabs ADD MtbOptionId INT

--SELECT TTCT.MtbOptionId, TTRC.TRId 
UPDATE TTCT
SET TTCT.MtbOptionId = TTRC.TRId
FROM TR_TrendCrossTabs TTCT
INNER JOIN TR_TrendReportColumns TTRC
ON TTCT.ReportId = TTRC.ReportId
AND LTRIM(RTRIM(TTCT.MTBText)) = LTRIM(RTRIM(TTRC.ColumnName))

