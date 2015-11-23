USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_CategoryLibrary_TR_GraphicLibrary]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_GraphicCategory]'))
ALTER TABLE [dbo].[TR_GraphicCategory] DROP CONSTRAINT [FK_TR_CategoryLibrary_TR_GraphicLibrary]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_GraphicCategory]    Script Date: 08/06/2012 16:17:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_GraphicCategory]') AND type in (N'U'))
DROP TABLE [dbo].[TR_GraphicCategory]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_GraphicCategory]    Script Date: 08/06/2012 16:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_GraphicCategory](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](150) NOT NULL,
	[GraphicLibId] [int] NOT NULL,
	[FileName] [varchar](150) NULL,
	[FileType] [varchar](10) NULL,
	[UploadedOn] [datetime] NULL,
 CONSTRAINT [PK_TR_CategoryLibrary] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_GraphicCategory]  WITH CHECK ADD  CONSTRAINT [FK_TR_CategoryLibrary_TR_GraphicLibrary] FOREIGN KEY([GraphicLibId])
REFERENCES [dbo].[TR_GraphicLibrary] ([GraphicLibId])
GO

ALTER TABLE [dbo].[TR_GraphicCategory] CHECK CONSTRAINT [FK_TR_CategoryLibrary_TR_GraphicLibrary]
GO


