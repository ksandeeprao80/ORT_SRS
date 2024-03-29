/****** Object:  Table [dbo].[MS_QuestionSettings]    Script Date: 10/16/2012 12:02:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_QuestionSettings]') AND type in (N'U'))
DROP TABLE [dbo].[MS_QuestionSettings]
GO

/****** Object:  Table [dbo].[MS_QuestionSettings]    Script Date: 10/16/2012 12:02:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_QuestionSettings](
	[SettingId] [int] IDENTITY(1,1) NOT NULL,
	[SettingName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MS_QuestionSettings] PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


