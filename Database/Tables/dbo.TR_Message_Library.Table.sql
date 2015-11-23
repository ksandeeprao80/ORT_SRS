USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Message_Library]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Message_Library](
	[Message_Lib_Id] [int] IDENTITY(1,1) NOT NULL,
	[Lib_Id] [int] NOT NULL,
	[Message_Type_Id] [int] NOT NULL,
	[Message_Description] [varchar](150) NULL,
	[Message_Text] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_TR_Message_Library] PRIMARY KEY CLUSTERED 
(
	[Message_Lib_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Message_Library]  WITH CHECK ADD  CONSTRAINT [FK_TR_Message_Library_MS_Message_Type] FOREIGN KEY([Message_Type_Id])
REFERENCES [dbo].[MS_Message_Type] ([Message_Type_Id])
GO
ALTER TABLE [dbo].[TR_Message_Library] CHECK CONSTRAINT [FK_TR_Message_Library_MS_Message_Type]
GO
ALTER TABLE [dbo].[TR_Message_Library]  WITH CHECK ADD  CONSTRAINT [FK_TR_Message_Library_TR_Library] FOREIGN KEY([Lib_Id])
REFERENCES [dbo].[TR_Library] ([Lib_Id])
GO
ALTER TABLE [dbo].[TR_Message_Library] CHECK CONSTRAINT [FK_TR_Message_Library_TR_Library]
GO
