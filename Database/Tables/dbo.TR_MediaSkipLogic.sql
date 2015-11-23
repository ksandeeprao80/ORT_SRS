IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_MediaSkipLogic_TR_SurveyQuestions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_MediaSkipLogic]'))
ALTER TABLE [dbo].[TR_MediaSkipLogic] DROP CONSTRAINT [FK_TR_MediaSkipLogic_TR_SurveyQuestions]
GO

/****** Object:  Table [dbo].[TR_MediaSkipLogic]    Script Date: 10/04/2012 17:14:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_MediaSkipLogic]') AND type in (N'U'))
DROP TABLE [dbo].[TR_MediaSkipLogic]
GO

/****** Object:  Table [dbo].[TR_MediaSkipLogic]    Script Date: 10/04/2012 17:14:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_MediaSkipLogic](
	[LogicExpression] [varchar](1000) NOT NULL,
	[TrueAction] [varchar](250) NOT NULL,
	[FalseAction] [varchar](250) NOT NULL,
	[QuestionId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_MediaSkipLogic]  WITH CHECK ADD  CONSTRAINT [FK_TR_MediaSkipLogic_TR_SurveyQuestions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_MediaSkipLogic] CHECK CONSTRAINT [FK_TR_MediaSkipLogic_TR_SurveyQuestions]
GO


