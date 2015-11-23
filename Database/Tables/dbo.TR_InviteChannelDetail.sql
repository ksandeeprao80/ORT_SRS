IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_InviteChannelDetail_MS_Invite]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_InviteChannelDetail]'))
ALTER TABLE [dbo].[TR_InviteChannelDetail] DROP CONSTRAINT [FK_TR_InviteChannelDetail_MS_Invite]
GO

/****** Object:  Table [dbo].[TR_InviteChannelDetail]    Script Date: 01/09/2013 18:53:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_InviteChannelDetail]') AND type in (N'U'))
DROP TABLE [dbo].[TR_InviteChannelDetail]
GO

/****** Object:  Table [dbo].[TR_InviteChannelDetail]    Script Date: 01/09/2013 18:53:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_InviteChannelDetail](
	[InviteId] [int] NOT NULL,
	[InviteTitle] [varchar](100) NULL NULL,
	[InviteDescription] [varchar](MAX) NULL NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_InviteChannelDetail]  WITH CHECK ADD  CONSTRAINT [FK_TR_InviteChannelDetail_MS_Invite] FOREIGN KEY([InviteId])
REFERENCES [dbo].[MS_Invite] ([InviteId])
GO

ALTER TABLE [dbo].[TR_InviteChannelDetail] CHECK CONSTRAINT [FK_TR_InviteChannelDetail_MS_Invite]
GO


