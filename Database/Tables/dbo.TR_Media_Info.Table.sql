USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Media_Info]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TR_Media_Info](
	[Question_Id] [int] NOT NULL,
	[File_Lib_Id] [int] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Randomize] [bit] NULL,
	[Auto_Advance] [bit] NULL,
	[Show_Title] [bit] NULL,
	[Autoplay] [bit] NULL,
	[HideForSeconds] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TR_Media_Info]  WITH CHECK ADD  CONSTRAINT [FK_TR_Media_Info_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[TR_Media_Info] CHECK CONSTRAINT [FK_TR_Media_Info_MS_Customers]
GO
ALTER TABLE [dbo].[TR_Media_Info]  WITH CHECK ADD  CONSTRAINT [FK_TR_Media_Info_TR_File_Library] FOREIGN KEY([File_Lib_Id])
REFERENCES [dbo].[TR_File_Library] ([File_Lib_Id])
GO
ALTER TABLE [dbo].[TR_Media_Info] CHECK CONSTRAINT [FK_TR_Media_Info_TR_File_Library]
GO
ALTER TABLE [dbo].[TR_Media_Info]  WITH CHECK ADD  CONSTRAINT [FK_TR_Media_Info_TR_Survey_Questions] FOREIGN KEY([Question_Id])
REFERENCES [dbo].[TR_Survey_Questions] ([Question_Id])
GO
ALTER TABLE [dbo].[TR_Media_Info] CHECK CONSTRAINT [FK_TR_Media_Info_TR_Survey_Questions]
GO
