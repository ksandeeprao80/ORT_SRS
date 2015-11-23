USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_Respondent_MS_Customers]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_Respondent]'))
ALTER TABLE [dbo].[MS_Respondent] DROP CONSTRAINT [FK_MS_Respondent_MS_Customers]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_Respondent]    Script Date: 07/16/2012 14:56:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_Respondent]') AND type in (N'U'))
DROP TABLE [dbo].[MS_Respondent]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_Respondent]    Script Date: 07/16/2012 14:56:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_Respondent](
	[RespondentId] [int] IDENTITY(1,1) NOT NULL,
	[RespondentName] [varchar](150) NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_MS_Respondent] PRIMARY KEY CLUSTERED 
(
	[RespondentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MS_Respondent]  WITH CHECK ADD  CONSTRAINT [FK_MS_Respondent_MS_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[MS_Customers] ([CustomerId])
GO

ALTER TABLE [dbo].[MS_Respondent] CHECK CONSTRAINT [FK_MS_Respondent_MS_Customers]
GO


