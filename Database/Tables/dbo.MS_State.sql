USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_State_MS_Country]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_State]'))
ALTER TABLE [dbo].[MS_State] DROP CONSTRAINT [FK_MS_State_MS_Country]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_State]    Script Date: 07/31/2012 12:38:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_State]') AND type in (N'U'))
DROP TABLE [dbo].[MS_State]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_State]    Script Date: 07/31/2012 12:38:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_State](
	[StateId] [int] IDENTITY(1,1) NOT NULL,
	[StateCode] [varchar](10) NULL,
	[StateName] [varchar](30) NULL,
	[CountryId] [int] NOT NULL,
 CONSTRAINT [PK_MS_State] PRIMARY KEY CLUSTERED 
(
	[StateId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MS_State]  WITH CHECK ADD  CONSTRAINT [FK_MS_State_MS_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[MS_Country] ([CountryId])
GO

ALTER TABLE [dbo].[MS_State] CHECK CONSTRAINT [FK_MS_State_MS_Country]
GO


