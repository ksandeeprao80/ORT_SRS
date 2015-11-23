USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_LibraryType]    Script Date: 07/16/2012 14:52:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_LibraryType]') AND type in (N'U'))
DROP TABLE [dbo].[MS_LibraryType]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_LibraryType]    Script Date: 07/16/2012 14:52:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_LibraryType](
	[LibTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [varchar](100) NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_MS_Library_Type] PRIMARY KEY CLUSTERED 
(
	[LibTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


