USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Email_Details_TR_Survey_Questions]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_EmailDetails]'))
ALTER TABLE [dbo].[TR_EmailDetails] DROP CONSTRAINT [FK_TR_Email_Details_TR_Survey_Questions]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_EmailDetails]    Script Date: 07/16/2012 15:01:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_EmailDetails]') AND type in (N'U'))
DROP TABLE [dbo].[TR_EmailDetails]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_EmailDetails]    Script Date: 07/16/2012 15:01:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_EmailDetails](
	[EmailDetailId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [int] NOT NULL,
	[FromEmailId] [varchar](150) NOT NULL,
	[ToEmailId] [varchar](150) NOT NULL,
	[SendImmediate] [bit] NULL,
	[DelayInTime] [varchar](10) NULL,
	[MailSent] [char](1) NULL,
	[SentDate] [datetime] NULL,
 CONSTRAINT [PK_TR_Email_Details] PRIMARY KEY CLUSTERED 
(
	[EmailDetailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_EmailDetails]  WITH CHECK ADD  CONSTRAINT [FK_TR_Email_Details_TR_Survey_Questions] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[TR_SurveyQuestions] ([QuestionId])
GO

ALTER TABLE [dbo].[TR_EmailDetails] CHECK CONSTRAINT [FK_TR_Email_Details_TR_Survey_Questions]
GO


