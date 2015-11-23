USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Library_TR_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveyLibrary]'))
ALTER TABLE [dbo].[TR_SurveyLibrary] DROP CONSTRAINT [FK_TR_Survey_Library_TR_Library]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Library_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveyLibrary]'))
ALTER TABLE [dbo].[TR_SurveyLibrary] DROP CONSTRAINT [FK_TR_Survey_Library_TR_Survey]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SurveyLibrary]    Script Date: 07/16/2012 15:15:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SurveyLibrary]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SurveyLibrary]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SurveyLibrary]    Script Date: 07/16/2012 15:15:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SurveyLibrary](
	[SurveyLibId] [int] IDENTITY(1,1) NOT NULL,
	[LibId] [int] NOT NULL,
	[SurveyId] [int] NOT NULL,
	[SurveyLibName] [varchar](150) NOT NULL,
	[Category] [varchar](150) NOT NULL,
 CONSTRAINT [PK_TR_Survey_Library] PRIMARY KEY CLUSTERED 
(
	[SurveyLibId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_SurveyLibrary]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Library_TR_Library] FOREIGN KEY([LibId])
REFERENCES [dbo].[TR_Library] ([LibId])
GO

ALTER TABLE [dbo].[TR_SurveyLibrary] CHECK CONSTRAINT [FK_TR_Survey_Library_TR_Library]
GO

ALTER TABLE [dbo].[TR_SurveyLibrary]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Library_TR_Survey] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[TR_SurveyLibrary] CHECK CONSTRAINT [FK_TR_Survey_Library_TR_Survey]
GO


