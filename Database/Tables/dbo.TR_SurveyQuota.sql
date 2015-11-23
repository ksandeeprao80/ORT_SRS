USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Quota_TR_Quota_Type]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveyQuota]'))
ALTER TABLE [dbo].[TR_SurveyQuota] DROP CONSTRAINT [FK_TR_Survey_Quota_TR_Quota_Type]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Quota_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveyQuota]'))
ALTER TABLE [dbo].[TR_SurveyQuota] DROP CONSTRAINT [FK_TR_Survey_Quota_TR_Survey]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SurveyQuota]    Script Date: 07/16/2012 15:28:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SurveyQuota]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SurveyQuota]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SurveyQuota]    Script Date: 07/16/2012 15:28:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SurveyQuota](
	[SurveyId] [int] NOT NULL,
	[QuotaId] [int] NOT NULL,
	[Limit] [char](10) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_SurveyQuota]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Quota_TR_Quota_Type] FOREIGN KEY([QuotaId])
REFERENCES [dbo].[MS_QuotaType] ([QuotaId])
GO

ALTER TABLE [dbo].[TR_SurveyQuota] CHECK CONSTRAINT [FK_TR_Survey_Quota_TR_Quota_Type]
GO

ALTER TABLE [dbo].[TR_SurveyQuota]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Quota_TR_Survey] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[TR_SurveyQuota] CHECK CONSTRAINT [FK_TR_Survey_Quota_TR_Survey]
GO


