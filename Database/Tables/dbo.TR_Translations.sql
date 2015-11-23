USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Translations_MS_Languages]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Translations]'))
ALTER TABLE [dbo].[TR_Translations] DROP CONSTRAINT [FK_TR_Translations_MS_Languages]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Translations_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Translations]'))
ALTER TABLE [dbo].[TR_Translations] DROP CONSTRAINT [FK_TR_Translations_TR_Survey]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Translations]    Script Date: 07/16/2012 15:29:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Translations]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Translations]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Translations]    Script Date: 07/16/2012 15:29:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Translations](
	[SurveyId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[EntityType] [char](1) NOT NULL,
	[EntityTypeId] [int] NOT NULL,
	[TransText] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_Translations]  WITH CHECK ADD  CONSTRAINT [FK_TR_Translations_MS_Languages] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[MS_Languages] ([LanguageId])
GO

ALTER TABLE [dbo].[TR_Translations] CHECK CONSTRAINT [FK_TR_Translations_MS_Languages]
GO

ALTER TABLE [dbo].[TR_Translations]  WITH CHECK ADD  CONSTRAINT [FK_TR_Translations_TR_Survey] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[TR_Translations] CHECK CONSTRAINT [FK_TR_Translations_TR_Survey]
GO


