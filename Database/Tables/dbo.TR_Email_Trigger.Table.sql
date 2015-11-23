USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Email_Trigger]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Email_Trigger](
	[Question_Id] [int] NOT NULL,
	[Trigger_Expression] [varchar](150) NOT NULL,
	[True_Action] [varchar](250) NOT NULL,
	[False_Action] [varchar](250) NOT NULL,
	[Send_At_End] [bit] NULL,
	[Message_Lib_Id] [int] NULL,
	[Email_Detail_Id] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Email_Trigger]  WITH CHECK ADD  CONSTRAINT [FK_TR_Email_Trigger_TR_Email_Details] FOREIGN KEY([Email_Detail_Id])
REFERENCES [dbo].[TR_Email_Details] ([Email_Detail_Id])
GO
ALTER TABLE [dbo].[TR_Email_Trigger] CHECK CONSTRAINT [FK_TR_Email_Trigger_TR_Email_Details]
GO
ALTER TABLE [dbo].[TR_Email_Trigger]  WITH CHECK ADD  CONSTRAINT [FK_TR_Email_Trigger_TR_Message_Library] FOREIGN KEY([Message_Lib_Id])
REFERENCES [dbo].[TR_Message_Library] ([Message_Lib_Id])
GO
ALTER TABLE [dbo].[TR_Email_Trigger] CHECK CONSTRAINT [FK_TR_Email_Trigger_TR_Message_Library]
GO
ALTER TABLE [dbo].[TR_Email_Trigger]  WITH CHECK ADD  CONSTRAINT [FK_TR_Email_Trigger_TR_Survey_Questions] FOREIGN KEY([Question_Id])
REFERENCES [dbo].[TR_Survey_Questions] ([Question_Id])
GO
ALTER TABLE [dbo].[TR_Email_Trigger] CHECK CONSTRAINT [FK_TR_Email_Trigger_TR_Survey_Questions]
GO
