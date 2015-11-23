IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_ReportFilterMapping_MS_ReportFilter]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_ReportFilterMapping]'))
ALTER TABLE [dbo].[TR_ReportFilterMapping] DROP CONSTRAINT [FK_TR_ReportFilterMapping_MS_ReportFilter]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_ReportFilterMapping_TR_Report]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_ReportFilterMapping]'))
ALTER TABLE [dbo].[TR_ReportFilterMapping] DROP CONSTRAINT [FK_TR_ReportFilterMapping_TR_Report]
GO

/****** Object:  Table [dbo].[TR_ReportFilterMapping]    Script Date: 02/05/2013 16:01:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_ReportFilterMapping]') AND type in (N'U'))
DROP TABLE [dbo].[TR_ReportFilterMapping]
GO

/****** Object:  Table [dbo].[TR_ReportFilterMapping]    Script Date: 02/05/2013 16:01:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_ReportFilterMapping](
	[ReportId] [int] NOT NULL,
	[FilterId] [int] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TR_ReportFilterMapping]  WITH CHECK ADD  CONSTRAINT [FK_TR_ReportFilterMapping_MS_ReportFilter] FOREIGN KEY([FilterId])
REFERENCES [dbo].[MS_ReportFilter] ([FilterId])
GO

ALTER TABLE [dbo].[TR_ReportFilterMapping] CHECK CONSTRAINT [FK_TR_ReportFilterMapping_MS_ReportFilter]
GO

ALTER TABLE [dbo].[TR_ReportFilterMapping]  WITH CHECK ADD  CONSTRAINT [FK_TR_ReportFilterMapping_TR_Report] FOREIGN KEY([ReportId])
REFERENCES [dbo].[TR_Report] ([ReportId])
GO

ALTER TABLE [dbo].[TR_ReportFilterMapping] CHECK CONSTRAINT [FK_TR_ReportFilterMapping_TR_Report]
GO


