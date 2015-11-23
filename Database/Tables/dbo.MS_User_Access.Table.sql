USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[MS_User_Access]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MS_User_Access](
	[Access_Id] [int] IDENTITY(1,1) NOT NULL,
	[Access_Name] [varchar](50) NULL,
	[Access_Module] [varchar](50) NULL,
	[Access_Link] [varchar](1000) NULL,
	[Is_Active] [bit] NULL,
 CONSTRAINT [PK_MS_User_Access] PRIMARY KEY CLUSTERED 
(
	[Access_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
