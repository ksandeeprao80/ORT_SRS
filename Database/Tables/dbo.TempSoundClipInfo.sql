
/****** Object:  Table [dbo].[TempSoundClipInfo]    Script Date: 09/21/2012 16:08:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempSoundClipInfo]') AND type in (N'U'))
DROP TABLE [dbo].[TempSoundClipInfo]
GO

/****** Object:  Table [dbo].[TempSoundClipInfo]    Script Date: 09/21/2012 16:08:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TempSoundClipInfo](
	[TempId] [int] IDENTITY(1,1) NOT NULL,
	[FileLibId] [int] NULL,
	[Title] [varchar](100) NULL,
	[Artist] [varchar](100) NULL,
	[FileLibYear] [varchar](4) NULL,
	[FilePath] [varchar](1000) NULL,
	[Status][varchar](50) NULL,
	[StatusMessage] [varchar](500)NULL,
	[SessionId] [varchar](50) NULL,
	[UserId] [varchar](50) NULL,
	[CustomerId] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


