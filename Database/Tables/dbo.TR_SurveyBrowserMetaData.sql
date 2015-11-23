/****** Object:  Table [dbo].[TR_SurveyBrowserMetaData]    Script Date: 10/26/2012 16:04:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SurveyBrowserMetaData]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SurveyBrowserMetaData]
GO

/****** Object:  Table [dbo].[TR_SurveyBrowserMetaData]    Script Date: 10/26/2012 16:04:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SurveyBrowserMetaData](
	[MetaDataId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [VARCHAR](20),
	[RespondentId] [VARCHAR](20),
	[RespondentSessionId] [VARCHAR](100),
	[IpAddress] [varchar](100) NULL,
	[Browser] [varchar](100) NULL,
	[BrowserVersion] [varchar](20) NULL,
	[OperatingSystem] [varchar](100) NULL,
	[ScreenResolution] [varchar](100) NULL,
	[FlashVersion] [varchar](100) NULL,
	[JavaSupport] [varchar](20) NULL,
	[SupportCookies] [varchar](100) NULL,
	[UserAgent] [varchar](max) NULL,
 CONSTRAINT [PK_TR_SurveyBrowserMetaData] PRIMARY KEY CLUSTERED 
(
	[MetaDataId] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


