IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_ReportColumnOrder_TR_Report]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_ReportColumnOrder]'))
ALTER TABLE [dbo].[TR_ReportColumnOrder] DROP CONSTRAINT [FK_TR_ReportColumnOrder_TR_Report]
GO

/****** Object:  Table [dbo].[TR_ReportColumnOrder]    Script Date: 05/02/2013 16:49:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_ReportColumnOrder]') AND type in (N'U'))
DROP TABLE [dbo].[TR_ReportColumnOrder]
GO

/****** Object:  Table [dbo].[TR_ReportColumnOrder]    Script Date: 05/02/2013 16:49:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_ReportColumnOrder](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NULL,
	[ColumnOrder] [varchar](500) NULL,
	[TableType] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[RowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_ReportColumnOrder]  WITH CHECK ADD  CONSTRAINT [FK_TR_ReportColumnOrder_TR_Report] FOREIGN KEY([ReportId])
REFERENCES [dbo].[TR_Report] ([ReportId])
GO

ALTER TABLE [dbo].[TR_ReportColumnOrder] CHECK CONSTRAINT [FK_TR_ReportColumnOrder_TR_Report]
GO


