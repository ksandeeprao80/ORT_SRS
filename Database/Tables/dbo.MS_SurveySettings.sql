USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_SurveySettings]    Script Date: 07/16/2012 14:57:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_SurveySettings]') AND type in (N'U'))
DROP TABLE [dbo].[MS_SurveySettings]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_SurveySettings]    Script Date: 07/16/2012 14:57:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_SurveySettings](
	[SettingId] [int] IDENTITY(1,1) NOT NULL,
	[SettingType] [varchar](50) NOT NULL,
	[SettingName] [varchar](50) NOT NULL,
	[DisplayText] [varchar](100) NOT NULL,
 CONSTRAINT [PK_MS_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


