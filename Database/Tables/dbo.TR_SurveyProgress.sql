/****** Object:  Table [dbo].[TR_SurveyProgress]    Script Date: 10/23/2012 11:57:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SurveyProgress]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SurveyProgress]
GO

/****** Object:  Table [dbo].[TR_SurveyProgress]    Script Date: 10/23/2012 11:57:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SurveyProgress](
	[ProgressId] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [varchar](100) NULL,
	[QuestionId] [int] NULL,
 CONSTRAINT [PK_TR_SurveyProgress] PRIMARY KEY CLUSTERED 
(
	[ProgressId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


