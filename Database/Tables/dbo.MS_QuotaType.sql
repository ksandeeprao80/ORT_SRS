USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_QuotaType]    Script Date: 07/16/2012 14:56:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_QuotaType]') AND type in (N'U'))
DROP TABLE [dbo].[MS_QuotaType]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_QuotaType]    Script Date: 07/16/2012 14:56:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_QuotaType](
	[QuotaId] [int] IDENTITY(1,1) NOT NULL,
	[QuotaName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TR_Quota_Type] PRIMARY KEY CLUSTERED 
(
	[QuotaId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


