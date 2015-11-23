IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__TR_EmailL__Creat__1018DA14]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TR_EmailLog] DROP CONSTRAINT [DF__TR_EmailL__Creat__1018DA14]
END

GO

/****** Object:  Table [dbo].[TR_EmailLog]    Script Date: 06/27/2013 11:52:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_EmailLog]') AND type in (N'U'))
DROP TABLE [dbo].[TR_EmailLog]
GO

/****** Object:  Table [dbo].[TR_EmailLog]    Script Date: 06/27/2013 11:52:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_EmailLog](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[FromEmailId] [varchar](100) NULL,
	[EmailFromName] [varchar](100) NULL,
	[ToEmailId] [varchar](500) NULL,
	[CcEmailId] [varchar](500) NULL,
	[BccEmailId] [varchar](500) NULL,
	[ReplyTo] [varchar](500) NULL,
	[EmailSubject] [varchar](100) NULL,
	[Attachment] [varchar](100) NULL,
	[EmailBody] [varchar](max) NULL,
	[HostServer] [varchar](100) NULL,
	[HostPort] [varchar](100) NULL,
	[SmtpUser] [varchar](100) NULL,
	[SmtpPassword] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_EmailLog] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO


