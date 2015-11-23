--2
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_TrendCrossTabs_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_TrendCrossTabs]'))
ALTER TABLE [dbo].[TR_TrendCrossTabs] DROP CONSTRAINT [FK_TR_TrendCrossTabs_TR_Survey]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_TrendCrossTabs_TR_TrendCrossTabs]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_TrendCrossTabs]'))
ALTER TABLE [dbo].[TR_TrendCrossTabs] DROP CONSTRAINT [FK_TR_TrendCrossTabs_TR_TrendCrossTabs]
GO

/****** Object:  Table [dbo].[TR_TrendCrossTabs]    Script Date: 01/07/2013 10:06:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_TrendCrossTabs]') AND type in (N'U'))
DROP TABLE [dbo].[TR_TrendCrossTabs]
GO

/****** Object:  Table [dbo].[TR_TrendCrossTabs]    Script Date: 01/07/2013 10:06:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_TrendCrossTabs](
	[TCTId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[BaseSurveyId] [int] NOT NULL,
	[BaseOptionId] [int] NULL,
	[MTBId] [int] NULL,
	[MTBText] [varchar](100) NULL,
	[MTBOptionName] [varchar](150) NULL,
	[StatusId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_TR_TrendCrossTabs] PRIMARY KEY CLUSTERED 
(
	[TCTId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_TrendCrossTabs]  WITH CHECK ADD  CONSTRAINT [FK_TR_TrendCrossTabs_TR_Survey] FOREIGN KEY([BaseSurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[TR_TrendCrossTabs] CHECK CONSTRAINT [FK_TR_TrendCrossTabs_TR_Survey]
GO

ALTER TABLE [dbo].[TR_TrendCrossTabs]  WITH CHECK ADD  CONSTRAINT [FK_TR_TrendCrossTabs_TR_TrendCrossTabs] FOREIGN KEY([ReportId])
REFERENCES [dbo].[TR_Report] ([ReportId])
GO

ALTER TABLE [dbo].[TR_TrendCrossTabs] CHECK CONSTRAINT [FK_TR_TrendCrossTabs_TR_TrendCrossTabs]
GO


