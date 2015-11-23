/****** Object:  Table [dbo].[TR_SurveySanityCheck]    Script Date: 09/24/2013 10:57:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SurveySanityCheck]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SurveySanityCheck]
GO

/****** Object:  Table [dbo].[TR_SurveySanityCheck]    Script Date: 09/24/2013 10:57:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SurveySanityCheck](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [int] NOT NULL,
	[RespondentId] [int] NOT NULL,
	[SessionId] [varchar](100) NOT NULL,
	[SongId] [int] NOT NULL,
	[PlayListId] [int] NOT NULL,
	[IpAddress] [varchar](100) NULL,
	[Browser] [varchar](100) NULL,
	[BrowserVersion] [varchar](20) NULL,
	[OperatingSystem] [varchar](100) NULL,
	[ScreenResolution] [varchar](100) NULL,
	[FlashVersion] [varchar](100) NULL,
	[JavaSupport] [varchar](20) NULL,
	[SupportCookies] [varchar](100) NULL,
	[UserAgent] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[RowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


