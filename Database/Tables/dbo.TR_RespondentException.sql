/****** Object:  Table [dbo].[TempRespondent]    Script Date: 08/29/2012 11:50:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_RespondentException]') AND type in (N'U'))
DROP TABLE [dbo].[TR_RespondentException]
GO

/****** Object:  Table [dbo].[TR_RespondentException]    Script Date: 08/29/2012 11:50:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_RespondentException](
	[ExceptionId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [varchar](50) NULL,
	[EmailId] [varchar](50) NULL,
	[PanelistId] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Age] [varchar](50) NULL,
	[BirthDate] [varchar](50) NULL,
	[Gender] [varchar](50) NULL,
	[Town] [varchar](50) NULL,
	[UDF1] [varchar](50) NULL,
	[UDF2] [varchar](50) NULL,
	[UDF3] [varchar](50) NULL,
	[UDF4] [varchar](50) NULL,
	[UDF5] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[StatusMessage] [varchar](150) NULL,
	[SessionId] [int] NULL,
	[UserId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


