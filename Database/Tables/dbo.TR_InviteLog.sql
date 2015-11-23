/****** Object:  Table [dbo].[TR_InviteLog]    Script Date: 01/08/2013 14:59:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_InviteLog]') AND type in (N'U'))
DROP TABLE [dbo].[TR_InviteLog]
GO

/****** Object:  Table [dbo].[TR_InviteLog]    Script Date: 01/08/2013 14:59:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_InviteLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[InviteId] [int] NULL,
	[SurveyId] [int] NULL,
	[InternalPanelId] [int] NULL,
	[PanelMemberId] [int] NULL,
	[PanelMemberEmailId] [varchar](50) NULL,
	[InviteSubject] [varchar](100) NULL,
	[InviteMessage] [varchar](max) NULL,
	[RowId] [int] NULL,
	[SentDate] [datetime] NULL,
	[IsSuccess] [char](1) NULL,
	[ErrorMessage] [varchar](500) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


