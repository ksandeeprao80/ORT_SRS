ALTER TABLE DBO.TR_MediaAnswers ALTER COLUMN Answer NVARCHAR(100) 
ALTER TABLE DBO.TR_MediaAnswers ALTER COLUMN AnswerText NVARCHAR(100) 
 
ALTER TABLE DBO.TR_TrendCrossTabs ALTER COLUMN MTBText NVARCHAR(100) 
ALTER TABLE DBO.TR_TrendCrossTabs ALTER COLUMN MTBOptionName NVARCHAR(150)
ALTER TABLE DBO.TR_TrendCrossTabs ALTER COLUMN BaseOptionName NVARCHAR(150)
ALTER TABLE DBO.TR_TrendCrossTabs ALTER COLUMN OptionDisplayText NVARCHAR(150)

ALTER TABLE DBO.TR_SongTrendReportColumn ALTER COLUMN ColumnText NVARCHAR(150) 

ALTER TABLE DBO.TR_TrendReportColumns ALTER COLUMN ColumnName NVARCHAR(150) 
ALTER TABLE DBO.TR_TrendReportColumns ALTER COLUMN Expression NVARCHAR(500)

ALTER TABLE DBO.TR_TrendOptionMapping ALTER COLUMN OptionName NVARCHAR(150)
ALTER TABLE DBO.TR_TrendOptionMapping ALTER COLUMN BaseOptionName NVARCHAR(150)

ALTER TABLE DBO.MS_TrendPerceptFilter ALTER COLUMN FilterName NVARCHAR(100)

ALTER TABLE DBO.TR_Trends  ALTER COLUMN SurveyName NVARCHAR(50)
ALTER TABLE DBO.TR_Trends  ALTER COLUMN BaseSurveyName NVARCHAR(50)