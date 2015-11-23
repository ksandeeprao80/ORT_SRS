/****** Object:  Table [dbo].[MS_Channel]    Script Date: 01/09/2013 19:21:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_Channel]') AND type in (N'U'))
DROP TABLE [dbo].[MS_Channel]
GO

/****** Object:  Table [dbo].[MS_Channel]    Script Date: 01/09/2013 19:21:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_Channel](
	[ChannelId] [int] IDENTITY(1,1) NOT NULL,
	[ChannelDescription] [varchar](100) NULL,
 CONSTRAINT [PK_MS_Channel] PRIMARY KEY CLUSTERED 
(
	[ChannelId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


