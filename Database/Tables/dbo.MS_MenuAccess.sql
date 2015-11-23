/****** Object:  Table [dbo].[MS_MenuAccess]    Script Date: 03/19/2013 14:30:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_MenuAccess]') AND type in (N'U'))
DROP TABLE [dbo].[MS_MenuAccess]
GO

/****** Object:  Table [dbo].[MS_MenuAccess]    Script Date: 03/19/2013 14:30:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_MenuAccess](
	[ModuleId] [int] IDENTITY(1,1) NOT NULL,
	[ModuleName] [varchar](50) NOT NULL,
	[ParentId] [int] NOT NULL,
	[AccessLevel] [int] NOT NULL,
 CONSTRAINT [PK_MS_MenuAccess] PRIMARY KEY CLUSTERED 
(
	[ModuleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


