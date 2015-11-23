/****** Object:  Table [dbo].[Audit_PublishSurvey]    Script Date: 03/05/2013 10:12:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Audit_PublishSurvey]') AND type in (N'U'))
DROP TABLE [dbo].[Audit_PublishSurvey]
GO

/****** Object:  Table [dbo].[Audit_PublishSurvey]    Script Date: 03/05/2013 10:12:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Audit_PublishSurvey](
	[AuId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [int] NOT NULL,
	[PublishedBy] [int] NOT NULL,
	[PublishedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO


