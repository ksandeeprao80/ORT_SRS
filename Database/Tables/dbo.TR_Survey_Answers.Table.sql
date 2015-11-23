USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Survey_Answers]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Survey_Answers](
	[Answer_Id] [int] IDENTITY(1,1) NOT NULL,
	[Question_Id] [int] NOT NULL,
	[Answer] [varchar](50) NOT NULL,
	[Answer_Text] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_TR_Survey_Answers] PRIMARY KEY CLUSTERED 
(
	[Answer_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Survey_Answers]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Answers_TR_Survey_Questions] FOREIGN KEY([Question_Id])
REFERENCES [dbo].[TR_Survey_Questions] ([Question_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Answers] CHECK CONSTRAINT [FK_TR_Survey_Answers_TR_Survey_Questions]
GO
