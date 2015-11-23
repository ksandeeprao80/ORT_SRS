IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_GraphicFiles_TR_GraphicLibrary]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_GraphicFiles]'))
ALTER TABLE [dbo].[TR_GraphicFiles] DROP CONSTRAINT [FK_TR_GraphicFiles_TR_GraphicLibrary]
GO

/****** Object:  Table [dbo].[TR_GraphicFiles]    Script Date: 09/13/2012 15:54:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_GraphicFiles]') AND type in (N'U'))
DROP TABLE [dbo].[TR_GraphicFiles]
GO

/****** Object:  Table [dbo].[TR_GraphicFiles]    Script Date: 09/13/2012 15:54:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_GraphicFiles](
	[GraphicFileId] [int] IDENTITY(1,1) NOT NULL,
	[GraphicLibId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[GraphicFileName] [varchar](100) NULL,
	[Extension] [varchar](20) NULL,
	[FilePath] [varchar](100) NULL,
 CONSTRAINT [PK_TR_GraphicFiles] PRIMARY KEY CLUSTERED 
(
	[GraphicFileId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_GraphicFiles]  WITH CHECK ADD  CONSTRAINT [FK_TR_GraphicFiles_TR_GraphicLibrary] FOREIGN KEY([GraphicLibId])
REFERENCES [dbo].[TR_GraphicLibrary] ([GraphicLibId])
GO

ALTER TABLE [dbo].[TR_GraphicFiles] CHECK CONSTRAINT [FK_TR_GraphicFiles_TR_GraphicLibrary]
GO


