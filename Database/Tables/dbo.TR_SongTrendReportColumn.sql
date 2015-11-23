/****** Object:  Table [dbo].[TR_SongTrendReportColumn]    Script Date: 01/08/2014 15:37:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SongTrendReportColumn]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SongTrendReportColumn]
GO

/****** Object:  Table [dbo].[TR_SongTrendReportColumn]    Script Date: 01/08/2014 15:37:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SongTrendReportColumn](
	[ReportId] [int] NOT NULL,
	[ColumnText] [varchar](150) NOT NULL,
	[Hidden] [varchar](5) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


