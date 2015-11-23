/****** Object:  Table [dbo].[TR_Respondent_PlayList]    Script Date: 10/15/2012 12:23:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Respondent_PlayList]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Respondent_PlayList]
GO

/****** Object:  Table [dbo].[TR_Respondent_PlayList]    Script Date: 10/15/2012 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Respondent_PlayList](
	[SurveyId] [int] NULL,
	[SessionId] [varchar](100) NULL,
	[FileLibId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

