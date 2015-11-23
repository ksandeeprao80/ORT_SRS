USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Sound_Clip_Info_TR_File_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SoundClipInfo]'))
ALTER TABLE [dbo].[TR_SoundClipInfo] DROP CONSTRAINT [FK_TR_Sound_Clip_Info_TR_File_Library]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SoundClipInfo]    Script Date: 07/16/2012 15:13:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SoundClipInfo]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SoundClipInfo]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SoundClipInfo]    Script Date: 07/16/2012 15:13:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SoundClipInfo](
	[FileLibId] [int] NOT NULL,
	[Title] [varchar](100) NULL,
	[Artist] [varchar](100) NULL,
	[FileLibYear] [varchar](4) NULL,
	[FilePath] [varchar](1000) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_SoundClipInfo]  WITH CHECK ADD  CONSTRAINT [FK_TR_Sound_Clip_Info_TR_File_Library] FOREIGN KEY([FileLibId])
REFERENCES [dbo].[TR_FileLibrary] ([FileLibId])
GO

ALTER TABLE [dbo].[TR_SoundClipInfo] CHECK CONSTRAINT [FK_TR_Sound_Clip_Info_TR_File_Library]
GO


