USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Sound_Clip_Info]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Sound_Clip_Info](
	[File_Lib_Id] [int] NOT NULL,
	[Title] [varchar](100) NULL,
	[Artist] [varchar](100) NULL,
	[File_Lib_Year] [varchar](4) NULL,
	[File_Path] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Sound_Clip_Info]  WITH CHECK ADD  CONSTRAINT [FK_TR_Sound_Clip_Info_TR_File_Library] FOREIGN KEY([File_Lib_Id])
REFERENCES [dbo].[TR_File_Library] ([File_Lib_Id])
GO
ALTER TABLE [dbo].[TR_Sound_Clip_Info] CHECK CONSTRAINT [FK_TR_Sound_Clip_Info_TR_File_Library]
GO
