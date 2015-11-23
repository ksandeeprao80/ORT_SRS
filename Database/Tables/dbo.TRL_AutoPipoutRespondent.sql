/****** Object:  Table [dbo].[TRL_AutoPipoutRespondent]    Script Date: 01/10/2014 17:46:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRL_AutoPipoutRespondent]') AND type in (N'U'))
DROP TABLE [dbo].[TRL_AutoPipoutRespondent]
GO

/****** Object:  Table [dbo].[TRL_AutoPipoutRespondent]    Script Date: 01/10/2014 17:46:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TRL_AutoPipoutRespondent](
	[TrlId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [int] NULL,
	[SessionId] [varchar](100) NULL,
	[PanelistId] [int] NULL,
	[ExceptionRemark] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TrlId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


