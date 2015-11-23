IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_PlayList_MS_PlayList]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_PlayList]'))
ALTER TABLE [dbo].[TR_PlayList] DROP CONSTRAINT [FK_TR_PlayList_MS_PlayList]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_PlayList_TR_FileLibrary]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_PlayList]'))
ALTER TABLE [dbo].[TR_PlayList] DROP CONSTRAINT [FK_TR_PlayList_TR_FileLibrary]
GO

/****** Object:  Table [dbo].[TR_PlayList]    Script Date: 10/03/2012 11:43:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_PlayList]') AND type in (N'U'))
DROP TABLE [dbo].[TR_PlayList]
GO

/****** Object:  Table [dbo].[TR_PlayList]    Script Date: 10/03/2012 11:43:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_PlayList](
	[PlayListId] [int] NULL,
	[FileLibId] [int] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TR_PlayList]  WITH CHECK ADD  CONSTRAINT [FK_TR_PlayList_MS_PlayList] FOREIGN KEY([PlayListId])
REFERENCES [dbo].[MS_PlayList] ([PlayListId])
GO

ALTER TABLE [dbo].[TR_PlayList] CHECK CONSTRAINT [FK_TR_PlayList_MS_PlayList]
GO

ALTER TABLE [dbo].[TR_PlayList]  WITH CHECK ADD  CONSTRAINT [FK_TR_PlayList_TR_FileLibrary] FOREIGN KEY([FileLibId])
REFERENCES [dbo].[TR_FileLibrary] ([FileLibId])
GO

ALTER TABLE [dbo].[TR_PlayList] CHECK CONSTRAINT [FK_TR_PlayList_TR_FileLibrary]
GO


