/****** Object:  Table [dbo].[TR_EmailTriggerMails]    Script Date: 06/04/2013 16:28:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_EmailTriggerMails]') AND type in (N'U'))
DROP TABLE [dbo].[TR_EmailTriggerMails]
GO

/****** Object:  Table [dbo].[TR_EmailTriggerMails]    Script Date: 06/04/2013 16:28:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_EmailTriggerMails](
	[TRG_Id] [int] IDENTITY(1,1) NOT NULL,
	[ToEmailId] [varchar](100) NOT NULL,
	[QuestionId] [int] NOT NULL,
	[AnswerId] [varchar](100) NULL,
	[AnswerType] [varchar](5) NULL,
	[SentDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TRG_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


