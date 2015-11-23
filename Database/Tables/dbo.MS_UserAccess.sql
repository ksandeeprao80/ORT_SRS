USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_UserAccess]    Script Date: 07/16/2012 14:59:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_UserAccess]') AND type in (N'U'))
DROP TABLE [dbo].[MS_UserAccess]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_UserAccess]    Script Date: 07/16/2012 14:59:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_UserAccess](
	[AccessId] [int] IDENTITY(1,1) NOT NULL,
	[AccessName] [varchar](50) NULL,
	[AccessModule] [varchar](50) NULL,
	[AccessLink] [varchar](1000) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_MS_User_Access] PRIMARY KEY CLUSTERED 
(
	[AccessId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


