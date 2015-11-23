/****** Object:  Table [dbo].[TR_ReportQuestionMapped]    Script Date: 11/29/2013 15:59:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_ReportQuestionMapped]') AND type in (N'U'))
DROP TABLE [dbo].[TR_ReportQuestionMapped]
GO

/****** Object:  Table [dbo].[TR_ReportQuestionMapped]    Script Date: 11/29/2013 15:59:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_ReportQuestionMapped](
	[ReportId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL
) ON [PRIMARY]

GO


