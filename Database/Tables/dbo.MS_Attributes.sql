/****** Object:  Table [dbo].[MS_Attributes]    Script Date: 11/23/2012 12:52:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_Attributes]') AND type in (N'U'))
DROP TABLE [dbo].[MS_Attributes]
GO

/****** Object:  Table [dbo].[MS_Attributes]    Script Date: 11/23/2012 12:52:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_Attributes](
	[AttributeId] [int] IDENTITY(1,1) NOT NULL,
	[AttributeName] [varchar](150) NOT NULL,
 CONSTRAINT [PK_MS_Attributes] PRIMARY KEY CLUSTERED 
(
	[AttributeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


