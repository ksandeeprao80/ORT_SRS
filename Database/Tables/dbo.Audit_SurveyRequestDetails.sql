IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Audit_SurveyRequestDetails_AuditDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Audit_SurveyRequestDetails] DROP CONSTRAINT [DF_Audit_SurveyRequestDetails_AuditDate]
END

GO


/****** Object:  Table [dbo].[Audit_SurveyRequestDetails]    Script Date: 03/07/2013 12:59:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Audit_SurveyRequestDetails]') AND type in (N'U'))
DROP TABLE [dbo].[Audit_SurveyRequestDetails]
GO


/****** Object:  Table [dbo].[Audit_SurveyRequestDetails]    Script Date: 03/07/2013 12:59:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Audit_SurveyRequestDetails](
	[SurveyId] [varchar](20) NULL,
	[RespondentId] [varchar](20) NULL,
	[RespondentSessionId] [varchar](100) NULL,
	[SurveyPassword] [varchar](100) NULL,
	[SurveyKey] [varchar](100) NULL,
	[RenderMode] [char](1) NULL,
	[AuditDate] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Audit_SurveyRequestDetails] ADD  CONSTRAINT [DF_Audit_SurveyRequestDetails_AuditDate]  DEFAULT (getdate()) FOR [AuditDate]
GO


