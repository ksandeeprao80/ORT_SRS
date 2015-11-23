USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Email_Trigger_TR_Email_Details]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_EmailTrigger]'))
ALTER TABLE [dbo].[TR_EmailTrigger] DROP CONSTRAINT [FK_TR_Email_Trigger_TR_Email_Details]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Email_Trigger_TR_Message_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_EmailTrigger]'))
ALTER TABLE [dbo].[TR_EmailTrigger] DROP CONSTRAINT [FK_TR_Email_Trigger_TR_Message_Library]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Email_Trigger_TR_Survey_Questions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_EmailTrigger]'))
ALTER TABLE [dbo].[TR_EmailTrigger] DROP CONSTRAINT [FK_TR_Email_Trigger_TR_Survey_Questions]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_EmailTrigger]    Script Date: 07/16/2012 15:02:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_EmailTrigger]') AND type in (N'U'))
DROP TABLE [dbo].[TR_EmailTrigger]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_EmailTrigger]    Script Date: 07/16/2012 15:02:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_EmailTrigger](
	[QuestionId] [int] NOT NULL,
	[TriggerExpression] [varchar](150) NOT NULL,
	[TrueAction] [varchar](250) NOT NULL,
	[FalseAction] [varchar](250) NOT NULL,
	[SendAtEnd] [bit] NULL,
	[MessageLibId] [int] NULL,
	[EmailDetailId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_EmailTrigger]  WITH CHECK ADD  CONSTRAINT [FK_TR_Email_Trigger_TR_Email_Details] FOREIGN KEY([EmailDetailId])
REFERENCES [dbo].[TR_EmailDetails] ([EmailDetailId])
GO

ALTER TABLE [dbo].[TR_EmailTrigger] CHECK CONSTRAINT [FK_TR_Email_Trigger_TR_Email_Details]
GO

ALTER TABLE [dbo].[TR_EmailTrigger]  WITH CHECK ADD  CONSTRAINT [FK_TR_Email_Trigger_TR_Message_Library] FOREIGN KEY([MessageLibId])
REFERENCES [dbo].[TR_MessageLibrary] ([MessageLibId])
GO

ALTER TABLE [dbo].[TR_EmailTrigger] CHECK CONSTRAINT [FK_TR_Email_Trigger_TR_Message_Library]
GO

ALTER TABLE [dbo].[TR_EmailTrigger]  WITH CHECK ADD  CONSTRAINT [FK_TR_Email_Trigger_TR_Survey_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_EmailTrigger] CHECK CONSTRAINT [FK_TR_Email_Trigger_TR_Survey_Questions]
GO


