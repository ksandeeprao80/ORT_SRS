USE [ORT_SRS_PROD]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Graphic_Library_TR_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_GraphicLibrary]'))
ALTER TABLE [dbo].[TR_GraphicLibrary] DROP CONSTRAINT [FK_TR_Graphic_Library_TR_Library]
GO

USE [ORT_SRS_PROD]
GO

/****** Object:  Table [dbo].[TR_GraphicLibrary]    Script Date: 08/07/2012 15:55:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_GraphicLibrary]') AND type in (N'U'))
DROP TABLE [dbo].[TR_GraphicLibrary]
GO

USE [ORT_SRS_PROD]
GO

/****** Object:  Table [dbo].[TR_GraphicLibrary]    Script Date: 08/07/2012 15:55:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_GraphicLibrary](
	[GraphicLibId] [int] IDENTITY(1,1) NOT NULL,
	[LibId] [int] NOT NULL,
	[GraphicLibName] [varchar](150) NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_TR_Graphic_Library] PRIMARY KEY CLUSTERED 
(
	[GraphicLibId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_TR_GraphicLibrary] UNIQUE NONCLUSTERED 
(
	[LibId] ASC,
	[GraphicLibName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_GraphicLibrary]  WITH CHECK ADD  CONSTRAINT [FK_TR_Graphic_Library_TR_Library] FOREIGN KEY([LibId])
REFERENCES [dbo].[TR_Library] ([LibId])
GO

ALTER TABLE [dbo].[TR_GraphicLibrary] CHECK CONSTRAINT [FK_TR_Graphic_Library_TR_Library]
GO


