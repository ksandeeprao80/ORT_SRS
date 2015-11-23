/****** Object:  Table [dbo].[MS_PlayList]    Script Date: 10/03/2012 11:39:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_PlayList]') AND type in (N'U'))
DROP TABLE [dbo].[MS_PlayList]
GO

/****** Object:  Table [dbo].[MS_PlayList]    Script Date: 10/03/2012 11:39:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_PlayList](
	[PlayListId] [int] IDENTITY(1,1) NOT NULL,
	[PlayListName] [varchar](150) NULL,
	[IsActive] [int] NULL,
 CONSTRAINT [PK_MS_PlayList] PRIMARY KEY CLUSTERED 
(
	[PlayListId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


