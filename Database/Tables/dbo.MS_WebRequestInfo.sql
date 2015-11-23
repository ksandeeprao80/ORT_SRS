/****** Object:  Table [dbo].[MS_WebRequestInfo]    Script Date: 10/26/2012 16:04:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_WebRequestInfo]') AND type in (N'U'))
DROP TABLE [dbo].[MS_WebRequestInfo]
GO

/****** Object:  Table [dbo].[MS_WebRequestInfo]    Script Date: 10/26/2012 16:04:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_WebRequestInfo](
	[RequestId] [int] IDENTITY(1,1) NOT NULL,
	[Controller] [varchar](100) NULL,
	[Action] [varchar](100) NULL,
	[WebFormParams] [varchar](500) NULL,
	[IpAddress] [varchar](100) NULL,
	[BrowserType] [varchar](100) NULL,
	[Browser] [varchar](100) NULL,
	[BrowserVersion] [varchar](20) NULL,
	[ScreenResolution] [varchar](100) NULL,
	[FlashVersion] [varchar](100) NULL,
	[JavaSupport] [varchar](20) NULL,
	[SupportCookies] [varchar](100) NULL,
	[UserAgent] [varchar](max) NULL,
 CONSTRAINT [PK_MS_WebRequestInfo] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


