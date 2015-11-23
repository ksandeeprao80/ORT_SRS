IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_InviteDetails_TR_Invite]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_InviteDetails]'))
ALTER TABLE [dbo].[TR_InviteDetails] DROP CONSTRAINT [FK_TR_InviteDetails_TR_Invite]
GO

/****** Object:  Table [dbo].[TR_InviteDetails]    Script Date: 01/08/2013 15:00:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_InviteDetails]') AND type in (N'U'))
DROP TABLE [dbo].[TR_InviteDetails]
GO

/****** Object:  Table [dbo].[TR_InviteDetails]    Script Date: 01/08/2013 15:00:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_InviteDetails](
	[RowId] [int] NULL,
	[InviteFrom] [varchar](100) NULL,
	[InviteSubject] [varchar](100) NULL,
	[MessageLibId] [int] NULL,
	[CustomMessage] [varchar](max) NULL,
	[SendReminder] [int] NULL,
	[ReminderMessagLibId] [int] NULL,
	[CustomReminderMessage] [varchar](max) NULL,
	[SentDate] [datetime] NULL,
	[ReminderSentDate] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_InviteDetails]  WITH CHECK ADD  CONSTRAINT [FK_TR_InviteDetails_TR_Invite] FOREIGN KEY([RowId])
REFERENCES [dbo].[TR_Invite] ([RowId])
GO

ALTER TABLE [dbo].[TR_InviteDetails] CHECK CONSTRAINT [FK_TR_InviteDetails_TR_Invite]
GO


