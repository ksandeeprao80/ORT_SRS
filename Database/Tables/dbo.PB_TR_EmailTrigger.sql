/****** Object:  Table [dbo].[PB_TR_EmailTrigger]    Script Date: 01/30/2013 12:57:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_EmailTrigger]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_EmailTrigger]
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_EmailTrigger](
	[QuestionId] [int] NOT NULL,
	[TriggerExpression] [varchar](150) NOT NULL,
	[TrueAction] [varchar](250) NOT NULL,
	[FalseAction] [varchar](250) NULL,
	[SendAtEnd] [bit] NULL,
	[MessageLibId] [int] NULL,
	[EmailDetailId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


