USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Graphic_Library]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Graphic_Library](
	[Graphic_Lib_Id] [int] IDENTITY(1,1) NOT NULL,
	[Lib_Id] [int] NOT NULL,
	[Graphic_Lib_Name] [varchar](150) NOT NULL,
	[Category] [varchar](150) NOT NULL,
	[FileName] [varchar](150) NOT NULL,
	[File_Type] [varchar](5) NOT NULL,
	[Uploaded_On] [datetime] NOT NULL,
 CONSTRAINT [PK_TR_Graphic_Library] PRIMARY KEY CLUSTERED 
(
	[Graphic_Lib_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Graphic_Library]  WITH CHECK ADD  CONSTRAINT [FK_TR_Graphic_Library_TR_Library] FOREIGN KEY([Lib_Id])
REFERENCES [dbo].[TR_Library] ([Lib_Id])
GO
ALTER TABLE [dbo].[TR_Graphic_Library] CHECK CONSTRAINT [FK_TR_Graphic_Library_TR_Library]
GO
