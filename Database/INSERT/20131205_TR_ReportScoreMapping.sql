-- SELECT * FROM TR_ReportScoreMapped

INSERT INTO DBO.TR_ReportScoreMapped
(ReportId, ScoreId)
SELECT DISTINCT TT.ReportId, TMA.AnswerId FROM TR_Trends TT
CROSS JOIN DBO.TR_MediaAnswers TMA

INSERT INTO DBO.TR_ReportScoreMapped
(ReportId, ScoreId) 
SELECT DISTINCT ReportId, TRId FROM DBO.TR_TrendReportColumns

