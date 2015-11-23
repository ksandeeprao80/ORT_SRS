/****** Object:  Table [dbo].[TR_UploadSession]    Script Date: 08/28/2012 18:22:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_UploadSession]') AND type in (N'U'))
DROP TABLE [dbo].[TR_UploadSession]
GO


/****** Object:  Table [dbo].[TR_UploadSession]    Script Date: 08/28/2012 18:22:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_UploadSession](
	[SessionId] [int] IDENTITY(1,1) NOT NULL,
	[FileType] [varchar](50) NULL,
	[FileName] [varchar](150) NULL,
	[CustomerId] [int] NULL,
	[UploadedBy] [int] NULL,
	[UploadedDate] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


