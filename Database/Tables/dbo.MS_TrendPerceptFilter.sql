IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_TrendPerceptFilter_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_TrendPerceptFilter]'))
ALTER TABLE [dbo].[MS_TrendPerceptFilter] DROP CONSTRAINT [FK_MS_TrendPerceptFilter_TR_Survey]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MS_TrendP__Creat__3EE8D796]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MS_TrendPerceptFilter] DROP CONSTRAINT [DF__MS_TrendP__Creat__3EE8D796]
END

GO

/****** Object:  Table [dbo].[MS_TrendPerceptFilter]    Script Date: 05/23/2013 16:09:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_TrendPerceptFilter]') AND type in (N'U'))
DROP TABLE [dbo].[MS_TrendPerceptFilter]
GO

/****** Object:  Table [dbo].[MS_TrendPerceptFilter]    Script Date: 05/23/2013 16:09:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_TrendPerceptFilter](
	[FilterId] [int] IDENTITY(1,1) NOT NULL,
	[FilterName] [varchar](100) NOT NULL,
	[SurveyId] [int] NOT NULL,
	[ReportId] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FilterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MS_TrendPerceptFilter]  WITH CHECK ADD  CONSTRAINT [FK_MS_TrendPerceptFilter_TR_Survey] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[MS_TrendPerceptFilter] CHECK CONSTRAINT [FK_MS_TrendPerceptFilter_TR_Survey]
GO

ALTER TABLE [dbo].[MS_TrendPerceptFilter] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO


