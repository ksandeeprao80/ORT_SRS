/****** Object:  Table [dbo].[MS_ReportFilter]    Script Date: 02/05/2013 11:00:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_ReportFilter]') AND type in (N'U'))
DROP TABLE [dbo].[MS_ReportFilter]
GO

/****** Object:  Table [dbo].[MS_ReportFilter]    Script Date: 02/05/2013 11:00:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_ReportFilter](
	[FilterId] [int] IDENTITY(1,1) NOT NULL,
	[FilterName] [varchar](150) NOT NULL,
	[SurveyId] [int] NOT NULL,
 CONSTRAINT [PK_MS_ReportFilter] PRIMARY KEY CLUSTERED 
(
	[FilterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


