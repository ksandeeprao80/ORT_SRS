/****** Object:  Table [dbo].[MS_TemplatesItems]    Script Date: 11/23/2012 12:52:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_TemplatesItems]') AND type in (N'U'))
DROP TABLE [dbo].[MS_TemplatesItems]
GO

/****** Object:  Table [dbo].[MS_TemplatesItems]    Script Date: 11/23/2012 12:52:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_TemplatesItems](
	[ItemId] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [varchar](150) NOT NULL,
 CONSTRAINT [PK_MS_TemplatesItems] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


