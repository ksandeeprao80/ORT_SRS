/****** Object:  Table [dbo].[MS_InviteTypes]    Script Date: 10/25/2012 18:25:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_InviteTypes]') AND type in (N'U'))
DROP TABLE [dbo].[MS_InviteTypes]
GO

/****** Object:  Table [dbo].[MS_InviteTypes]    Script Date: 10/25/2012 18:25:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_InviteTypes](
	[InviteType] [int] IDENTITY(1,1) NOT NULL,
	[InviteTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_MS_InviteTypes] PRIMARY KEY CLUSTERED 
(
	[InviteType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



