/****** Object:  Table [dbo].[PB_TR_SurveyQuota]    Script Date: 11/27/2012 15:11:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_SurveyQuota]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_SurveyQuota]
GO


/****** Object:  Table [dbo].[PB_TR_SurveyQuota]    Script Date: 11/27/2012 15:11:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_SurveyQuota](
	[SurveyId] [int] NOT NULL,
	[QuotaId] [int] NOT NULL,
	[Limit] [char](10) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


