IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_ReportDataSource_TR_Report]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_ReportDataSource]'))
ALTER TABLE [dbo].[TR_ReportDataSource] DROP CONSTRAINT [FK_TR_ReportDataSource_TR_Report]
GO

/****** Object:  Table [dbo].[TR_ReportDataSource]    Script Date: 12/26/2012 16:43:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_ReportDataSource]') AND type in (N'U'))
DROP TABLE [dbo].[TR_ReportDataSource]
GO

/****** Object:  Table [dbo].[TR_ReportDataSource]    Script Date: 12/26/2012 16:43:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_ReportDataSource](
	[RDSId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[SurveyId] [int] NOT NULL,
	[SurveyName] [varchar](50) NULL,
 CONSTRAINT [PK_TR_ReportDataSource] PRIMARY KEY CLUSTERED 
(
	[RDSId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_ReportDataSource]  WITH CHECK ADD  CONSTRAINT [FK_TR_ReportDataSource_TR_Report] FOREIGN KEY([ReportId])
REFERENCES [dbo].[TR_Report] ([ReportId])
GO

ALTER TABLE [dbo].[TR_ReportDataSource] CHECK CONSTRAINT [FK_TR_ReportDataSource_TR_Report]
GO


