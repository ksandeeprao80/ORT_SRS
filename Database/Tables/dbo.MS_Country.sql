USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_Country]    Script Date: 07/31/2012 12:38:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_Country]') AND type in (N'U'))
DROP TABLE [dbo].[MS_Country]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_Country]    Script Date: 07/31/2012 12:38:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [varchar](10) NULL,
	[CountryName] [varchar](50) NULL,
 CONSTRAINT [PK_MS_Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


