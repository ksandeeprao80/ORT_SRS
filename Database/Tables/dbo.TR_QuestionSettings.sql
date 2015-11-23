IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_QuestionSettings_MS_QuestionSettings]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_QuestionSettings]'))
ALTER TABLE [dbo].[TR_QuestionSettings] DROP CONSTRAINT [FK_TR_QuestionSettings_MS_QuestionSettings]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_QuestionSettings_TR_SurveyQuestions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_QuestionSettings]'))
ALTER TABLE [dbo].[TR_QuestionSettings] DROP CONSTRAINT [FK_TR_QuestionSettings_TR_SurveyQuestions]
GO

/****** Object:  Table [dbo].[TR_QuestionSettings]    Script Date: 10/16/2012 12:13:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_QuestionSettings]') AND type in (N'U'))
DROP TABLE [dbo].[TR_QuestionSettings]
GO

/****** Object:  Table [dbo].[TR_QuestionSettings]    Script Date: 10/16/2012 12:13:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_QuestionSettings](
	[QuestionId] [int] NOT NULL,
	[SettingId] [int] NOT NULL,
	[Value] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_QuestionSettings]  WITH CHECK ADD  CONSTRAINT [FK_TR_QuestionSettings_MS_QuestionSettings] FOREIGN KEY([SettingId])
REFERENCES [dbo].[MS_QuestionSettings] ([SettingId])
GO

ALTER TABLE [dbo].[TR_QuestionSettings] CHECK CONSTRAINT [FK_TR_QuestionSettings_MS_QuestionSettings]
GO

ALTER TABLE [dbo].[TR_QuestionSettings]  WITH CHECK ADD  CONSTRAINT [FK_TR_QuestionSettings_TR_SurveyQuestions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_QuestionSettings] CHECK CONSTRAINT [FK_TR_QuestionSettings_TR_SurveyQuestions]
GO


