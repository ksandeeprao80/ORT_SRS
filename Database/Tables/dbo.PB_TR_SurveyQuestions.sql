/****** Object:  Table [dbo].[PB_TR_SurveyQuestions]    Script Date: 11/27/2012 15:11:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_SurveyQuestions]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_SurveyQuestions]
GO

/****** Object:  Table [dbo].[PB_TR_SurveyQuestions]    Script Date: 11/27/2012 15:11:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_SurveyQuestions](
	[QuestionId] [int] NOT NULL,
	[SurveyId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[QuestionTypeId] [int] NOT NULL,
	[QuestionText] [varchar](2000) NULL,
	[IsDeleted] [bit] NOT NULL,
	[DefaultAnswerId] [int] NULL,
	[QuestionNo] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


