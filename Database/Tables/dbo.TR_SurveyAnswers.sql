USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Answers_TR_Survey_Questions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveyAnswers]'))
ALTER TABLE [dbo].[TR_SurveyAnswers] DROP CONSTRAINT [FK_TR_Survey_Answers_TR_Survey_Questions]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SurveyAnswers]    Script Date: 07/16/2012 15:14:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SurveyAnswers]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SurveyAnswers]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SurveyAnswers]    Script Date: 07/16/2012 15:14:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SurveyAnswers](
	[AnswerId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [int] NOT NULL,
	[Answer] [varchar](50) NOT NULL,
	[AnswerText] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_TR_Survey_Answers] PRIMARY KEY CLUSTERED 
(
	[AnswerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_SurveyAnswers]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Answers_TR_Survey_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_SurveyAnswers] CHECK CONSTRAINT [FK_TR_Survey_Answers_TR_Survey_Questions]
GO


