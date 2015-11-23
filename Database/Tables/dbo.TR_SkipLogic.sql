USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Skip_Logic_TR_Survey_Questions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SkipLogic]'))
ALTER TABLE [dbo].[TR_SkipLogic] DROP CONSTRAINT [FK_TR_Skip_Logic_TR_Survey_Questions]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SkipLogic]    Script Date: 07/16/2012 15:12:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SkipLogic]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SkipLogic]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SkipLogic]    Script Date: 07/16/2012 15:12:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SkipLogic](
	[QuestionId] [int] NOT NULL,
	[LogicExpression] [varchar](1000) NOT NULL,
	[TrueAction] [varchar](250) NOT NULL,
	[FalseAction] [varchar](250) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_SkipLogic]  WITH CHECK ADD  CONSTRAINT [FK_TR_Skip_Logic_TR_Survey_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_SkipLogic] CHECK CONSTRAINT [FK_TR_Skip_Logic_TR_Survey_Questions]
GO


