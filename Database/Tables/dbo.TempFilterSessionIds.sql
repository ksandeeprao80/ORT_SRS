/****** Object:  Table [dbo].[TempFilterSessionIds]    Script Date: 02/06/2013 16:04:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempFilterSessionIds]') AND type in (N'U'))
DROP TABLE [dbo].[TempFilterSessionIds]
GO

/****** Object:  Table [dbo].[TempFilterSessionIds]    Script Date: 02/06/2013 16:04:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TempFilterSessionIds](
	[SessionId] [varchar](100) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


