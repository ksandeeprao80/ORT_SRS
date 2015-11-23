/****** Object:  Table [dbo].[PB_TR_QuestionSettings]    Script Date: 11/27/2012 15:10:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_QuestionSettings]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_QuestionSettings]
GO

/****** Object:  Table [dbo].[PB_TR_QuestionSettings]    Script Date: 11/27/2012 15:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_QuestionSettings](
	[QuestionId] [int] NOT NULL,
	[SettingId] [int] NOT NULL,
	[Value] [varchar](1000) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


