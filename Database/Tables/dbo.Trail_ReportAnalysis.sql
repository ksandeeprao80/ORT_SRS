/****** Object:  Table [dbo].[Trail_ReportAnalysis]    Script Date: 06/19/2013 15:28:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Trail_ReportAnalysis]') AND type in (N'U'))
DROP TABLE [dbo].[Trail_ReportAnalysis]
GO

/****** Object:  Table [dbo].[Trail_ReportAnalysis]    Script Date: 06/19/2013 15:28:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Trail_ReportAnalysis](
	[SurveyId] [int] NULL,
	[SongId] [int] NULL,
	[AnswerId] [varchar](2000) NULL,
	[MediaAnswer] [int] NULL,
	[SessionId] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


