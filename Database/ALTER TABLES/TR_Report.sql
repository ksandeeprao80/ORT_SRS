ALTER TABLE DBO.TR_Report ADD ReportType CHAR(1) DEFAULT('P') 
GO
UPDATE DBO.TR_Report SET ReportType = 'P'


