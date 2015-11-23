USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_MessageType]    Script Date: 07/16/2012 14:53:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_MessageType]') AND type in (N'U'))
DROP TABLE [dbo].[MS_MessageType]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_MessageType]    Script Date: 07/16/2012 14:53:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_MessageType](
	[MessageTypeId] [int] IDENTITY(1,1) NOT NULL,
	[MessageTypeName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_MS_Message_Type] PRIMARY KEY CLUSTERED 
(
	[MessageTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


