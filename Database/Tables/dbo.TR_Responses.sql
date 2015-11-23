USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Responses_MS_Respondent]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Responses]'))
ALTER TABLE [dbo].[TR_Responses] DROP CONSTRAINT [FK_TR_Responses_MS_Respondent]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Responses_TR_Survey_Answers]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Responses]'))
ALTER TABLE [dbo].[TR_Responses] DROP CONSTRAINT [FK_TR_Responses_TR_Survey_Answers]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Responses_TR_Survey_Questions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Responses]'))
ALTER TABLE [dbo].[TR_Responses] DROP CONSTRAINT [FK_TR_Responses_TR_Survey_Questions]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Responses]    Script Date: 07/16/2012 15:10:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Responses]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Responses]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Responses]    Script Date: 07/16/2012 15:10:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_Responses](
	[ResponseId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [int] NULL,
	[AnswerId] [int] NULL,
	[RespondentId] [int] NULL,
 CONSTRAINT [PK_TR_Responses] PRIMARY KEY CLUSTERED 
(
	[ResponseId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TR_Responses]  WITH CHECK ADD  CONSTRAINT [FK_TR_Responses_MS_Respondent] FOREIGN KEY([RespondentId])
REFERENCES [dbo].[MS_Respondent] ([RespondentId])
GO

ALTER TABLE [dbo].[TR_Responses] CHECK CONSTRAINT [FK_TR_Responses_MS_Respondent]
GO

ALTER TABLE [dbo].[TR_Responses]  WITH CHECK ADD  CONSTRAINT [FK_TR_Responses_TR_Survey_Answers] FOREIGN KEY([AnswerId])
REFERENCES [dbo].[TR_SurveyAnswers] ([AnswerId])
GO

ALTER TABLE [dbo].[TR_Responses] CHECK CONSTRAINT [FK_TR_Responses_TR_Survey_Answers]
GO

ALTER TABLE [dbo].[TR_Responses]  WITH CHECK ADD  CONSTRAINT [FK_TR_Responses_TR_Survey_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_Responses] CHECK CONSTRAINT [FK_TR_Responses_TR_Survey_Questions]
GO


