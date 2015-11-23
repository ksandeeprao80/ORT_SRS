USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Message_Library_MS_Message_Type]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_MessageLibrary]'))
ALTER TABLE [dbo].[TR_MessageLibrary] DROP CONSTRAINT [FK_TR_Message_Library_MS_Message_Type]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Message_Library_TR_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_MessageLibrary]'))
ALTER TABLE [dbo].[TR_MessageLibrary] DROP CONSTRAINT [FK_TR_Message_Library_TR_Library]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_MessageLibrary]    Script Date: 07/16/2012 15:09:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_MessageLibrary]') AND type in (N'U'))
DROP TABLE [dbo].[TR_MessageLibrary]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_MessageLibrary]    Script Date: 07/16/2012 15:09:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_MessageLibrary](
	[MessageLibId] [int] IDENTITY(1,1) NOT NULL,
	[LibId] [int] NOT NULL,
	[MessageTypeId] [int] NOT NULL,
	[MessageDescription] [varchar](150) NULL,
	[MessageText] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_TR_Message_Library] PRIMARY KEY CLUSTERED 
(
	[MessageLibId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_MessageLibrary]  WITH CHECK ADD  CONSTRAINT [FK_TR_Message_Library_MS_Message_Type] FOREIGN KEY([MessageTypeId])
REFERENCES [dbo].[MS_MessageType] ([MessageTypeId])
GO

ALTER TABLE [dbo].[TR_MessageLibrary] CHECK CONSTRAINT [FK_TR_Message_Library_MS_Message_Type]
GO

ALTER TABLE [dbo].[TR_MessageLibrary]  WITH CHECK ADD  CONSTRAINT [FK_TR_Message_Library_TR_Library] FOREIGN KEY([LibId])
REFERENCES [dbo].[TR_Library] ([LibId])
GO

ALTER TABLE [dbo].[TR_MessageLibrary] CHECK CONSTRAINT [FK_TR_Message_Library_TR_Library]
GO


