/****** Object:  Table [dbo].[TR_EmailTriggerMailsLog]    Script Date: 06/05/2013 12:11:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_EmailTriggerMailsLog]') AND type in (N'U'))
DROP TABLE [dbo].[TR_EmailTriggerMailsLog]
GO

/****** Object:  Table [dbo].[TR_EmailTriggerMailsLog]    Script Date: 06/05/2013 12:11:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_EmailTriggerMailsLog](
	[TrgId] [int] NULL,
	[ToEmailId] [varchar](100) NULL,
	[ReplyTo] [varchar](100) NULL,
	[MailSubject] [varchar](100) NULL,
	[SentDate] [datetime] NULL,
	[IsSuccess] [char](1) NULL,
	[ErrorMessage] [varchar](500) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


