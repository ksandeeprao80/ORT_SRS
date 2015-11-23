/****** Object:  Table [dbo].[TR_SurveyRequestDetails]    Script Date: 11/08/2012 15:07:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SurveyRequestDetails]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SurveyRequestDetails]
GO

/****** Object:  Table [dbo].[TR_SurveyRequestDetails]    Script Date: 11/08/2012 15:07:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SurveyRequestDetails](
	[RequestId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [varchar](20) NULL,
	[RespondentId] [varchar](20) NULL,
	[RespondentSessionId] [varchar](100) NULL,
	[SurveyPassword] [varchar](100) NULL,
	[SurveyKey] [varchar](100) NULL,
 CONSTRAINT [PK_TR_SurveyRequestDetails] PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


