
/****** Object:  Table [dbo].[PB_TR_SurveySettings]    Script Date: 11/27/2012 15:11:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_SurveySettings]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_SurveySettings]
GO

/****** Object:  Table [dbo].[PB_TR_SurveySettings]    Script Date: 11/27/2012 15:11:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_SurveySettings](
	[SurveyId] [int] NOT NULL,
	[SettingId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Value] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


