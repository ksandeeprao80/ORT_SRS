USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Media_Info_MS_Customers]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_MediaInfo]'))
ALTER TABLE [dbo].[TR_MediaInfo] DROP CONSTRAINT [FK_TR_Media_Info_MS_Customers]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Media_Info_TR_File_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_MediaInfo]'))
ALTER TABLE [dbo].[TR_MediaInfo] DROP CONSTRAINT [FK_TR_Media_Info_TR_File_Library]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Media_Info_TR_Survey_Questions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_MediaInfo]'))
ALTER TABLE [dbo].[TR_MediaInfo] DROP CONSTRAINT [FK_TR_Media_Info_TR_Survey_Questions]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_MediaInfo]    Script Date: 07/31/2012 14:39:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_MediaInfo]') AND type in (N'U'))
DROP TABLE [dbo].[TR_MediaInfo]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_MediaInfo]    Script Date: 07/31/2012 14:39:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_MediaInfo](
	[QuestionId] [int] NOT NULL,
	[FileLibId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Randomize] [bit] NULL,
	[AutoAdvance] [bit] NULL,
	[ShowTitle] [bit] NULL,
	[Autoplay] [bit] NULL,
	[HideForSeconds] [int] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TR_MediaInfo]  WITH CHECK ADD  CONSTRAINT [FK_TR_Media_Info_MS_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MS_Customers] ([CustomerId])
GO

ALTER TABLE [dbo].[TR_MediaInfo] CHECK CONSTRAINT [FK_TR_Media_Info_MS_Customers]
GO

ALTER TABLE [dbo].[TR_MediaInfo]  WITH CHECK ADD  CONSTRAINT [FK_TR_Media_Info_TR_File_Library] FOREIGN KEY([FileLibId])
REFERENCES [dbo].[TR_FileLibrary] ([FileLibId])
GO

ALTER TABLE [dbo].[TR_MediaInfo] CHECK CONSTRAINT [FK_TR_Media_Info_TR_File_Library]
GO

ALTER TABLE [dbo].[TR_MediaInfo]  WITH CHECK ADD  CONSTRAINT [FK_TR_Media_Info_TR_Survey_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_MediaInfo] CHECK CONSTRAINT [FK_TR_Media_Info_TR_Survey_Questions]
GO


