/****** Object:  Table [dbo].[TempRespondent]    Script Date: 08/28/2012 15:33:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempRespondent]') AND type in (N'U'))
DROP TABLE [dbo].[TempRespondent]
GO

/****** Object:  Table [dbo].[TempRespondent]    Script Date: 08/28/2012 15:33:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TempRespondent](
	[TempId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [varchar](50) NULL,
	[EmailId] [varchar](50) NULL,
	[PanelistId] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Age][varchar](50) NULL,
	[BirthDate] [varchar](50) NULL,
	[Gender] [varchar](50) NULL,
	[Town] [varchar](50) NULL,
	[UDF1] [varchar](50) NULL,
	[UDF2] [varchar](50) NULL,
	[UDF3] [varchar](50) NULL,
	[UDF4] [varchar](50) NULL,
	[UDF5] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[StatusMessage] [varchar](500) NULL,
	[SessionId][varchar](50) NULL,
	[UserId][varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


