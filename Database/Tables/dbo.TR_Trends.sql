IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Trends_TR_Report]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Trends]'))
ALTER TABLE [dbo].[TR_Trends] DROP CONSTRAINT [FK_TR_Trends_TR_Report]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Trends_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Trends]'))
ALTER TABLE [dbo].[TR_Trends] DROP CONSTRAINT [FK_TR_Trends_TR_Survey]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Trends_TR_Survey1]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Trends]'))
ALTER TABLE [dbo].[TR_Trends] DROP CONSTRAINT [FK_TR_Trends_TR_Survey1]
GO

/****** Object:  Table [dbo].[TR_Trends]    Script Date: 01/07/2013 16:17:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Trends]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Trends]
GO

/****** Object:  Table [dbo].[TR_Trends]    Script Date: 01/07/2013 16:17:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Trends](
	[TrendId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[SurveyId] [int] NOT NULL,
	[BaseSurveyId] [int] NULL,
	[StatusId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[SurveyName] [varchar](50) NULL,
	[BaseSurveyName] [varchar](50) NULL,
	[IsBaseSurvey] [varchar](10) NULL,
	[IsCompareSurvey] [varchar](10) NULL,
 CONSTRAINT [PK_TR_Trends] PRIMARY KEY CLUSTERED 
(
	[TrendId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_Trends]  WITH CHECK ADD  CONSTRAINT [FK_TR_Trends_TR_Report] FOREIGN KEY([ReportId])
REFERENCES [dbo].[TR_Report] ([ReportId])
GO

ALTER TABLE [dbo].[TR_Trends] CHECK CONSTRAINT [FK_TR_Trends_TR_Report]
GO

ALTER TABLE [dbo].[TR_Trends]  WITH CHECK ADD  CONSTRAINT [FK_TR_Trends_TR_Survey] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[TR_Trends] CHECK CONSTRAINT [FK_TR_Trends_TR_Survey]
GO

ALTER TABLE [dbo].[TR_Trends]  WITH CHECK ADD  CONSTRAINT [FK_TR_Trends_TR_Survey1] FOREIGN KEY([BaseSurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[TR_Trends] CHECK CONSTRAINT [FK_TR_Trends_TR_Survey1]
GO


