USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_User_Access]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TR_User_Access](
	[UserId] [int] NULL,
	[Access_Id] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TR_User_Access]  WITH CHECK ADD  CONSTRAINT [FK_TR_User_Access_MS_User_Access] FOREIGN KEY([Access_Id])
REFERENCES [dbo].[MS_User_Access] ([Access_Id])
GO
ALTER TABLE [dbo].[TR_User_Access] CHECK CONSTRAINT [FK_TR_User_Access_MS_User_Access]
GO
ALTER TABLE [dbo].[TR_User_Access]  WITH CHECK ADD  CONSTRAINT [FK_TR_User_Access_MS_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[MS_Users] ([UserId])
GO
ALTER TABLE [dbo].[TR_User_Access] CHECK CONSTRAINT [FK_TR_User_Access_MS_Users]
GO
