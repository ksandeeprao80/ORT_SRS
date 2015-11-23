USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Library_MS_Customers]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Library]'))
ALTER TABLE [dbo].[TR_Library] DROP CONSTRAINT [FK_TR_Library_MS_Customers]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Library_MS_Library_Type]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Library]'))
ALTER TABLE [dbo].[TR_Library] DROP CONSTRAINT [FK_TR_Library_MS_Library_Type]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Library]    Script Date: 07/16/2012 15:07:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Library]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Library]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Library]    Script Date: 07/16/2012 15:07:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Library](
	[LibId] [int] IDENTITY(1,1) NOT NULL,
	[LibTypeId] [int] NOT NULL,
	[LibName] [varchar](150) NULL,
	[CustomerId] [int] NULL,
 CONSTRAINT [PK_TR_Library] PRIMARY KEY CLUSTERED 
(
	[LibId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_Library]  WITH CHECK ADD  CONSTRAINT [FK_TR_Library_MS_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MS_Customers] ([CustomerId])
GO

ALTER TABLE [dbo].[TR_Library] CHECK CONSTRAINT [FK_TR_Library_MS_Customers]
GO

ALTER TABLE [dbo].[TR_Library]  WITH CHECK ADD  CONSTRAINT [FK_TR_Library_MS_Library_Type] FOREIGN KEY([LibTypeId])
REFERENCES [dbo].[MS_LibraryType] ([LibTypeId])
GO

ALTER TABLE [dbo].[TR_Library] CHECK CONSTRAINT [FK_TR_Library_MS_Library_Type]
GO


