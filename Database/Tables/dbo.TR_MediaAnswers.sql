/****** Object:  Table [dbo].[TR_MediaAnswers]    Script Date: 10/03/2012 11:31:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_MediaAnswers]') AND type in (N'U'))
DROP TABLE [dbo].[TR_MediaAnswers]
GO

/****** Object:  Table [dbo].[TR_MediaAnswers]    Script Date: 10/03/2012 11:31:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_MediaAnswers](
	[AnswerId] [int] NULL,
	[Answer] [varchar](50) NULL,
	[AnswerText] [varchar](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


