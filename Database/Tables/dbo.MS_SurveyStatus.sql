USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_SurveyStatus]    Script Date: 07/16/2012 14:58:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_SurveyStatus]') AND type in (N'U'))
DROP TABLE [dbo].[MS_SurveyStatus]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_SurveyStatus]    Script Date: 07/16/2012 14:58:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_SurveyStatus](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyStatusName] [varchar](10) NULL,
 CONSTRAINT [PK_MS_SurveyStatus] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


