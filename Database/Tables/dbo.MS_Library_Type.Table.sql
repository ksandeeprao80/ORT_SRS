USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[MS_Library_Type]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MS_Library_Type](
	[Lib_Type_Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [varchar](100) NOT NULL,
	[Is_Active] [bit] NULL,
 CONSTRAINT [PK_MS_Library_Type] PRIMARY KEY CLUSTERED 
(
	[Lib_Type_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
