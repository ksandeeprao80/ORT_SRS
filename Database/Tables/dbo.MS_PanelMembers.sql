USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_Panel_Members_MS_Customers]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_PanelMembers]'))
ALTER TABLE [dbo].[MS_PanelMembers] DROP CONSTRAINT [FK_MS_Panel_Members_MS_Customers]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_Panel_Members_MS_Respondent]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_PanelMembers]'))
ALTER TABLE [dbo].[MS_PanelMembers] DROP CONSTRAINT [FK_MS_Panel_Members_MS_Respondent]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_PanelMembers]    Script Date: 07/16/2012 14:54:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_PanelMembers]') AND type in (N'U'))
DROP TABLE [dbo].[MS_PanelMembers]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_PanelMembers]    Script Date: 07/16/2012 14:54:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_PanelMembers](
	[PanelistId] [int] IDENTITY(1,1) NOT NULL,
	[PanelistName] [varchar](150) NOT NULL,
	[RespondentId] [int] NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_MS_Panel_Members] PRIMARY KEY CLUSTERED 
(
	[PanelistId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MS_PanelMembers]  WITH CHECK ADD  CONSTRAINT [FK_MS_Panel_Members_MS_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MS_Customers] ([CustomerId])
GO

ALTER TABLE [dbo].[MS_PanelMembers] CHECK CONSTRAINT [FK_MS_Panel_Members_MS_Customers]
GO

ALTER TABLE [dbo].[MS_PanelMembers]  WITH CHECK ADD  CONSTRAINT [FK_MS_Panel_Members_MS_Respondent] FOREIGN KEY([RespondentId])
REFERENCES [dbo].[MS_Respondent] ([RespondentId])
GO

ALTER TABLE [dbo].[MS_PanelMembers] CHECK CONSTRAINT [FK_MS_Panel_Members_MS_Respondent]
GO


