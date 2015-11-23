IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_GraphicInfo_TR_GraphicLibrary]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_GraphicInfo]'))
ALTER TABLE [dbo].[TR_GraphicInfo] DROP CONSTRAINT [FK_TR_GraphicInfo_TR_GraphicLibrary]
GO

/****** Object:  Table [dbo].[TR_GraphicInfo]    Script Date: 09/27/2012 18:54:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_GraphicInfo]') AND type in (N'U'))
DROP TABLE [dbo].[TR_GraphicInfo]
GO

/****** Object:  Table [dbo].[TR_GraphicInfo]    Script Date: 09/27/2012 18:54:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_GraphicInfo](
	[GraphicLibId] [int] NOT NULL,
	[GraphicFileName] [varchar](150) NULL,
	[FileType] [varchar](50) NULL,
	[RelativePath] [varchar](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_GraphicInfo]  WITH CHECK ADD  CONSTRAINT [FK_TR_GraphicInfo_TR_GraphicLibrary] FOREIGN KEY([GraphicLibId])
REFERENCES [dbo].[TR_GraphicLibrary] ([GraphicLibId])
GO

ALTER TABLE [dbo].[TR_GraphicInfo] CHECK CONSTRAINT [FK_TR_GraphicInfo_TR_GraphicLibrary]
GO


