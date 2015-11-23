USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Settings_MS_APP_Settings]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveySettings]'))
ALTER TABLE [dbo].[TR_SurveySettings] DROP CONSTRAINT [FK_TR_Survey_Settings_MS_APP_Settings]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Settings_MS_Customers]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveySettings]'))
ALTER TABLE [dbo].[TR_SurveySettings] DROP CONSTRAINT [FK_TR_Survey_Settings_MS_Customers]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Settings_MS_Settings]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveySettings]'))
ALTER TABLE [dbo].[TR_SurveySettings] DROP CONSTRAINT [FK_TR_Survey_Settings_MS_Settings]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_Settings_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_SurveySettings]'))
ALTER TABLE [dbo].[TR_SurveySettings] DROP CONSTRAINT [FK_TR_Survey_Settings_TR_Survey]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SurveySettings]    Script Date: 07/16/2012 15:30:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_SurveySettings]') AND type in (N'U'))
DROP TABLE [dbo].[TR_SurveySettings]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_SurveySettings]    Script Date: 07/16/2012 15:30:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_SurveySettings](
	[SurveyId] [int] NOT NULL,
	[SettingId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Value] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_SurveySettings]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Settings_MS_APP_Settings] FOREIGN KEY([SettingId])
REFERENCES [dbo].[MS_AppSettings] ([SettingId])
GO

ALTER TABLE [dbo].[TR_SurveySettings] CHECK CONSTRAINT [FK_TR_Survey_Settings_MS_APP_Settings]
GO

ALTER TABLE [dbo].[TR_SurveySettings]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Settings_MS_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MS_Customers] ([CustomerId])
GO

ALTER TABLE [dbo].[TR_SurveySettings] CHECK CONSTRAINT [FK_TR_Survey_Settings_MS_Customers]
GO

ALTER TABLE [dbo].[TR_SurveySettings]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Settings_MS_Settings] FOREIGN KEY([SettingId])
REFERENCES [dbo].[MS_SurveySettings] ([SettingId])
GO

ALTER TABLE [dbo].[TR_SurveySettings] CHECK CONSTRAINT [FK_TR_Survey_Settings_MS_Settings]
GO

ALTER TABLE [dbo].[TR_SurveySettings]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Settings_TR_Survey] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[TR_SurveySettings] CHECK CONSTRAINT [FK_TR_Survey_Settings_TR_Survey]
GO


