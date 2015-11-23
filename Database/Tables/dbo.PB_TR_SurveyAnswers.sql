/****** Object:  Table [dbo].[PB_TR_SurveyAnswers]    Script Date: 11/27/2012 15:11:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_SurveyAnswers]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_SurveyAnswers]
GO

/****** Object:  Table [dbo].[PB_TR_SurveyAnswers]    Script Date: 11/27/2012 15:11:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_SurveyAnswers](
	[AnswerId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[Answer] [varchar](1000) NULL,
	[AnswerText] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


