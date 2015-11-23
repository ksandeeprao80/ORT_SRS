USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Question_Library_TR_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_QuestionLibrary]'))
ALTER TABLE [dbo].[TR_QuestionLibrary] DROP CONSTRAINT [FK_TR_Question_Library_TR_Library]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Question_Library_TR_Survey_Questions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_QuestionLibrary]'))
ALTER TABLE [dbo].[TR_QuestionLibrary] DROP CONSTRAINT [FK_TR_Question_Library_TR_Survey_Questions]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_QuestionLibrary]    Script Date: 07/31/2012 14:39:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_QuestionLibrary]') AND type in (N'U'))
DROP TABLE [dbo].[TR_QuestionLibrary]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_QuestionLibrary]    Script Date: 07/31/2012 14:39:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_QuestionLibrary](
	[QuestionLibId] [int] IDENTITY(1,1) NOT NULL,
	[LibId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[QuestionLibName] [varchar](150) NOT NULL,
	[Category] [varchar](150) NOT NULL,
 CONSTRAINT [PK_TR_Question_Library] PRIMARY KEY CLUSTERED 
(
	[QuestionLibId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_QuestionLibrary]  WITH CHECK ADD  CONSTRAINT [FK_TR_Question_Library_TR_Library] FOREIGN KEY([LibId])
REFERENCES [dbo].[TR_Library] ([LibId])
GO

ALTER TABLE [dbo].[TR_QuestionLibrary] CHECK CONSTRAINT [FK_TR_Question_Library_TR_Library]
GO

ALTER TABLE [dbo].[TR_QuestionLibrary]  WITH CHECK ADD  CONSTRAINT [FK_TR_Question_Library_TR_Survey_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_QuestionLibrary] CHECK CONSTRAINT [FK_TR_Question_Library_TR_Survey_Questions]
GO


