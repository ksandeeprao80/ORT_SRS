/****** Object:  Table [dbo].[MS_GenderMapping]    Script Date: 01/10/2014 16:25:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_GenderMapping]') AND type in (N'U'))
DROP TABLE [dbo].[MS_GenderMapping]
GO

/****** Object:  Table [dbo].[MS_GenderMapping]    Script Date: 01/10/2014 16:25:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_GenderMapping](
	[Gender] [varchar](30) NOT NULL,
	[GenderAlias] [char](1) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


