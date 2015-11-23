USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Reward_MS_Customers]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Reward]'))
ALTER TABLE [dbo].[TR_Reward] DROP CONSTRAINT [FK_TR_Reward_MS_Customers]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Reward_TR_Survey]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Reward]'))
ALTER TABLE [dbo].[TR_Reward] DROP CONSTRAINT [FK_TR_Reward_TR_Survey]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Reward]    Script Date: 07/16/2012 15:11:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Reward]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Reward]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Reward]    Script Date: 07/16/2012 15:11:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Reward](
	[RewardId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Fees] [decimal](18, 2) NOT NULL,
	[RewardName] [varchar](150) NOT NULL,
	[RewardDescription] [varchar](150) NOT NULL,
	[ApproxValue] [decimal](18, 2) NOT NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_TR_Reward] PRIMARY KEY CLUSTERED 
(
	[RewardId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_Reward]  WITH CHECK ADD  CONSTRAINT [FK_TR_Reward_MS_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MS_Customers] ([CustomerId])
GO

ALTER TABLE [dbo].[TR_Reward] CHECK CONSTRAINT [FK_TR_Reward_MS_Customers]
GO

ALTER TABLE [dbo].[TR_Reward]  WITH CHECK ADD  CONSTRAINT [FK_TR_Reward_TR_Survey] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[TR_Survey] ([SurveyId])
GO

ALTER TABLE [dbo].[TR_Reward] CHECK CONSTRAINT [FK_TR_Reward_TR_Survey]
GO


