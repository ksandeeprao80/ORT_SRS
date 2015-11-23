/****** Object:  Table [dbo].[TR_ReportAnalysis]    Script Date: 06/10/2013 16:20:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_ReportAnalysis]') AND type in (N'U'))
DROP TABLE [dbo].[TR_ReportAnalysis]
GO

/****** Object:  Table [dbo].[TR_ReportAnalysis]    Script Date: 06/10/2013 16:20:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_ReportAnalysis](
	[SurveyId] [int] NULL,
	[SongId] [int] NULL,
	[AnswerId] [varchar](2000) NULL,
	[MediaAnswer] [int] NULL,
	[SessionId] [varchar](100) NULL,
	CreatedOn DATETIME
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


