/****** Object:  Table [dbo].[TR_QuestionQuota]    Script Date: 11/20/2012 15:53:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_QuestionQuota]') AND type in (N'U'))
DROP TABLE [dbo].[TR_QuestionQuota]
GO


/****** Object:  Table [dbo].[TR_QuestionQuota]    Script Date: 11/20/2012 15:53:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_QuestionQuota](
	[QuotaId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [int] NULL,
	[LogicExpression] [varchar](250) NULL,
	[FalseAction] [varchar](100) NULL,
 CONSTRAINT [PK_TR_QuestionQuota] PRIMARY KEY CLUSTERED 
(
	[QuotaId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


