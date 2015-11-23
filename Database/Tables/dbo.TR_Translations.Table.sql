USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Translations]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Translations](
	[Survey_Id] [int] NOT NULL,
	[Language_Id] [int] NOT NULL,
	[Entity_Type] [char](1) NOT NULL,
	[Entity_Type_Id] [int] NOT NULL,
	[Trans_Text] [varchar](1000) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Translations]  WITH CHECK ADD  CONSTRAINT [FK_TR_Translations_MS_Languages] FOREIGN KEY([Language_Id])
REFERENCES [dbo].[MS_Languages] ([Language_Id])
GO
ALTER TABLE [dbo].[TR_Translations] CHECK CONSTRAINT [FK_TR_Translations_MS_Languages]
GO
ALTER TABLE [dbo].[TR_Translations]  WITH CHECK ADD  CONSTRAINT [FK_TR_Translations_TR_Survey] FOREIGN KEY([Survey_Id])
REFERENCES [dbo].[TR_Survey] ([Survey_Id])
GO
ALTER TABLE [dbo].[TR_Translations] CHECK CONSTRAINT [FK_TR_Translations_TR_Survey]
GO
