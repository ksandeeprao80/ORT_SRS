USE [ORT_SRS]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MS_City_MS_State]') AND parent_object_id = OBJECT_ID(N'[dbo].[MS_City]'))
ALTER TABLE [dbo].[MS_City] DROP CONSTRAINT [FK_MS_City_MS_State]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_City]    Script Date: 07/31/2012 12:37:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_City]') AND type in (N'U'))
DROP TABLE [dbo].[MS_City]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_City]    Script Date: 07/31/2012 12:37:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_City](
	[CityId] [int] IDENTITY(1,1) NOT NULL,
	[CityCode] [varchar](10) NULL,
	[CityName] [varchar](30) NULL,
	[StateId] [int] NULL,
 CONSTRAINT [PK_MS_City] PRIMARY KEY CLUSTERED 
(
	[CityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[MS_City]  WITH CHECK ADD  CONSTRAINT [FK_MS_City_MS_State] FOREIGN KEY([StateId])
REFERENCES [dbo].[MS_State] ([StateId])
GO

ALTER TABLE [dbo].[MS_City] CHECK CONSTRAINT [FK_MS_City_MS_State]
GO


