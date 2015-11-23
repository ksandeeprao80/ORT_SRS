USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Survey_Settings]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Survey_Settings](
	[Survey_Id] [int] NOT NULL,
	[Setting_Id] [int] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Value] [varchar](1000) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Survey_Settings]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Settings_MS_APP_Settings] FOREIGN KEY([Setting_Id])
REFERENCES [dbo].[MS_App_Settings] ([Setting_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Settings] CHECK CONSTRAINT [FK_TR_Survey_Settings_MS_APP_Settings]
GO
ALTER TABLE [dbo].[TR_Survey_Settings]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Settings_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Settings] CHECK CONSTRAINT [FK_TR_Survey_Settings_MS_Customers]
GO
ALTER TABLE [dbo].[TR_Survey_Settings]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Settings_MS_Settings] FOREIGN KEY([Setting_Id])
REFERENCES [dbo].[MS_Survey_Settings] ([Setting_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Settings] CHECK CONSTRAINT [FK_TR_Survey_Settings_MS_Settings]
GO
ALTER TABLE [dbo].[TR_Survey_Settings]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Settings_TR_Survey] FOREIGN KEY([Survey_Id])
REFERENCES [dbo].[TR_Survey] ([Survey_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Settings] CHECK CONSTRAINT [FK_TR_Survey_Settings_TR_Survey]
GO
