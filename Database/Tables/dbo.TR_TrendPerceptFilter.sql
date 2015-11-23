IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_TrendPerceptFilter_MS_TrendPerceptFilter]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_TrendPerceptFilter]'))
ALTER TABLE [dbo].[TR_TrendPerceptFilter] DROP CONSTRAINT [FK_TR_TrendPerceptFilter_MS_TrendPerceptFilter]
GO

/****** Object:  Table [dbo].[TR_TrendPerceptFilter]    Script Date: 05/23/2013 16:18:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_TrendPerceptFilter]') AND type in (N'U'))
DROP TABLE [dbo].[TR_TrendPerceptFilter]
GO

/****** Object:  Table [dbo].[TR_TrendPerceptFilter]    Script Date: 05/23/2013 16:18:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_TrendPerceptFilter](
	[TPFId] [int] IDENTITY(1,1) NOT NULL,
	[FilterId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[Conjuction] [varchar](20) NULL,
	[AnswerId] [int] NULL,
	[AnswerText] [varchar](150) NULL,
	[Operator] [varchar](30) NULL,
 CONSTRAINT [PK__TR_Trend__66FE7B3742B9687A] PRIMARY KEY CLUSTERED 
(
	[TPFId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_TrendPerceptFilter]  WITH CHECK ADD  CONSTRAINT [FK_TR_TrendPerceptFilter_MS_TrendPerceptFilter] FOREIGN KEY([FilterId])
REFERENCES [dbo].[MS_TrendPerceptFilter] ([FilterId])
GO

ALTER TABLE [dbo].[TR_TrendPerceptFilter] CHECK CONSTRAINT [FK_TR_TrendPerceptFilter_MS_TrendPerceptFilter]
GO


