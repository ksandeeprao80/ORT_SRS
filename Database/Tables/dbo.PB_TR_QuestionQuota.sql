/****** Object:  Table [dbo].[PB_TR_QuestionQuota]    Script Date: 11/27/2012 15:10:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_QuestionQuota]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_QuestionQuota]
GO

/****** Object:  Table [dbo].[PB_TR_QuestionQuota]    Script Date: 11/27/2012 15:10:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_QuestionQuota](
	[QuotaId] [int] NULL,
	[QuestionId] [int] NULL,
	[LogicExpression] [varchar](250) NULL,
	[FalseAction] [varchar](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


