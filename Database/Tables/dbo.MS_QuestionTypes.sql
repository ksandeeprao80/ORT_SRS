USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_QuestionTypes]    Script Date: 07/16/2012 14:55:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_QuestionTypes]') AND type in (N'U'))
DROP TABLE [dbo].[MS_QuestionTypes]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_QuestionTypes]    Script Date: 07/16/2012 14:55:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_QuestionTypes](
	[QuestionTypeId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionCode] [varchar](100) NOT NULL,
	[QuestionName] [varchar](100) NOT NULL,
	[SampleTemplate] [varchar](100) NOT NULL,
	[BlankTemplate] [varchar](100) NOT NULL,
 CONSTRAINT [PK_MS_QuestionTypes] PRIMARY KEY CLUSTERED 
(
	[QuestionTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


