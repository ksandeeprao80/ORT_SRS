IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_QuestionLibraryAnswers_TR_QuestionLibrary]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_QuestionLibraryAnswers]'))
ALTER TABLE [dbo].[TR_QuestionLibraryAnswers] DROP CONSTRAINT [FK_TR_QuestionLibraryAnswers_TR_QuestionLibrary]
GO

/****** Object:  Table [dbo].[TR_QuestionLibraryAnswers]    Script Date: 01/24/2013 12:39:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_QuestionLibraryAnswers]') AND type in (N'U'))
DROP TABLE [dbo].[TR_QuestionLibraryAnswers]
GO

/****** Object:  Table [dbo].[TR_QuestionLibraryAnswers]    Script Date: 01/24/2013 12:39:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_QuestionLibraryAnswers](
	[QuestionLibId] [int] NOT NULL,
	[Answer] [varchar](1000) NULL,
	[AnswerText] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_QuestionLibraryAnswers]  WITH CHECK ADD  CONSTRAINT [FK_TR_QuestionLibraryAnswers_TR_QuestionLibrary] FOREIGN KEY([QuestionLibId])
REFERENCES [dbo].[TR_QuestionLibrary] ([QuestionLibId])
GO

ALTER TABLE [dbo].[TR_QuestionLibraryAnswers] CHECK CONSTRAINT [FK_TR_QuestionLibraryAnswers_TR_QuestionLibrary]
GO


