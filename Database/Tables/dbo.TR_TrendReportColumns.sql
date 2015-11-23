/****** Object:  Table [dbo].[TR_TrendReportColumns]    Script Date: 02/11/2013 16:29:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_TrendReportColumns]') AND type in (N'U'))
DROP TABLE [dbo].[TR_TrendReportColumns]
GO

/****** Object:  Table [dbo].[TR_TrendReportColumns]    Script Date: 02/11/2013 16:29:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_TrendReportColumns](
	[TRId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NULL,
	[ColumnName] [varchar](150) NULL,
	[Expression] [varchar](500) NULL,
	[ReportStatus] [int] NULL,
 CONSTRAINT [PK_TR_TrendReportColumns] PRIMARY KEY CLUSTERED 
(
	[TRId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


