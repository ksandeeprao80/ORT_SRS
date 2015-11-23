USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_TimeZone]    Script Date: 07/31/2012 12:37:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_TimeZone]') AND type in (N'U'))
DROP TABLE [dbo].[MS_TimeZone]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_TimeZone]    Script Date: 07/31/2012 12:37:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_TimeZone](
	[TimeZoneId] [int] IDENTITY(1,1) NOT NULL,
	[TimeZone] [varchar](15) NULL,
	[LocationName] [varchar](150) NULL,
 CONSTRAINT [PK_MS_TimeZone] PRIMARY KEY CLUSTERED 
(
	[TimeZoneId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


