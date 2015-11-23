/****** Object:  Table [dbo].[MS_RoleAccess]    Script Date: 07/27/2012 18:32:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_RoleAccess]') AND type in (N'U'))
DROP TABLE [dbo].[MS_RoleAccess]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_RoleAccess]    Script Date: 07/27/2012 18:32:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_RoleAccess](
	[RoleId] [int] NULL,
	[RoleType] [varchar](5) NULL,
	[AccessId] [int] NULL,
	[AccessModule] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


