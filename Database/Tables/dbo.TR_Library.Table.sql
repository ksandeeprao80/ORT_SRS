USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Library]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Library](
	[Lib_Id] [int] IDENTITY(1,1) NOT NULL,
	[Lib_Type_Id] [int] NOT NULL,
	[Lib_Name] [varchar](150) NULL,
	[Customer_Id] [int] NULL,
 CONSTRAINT [PK_TR_Library] PRIMARY KEY CLUSTERED 
(
	[Lib_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Library]  WITH CHECK ADD  CONSTRAINT [FK_TR_Library_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[TR_Library] CHECK CONSTRAINT [FK_TR_Library_MS_Customers]
GO
ALTER TABLE [dbo].[TR_Library]  WITH CHECK ADD  CONSTRAINT [FK_TR_Library_MS_Library_Type] FOREIGN KEY([Lib_Type_Id])
REFERENCES [dbo].[MS_Library_Type] ([Lib_Type_Id])
GO
ALTER TABLE [dbo].[TR_Library] CHECK CONSTRAINT [FK_TR_Library_MS_Library_Type]
GO
