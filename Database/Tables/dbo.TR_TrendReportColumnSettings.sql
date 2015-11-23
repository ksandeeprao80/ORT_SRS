/****** Object:  Table [dbo].[TR_TrendReportColumnSettings]    Script Date: 02/15/2013 17:55:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_TrendReportColumnSettings]') AND type in (N'U'))
DROP TABLE [dbo].[TR_TrendReportColumnSettings]
GO

/****** Object:  Table [dbo].[TR_TrendReportColumnSettings]    Script Date: 02/15/2013 17:55:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_TrendReportColumnSettings](
	[ReportId] [int] NULL,
	[ColumnName] [varchar](500) NULL,
	[Setting] [varchar](500) NULL,
	[SettingId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


