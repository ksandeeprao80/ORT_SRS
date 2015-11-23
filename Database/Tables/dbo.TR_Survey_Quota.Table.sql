USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Survey_Quota]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Survey_Quota](
	[Survey_Id] [int] NOT NULL,
	[Quota_Id] [int] NOT NULL,
	[Limit] [char](10) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Survey_Quota]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Quota_TR_Quota_Type] FOREIGN KEY([Quota_Id])
REFERENCES [dbo].[MS_Quota_Type] ([Quota_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Quota] CHECK CONSTRAINT [FK_TR_Survey_Quota_TR_Quota_Type]
GO
ALTER TABLE [dbo].[TR_Survey_Quota]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Quota_TR_Survey] FOREIGN KEY([Survey_Id])
REFERENCES [dbo].[TR_Survey] ([Survey_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Quota] CHECK CONSTRAINT [FK_TR_Survey_Quota_TR_Survey]
GO
