/****** Object:  Table [dbo].[TR_Report]    Script Date: 12/26/2012 16:43:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Report]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Report]
GO

/****** Object:  Table [dbo].[TR_Report]    Script Date: 12/26/2012 16:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Report](
	[ReportId] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [varchar](100) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_TR_Report] PRIMARY KEY CLUSTERED 
(
	[ReportId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


