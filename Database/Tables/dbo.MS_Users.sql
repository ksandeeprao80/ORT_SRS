IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_Users_MS_Customers]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_Users]'))
ALTER TABLE [dbo].[MS_Users] DROP CONSTRAINT [FK_MS_Users_MS_Customers]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MS_Users_CreatedOn]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MS_Users] DROP CONSTRAINT [DF_MS_Users_CreatedOn]
END

GO

/****** Object:  Table [dbo].[MS_Users]    Script Date: 08/10/2012 13:16:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_Users]') AND type in (N'U'))
DROP TABLE [dbo].[MS_Users]
GO

/****** Object:  Table [dbo].[MS_Users]    Script Date: 08/10/2012 13:16:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[LoginId] [varchar](30) NULL,
	[UserCode] [varchar](20) NULL,
	[UserName] [varchar](50) NOT NULL,
	[UserPassword] [varchar](100) NULL,
	[CustomerId] [int] NULL,
	[EmailId] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[UserType] [varchar](5) NULL,
	[LangauageName] [varchar](50) NULL,
	[TimeZone] [varchar](150) NULL,
	[Phone1] [varchar](20) NULL,
	[Phone2] [varchar](20) NULL,
	[Phone3] [varchar](20) NULL,
	[Department] [varchar](150) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_MS_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MS_Users]  WITH CHECK ADD  CONSTRAINT [FK_MS_Users_MS_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MS_Customers] ([CustomerId])
GO

ALTER TABLE [dbo].[MS_Users] CHECK CONSTRAINT [FK_MS_Users_MS_Customers]
GO

ALTER TABLE [dbo].[MS_Users] ADD  CONSTRAINT [DF_MS_Users_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO


