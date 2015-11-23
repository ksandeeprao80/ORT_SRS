UPDATE A
SET A.IsCalculated = 1
FROM TR_TrendCrossTabs A
INNER JOIN TR_TrendReportColumns B
ON A.ReportId = B.ReportId
AND LTRIM(RTRIM(A.MTBText)) = LTRIM(RTRIM(B.ColumnName))