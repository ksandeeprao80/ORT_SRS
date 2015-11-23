/****** Object:  Table [dbo].[PB_TR_SkipLogic]    Script Date: 11/27/2012 15:10:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_SkipLogic]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_SkipLogic]
GO

/****** Object:  Table [dbo].[PB_TR_SkipLogic]    Script Date: 11/27/2012 15:10:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_SkipLogic](
	[LogicExpression] [varchar](1000) NOT NULL,
	[TrueAction] [varchar](250) NOT NULL,
	[FalseAction] [varchar](250) NOT NULL,
	[SurveyId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


