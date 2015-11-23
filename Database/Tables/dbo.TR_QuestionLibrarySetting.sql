IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_QuestionLibrarySetting_TR_QuestionLibrary]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_QuestionLibrarySetting]'))
ALTER TABLE [dbo].[TR_QuestionLibrarySetting] DROP CONSTRAINT [FK_TR_QuestionLibrarySetting_TR_QuestionLibrary]
GO

/****** Object:  Table [dbo].[TR_QuestionLibrarySetting]    Script Date: 01/24/2013 12:37:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_QuestionLibrarySetting]') AND type in (N'U'))
DROP TABLE [dbo].[TR_QuestionLibrarySetting]
GO

/****** Object:  Table [dbo].[TR_QuestionLibrarySetting]    Script Date: 01/24/2013 12:37:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_QuestionLibrarySetting](
	[QuestionLibId] [int] NOT NULL,
	[SettingId] [int] NOT NULL,
	[Value] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_QuestionLibrarySetting]  WITH CHECK ADD  CONSTRAINT [FK_TR_QuestionLibrarySetting_TR_QuestionLibrary] FOREIGN KEY([QuestionLibId])
REFERENCES [dbo].[TR_QuestionLibrary] ([QuestionLibId])
GO

ALTER TABLE [dbo].[TR_QuestionLibrarySetting] CHECK CONSTRAINT [FK_TR_QuestionLibrarySetting_TR_QuestionLibrary]
GO


