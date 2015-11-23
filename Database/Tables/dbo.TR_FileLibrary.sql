USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_File_Library_TR_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_FileLibrary]'))
ALTER TABLE [dbo].[TR_FileLibrary] DROP CONSTRAINT [FK_TR_File_Library_TR_Library]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_FileLibrary]    Script Date: 07/16/2012 15:05:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_FileLibrary]') AND type in (N'U'))
DROP TABLE [dbo].[TR_FileLibrary]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_FileLibrary]    Script Date: 07/16/2012 15:05:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_FileLibrary](
	[FileLibId] [int] IDENTITY(1,1) NOT NULL,
	[LIBID] [int] NOT NULL,
	[FileLibName] [varchar](150) NOT NULL,
	[Category] [varchar](150) NOT NULL,
	[FileName] [varchar](150) NOT NULL,
	[FileType] [varchar](5) NOT NULL,
 CONSTRAINT [PK_TR_File_Library] PRIMARY KEY CLUSTERED 
(
	[FileLibId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_FileLibrary]  WITH CHECK ADD  CONSTRAINT [FK_TR_File_Library_TR_Library] FOREIGN KEY([LIBID])
REFERENCES [dbo].[TR_Library] ([LibId])
GO

ALTER TABLE [dbo].[TR_FileLibrary] CHECK CONSTRAINT [FK_TR_File_Library_TR_Library]
GO


