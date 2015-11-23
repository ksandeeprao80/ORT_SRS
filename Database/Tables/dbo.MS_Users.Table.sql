USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[MS_Users]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MS_Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[User_Password] [varchar](100) NULL,
	[Customer_Id] [int] NULL,
	[Is_Active] [bit] NULL,
	[User_Type] [varchar](5) NULL,
 CONSTRAINT [PK_MS_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[MS_Users]  WITH CHECK ADD  CONSTRAINT [FK_MS_Users_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[MS_Users] CHECK CONSTRAINT [FK_MS_Users_MS_Customers]
GO
