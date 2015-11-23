/****** Object:  Table [dbo].[MS_Templates]    Script Date: 11/23/2012 12:52:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_Templates]') AND type in (N'U'))
DROP TABLE [dbo].[MS_Templates]
GO

/****** Object:  Table [dbo].[MS_Templates]    Script Date: 11/23/2012 12:52:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_Templates](
	[TemplateId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateName] [varchar](150) NOT NULL,
	[TemplateType] [varchar](150) NULL,
	[IsActive] [int] NULL,
 CONSTRAINT [PK_MS_Templates] PRIMARY KEY CLUSTERED 
(
	[TemplateId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


