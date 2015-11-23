IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_MenuRoleAccess_MS_MenuAccess]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_MenuRoleAccess]'))
ALTER TABLE [dbo].[MS_MenuRoleAccess] DROP CONSTRAINT [FK_MS_MenuRoleAccess_MS_MenuAccess]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_MenuRoleAccess_MS_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_MenuRoleAccess]'))
ALTER TABLE [dbo].[MS_MenuRoleAccess] DROP CONSTRAINT [FK_MS_MenuRoleAccess_MS_Roles]
GO

/****** Object:  Table [dbo].[MS_MenuRoleAccess]    Script Date: 03/19/2013 12:38:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_MenuRoleAccess]') AND type in (N'U'))
DROP TABLE [dbo].[MS_MenuRoleAccess]
GO

/****** Object:  Table [dbo].[MS_MenuRoleAccess]    Script Date: 03/19/2013 12:38:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_MenuRoleAccess](
	[MenuId] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[ModuleId] [int] NOT NULL,
	[AccessStatus] [varchar](5) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MenuId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MS_MenuRoleAccess]  WITH CHECK ADD  CONSTRAINT [FK_MS_MenuRoleAccess_MS_MenuAccess] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[MS_MenuAccess] ([ModuleId])
GO

ALTER TABLE [dbo].[MS_MenuRoleAccess] CHECK CONSTRAINT [FK_MS_MenuRoleAccess_MS_MenuAccess]
GO

ALTER TABLE [dbo].[MS_MenuRoleAccess]  WITH CHECK ADD  CONSTRAINT [FK_MS_MenuRoleAccess_MS_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[MS_Roles] ([RoleId])
GO

ALTER TABLE [dbo].[MS_MenuRoleAccess] CHECK CONSTRAINT [FK_MS_MenuRoleAccess_MS_Roles]
GO


