IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_ReportFilter_MS_ReportFilter]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_ReportFilter]'))
ALTER TABLE [dbo].[TR_ReportFilter] DROP CONSTRAINT [FK_TR_ReportFilter_MS_ReportFilter]
GO

/****** Object:  Table [dbo].[TR_ReportFilter]    Script Date: 02/05/2013 11:01:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_ReportFilter]') AND type in (N'U'))
DROP TABLE [dbo].[TR_ReportFilter]
GO

/****** Object:  Table [dbo].[TR_ReportFilter]    Script Date: 02/05/2013 11:01:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_ReportFilter](
	[FilterId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[Operator] [varchar](30) NOT NULL,
	[AnswerId] [int] NULL,
	[AnswerText] [varchar](30) NULL,
	[FilterOperator] [varchar](10) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_ReportFilter]  WITH CHECK ADD  CONSTRAINT [FK_TR_ReportFilter_MS_ReportFilter] FOREIGN KEY([FilterId])
REFERENCES [dbo].[MS_ReportFilter] ([FilterId])
GO

ALTER TABLE [dbo].[TR_ReportFilter] CHECK CONSTRAINT [FK_TR_ReportFilter_MS_ReportFilter]
GO


