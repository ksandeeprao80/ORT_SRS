IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_ReportQuestions_TR_ReportDataSource]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_ReportQuestions]'))
ALTER TABLE [dbo].[TR_ReportQuestions] DROP CONSTRAINT [FK_TR_ReportQuestions_TR_ReportDataSource]
GO

/****** Object:  Table [dbo].[TR_ReportQuestions]    Script Date: 12/26/2012 16:44:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_ReportQuestions]') AND type in (N'U'))
DROP TABLE [dbo].[TR_ReportQuestions]
GO

/****** Object:  Table [dbo].[TR_ReportQuestions]    Script Date: 12/26/2012 16:44:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_ReportQuestions](
	[RQId] [int] IDENTITY(1,1) NOT NULL,
	[RDSId] [int] NOT NULL,
	[ReportId] [int] NULL,
	[QuestionId] [int] NULL,
	[StatusId] [smallint] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_TR_ReportQuestions] PRIMARY KEY CLUSTERED 
(
	[RQId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TR_ReportQuestions]  WITH CHECK ADD  CONSTRAINT [FK_TR_ReportQuestions_TR_ReportDataSource] FOREIGN KEY([RDSId])
REFERENCES [dbo].[TR_ReportDataSource] ([RDSId])
GO

ALTER TABLE [dbo].[TR_ReportQuestions] CHECK CONSTRAINT [FK_TR_ReportQuestions_TR_ReportDataSource]
GO


