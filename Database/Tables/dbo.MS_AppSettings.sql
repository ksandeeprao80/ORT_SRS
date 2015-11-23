USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_AppSettings]    Script Date: 07/16/2012 14:48:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_AppSettings]') AND type in (N'U'))
DROP TABLE [dbo].[MS_AppSettings]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_AppSettings]    Script Date: 07/16/2012 14:48:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_AppSettings](
	[SettingId] [int] IDENTITY(1,1) NOT NULL,
	[ParamName] [varchar](50) NULL,
	[ParamValue] [varchar](200) NULL,
	[ParamType] [varchar](50) NULL,
 CONSTRAINT [PK_MS_APP_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


