USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Skip_Logic]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Skip_Logic](
	[Question_Id] [int] NOT NULL,
	[Logic_Expression] [varchar](1000) NOT NULL,
	[True_Action] [varchar](250) NOT NULL,
	[False_Action] [varchar](250) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Skip_Logic]  WITH CHECK ADD  CONSTRAINT [FK_TR_Skip_Logic_TR_Survey_Questions] FOREIGN KEY([Question_Id])
REFERENCES [dbo].[TR_Survey_Questions] ([Question_Id])
GO
ALTER TABLE [dbo].[TR_Skip_Logic] CHECK CONSTRAINT [FK_TR_Skip_Logic_TR_Survey_Questions]
GO
