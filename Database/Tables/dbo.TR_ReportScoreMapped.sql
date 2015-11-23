/****** Object:  Table [dbo].[TR_ReportScoreMapped]    Script Date: 12/05/2013 12:16:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_ReportScoreMapped]') AND type in (N'U'))
DROP TABLE [dbo].[TR_ReportScoreMapped]
GO

/****** Object:  Table [dbo].[TR_ReportScoreMapped]    Script Date: 12/05/2013 12:16:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_ReportScoreMapped](
	[ReportId] [int] NOT NULL,
	[ScoreId] [int] NOT NULL
) ON [PRIMARY]

GO


