IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Invite_MS_Invite]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Invite]'))
ALTER TABLE [dbo].[TR_Invite] DROP CONSTRAINT [FK_TR_Invite_MS_Invite]
GO

/****** Object:  Table [dbo].[TR_Invite]    Script Date: 10/25/2012 18:51:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Invite]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Invite]
GO

/****** Object:  Table [dbo].[TR_Invite]    Script Date: 10/25/2012 18:51:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Invite](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[InviteId] [int] NOT NULL,
	[PanelMemberId] [int] NULL,
	[Channel] [varchar](100) NULL,
	[ChannelId] [varchar](50) NULL,
	[SentDate] [datetime] NULL,
 CONSTRAINT [PK_TR_Invite] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_Invite]  WITH CHECK ADD  CONSTRAINT [FK_TR_Invite_MS_Invite] FOREIGN KEY([InviteId])
REFERENCES [dbo].[MS_Invite] ([InviteId])
GO

ALTER TABLE [dbo].[TR_Invite] CHECK CONSTRAINT [FK_TR_Invite_MS_Invite]
GO


