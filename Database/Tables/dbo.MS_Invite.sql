IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_Invite_MS_InviteTypes]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_Invite]'))
ALTER TABLE [dbo].[MS_Invite] DROP CONSTRAINT [FK_MS_Invite_MS_InviteTypes]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_Invite_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_Invite]'))
ALTER TABLE [dbo].[MS_Invite] DROP CONSTRAINT [FK_MS_Invite_TR_Survey]
GO

/****** Object:  Table [dbo].[MS_Invite]    Script Date: 10/25/2012 18:36:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_Invite]') AND type in (N'U'))
DROP TABLE [dbo].[MS_Invite]
GO

/****** Object:  Table [dbo].[MS_Invite]    Script Date: 10/25/2012 18:36:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_Invite](
	[InviteId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [int] NOT NULL,
	[InviteType] [int] NOT NULL,
	[InvitePassword] [varchar](100) NULL,
	[ToBeSentDate] [datetime] NULL,
	[ExternalPanelEmailId] [varchar](100) NULL,
	[InternalPanelId] [int] NULL,
 CONSTRAINT [PK_MS_Invite] PRIMARY KEY CLUSTERED 
(
	[InviteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MS_Invite]  WITH CHECK ADD  CONSTRAINT [FK_MS_Invite_MS_InviteTypes] FOREIGN KEY([InviteType])
REFERENCES [dbo].[MS_InviteTypes] ([InviteType])
GO

ALTER TABLE [dbo].[MS_Invite] CHECK CONSTRAINT [FK_MS_Invite_MS_InviteTypes]
GO

ALTER TABLE [dbo].[MS_Invite]  WITH CHECK ADD  CONSTRAINT [FK_MS_Invite_TR_Survey] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[MS_Invite] CHECK CONSTRAINT [FK_MS_Invite_TR_Survey]
GO


