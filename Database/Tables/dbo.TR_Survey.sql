USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Survey_MS_SurveyStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Survey]'))
ALTER TABLE [dbo].[TR_Survey] DROP CONSTRAINT [FK_TR_Survey_MS_SurveyStatus]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Survey]    Script Date: 07/16/2012 15:14:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Survey]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Survey]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[TR_Survey]    Script Date: 07/16/2012 15:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Survey](
	[SurveyId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyName] [varchar](50) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[StarMarked] [int] NULL,
	[RewardEnabled] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[StatusId] [int] NOT NULL,
 CONSTRAINT [PK_TR_Survey] PRIMARY KEY CLUSTERED 
(
	[SurveyId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_Survey]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_MS_SurveyStatus] FOREIGN KEY([StatusId])
REFERENCES [dbo].[MS_SurveyStatus] ([StatusId])
GO

ALTER TABLE [dbo].[TR_Survey] CHECK CONSTRAINT [FK_TR_Survey_MS_SurveyStatus]
GO


