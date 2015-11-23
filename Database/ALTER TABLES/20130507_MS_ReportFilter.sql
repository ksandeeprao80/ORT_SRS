ALTER TABLE DBO.MS_ReportFilter ADD ReportType CHAR(1)
GO
UPDATE DBO.MS_ReportFilter SET ReportType = 'P'

