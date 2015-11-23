USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Responses]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TR_Responses](
	[Response_Id] [int] IDENTITY(1,1) NOT NULL,
	[Question_Id] [int] NULL,
	[Answer_Id] [int] NULL,
	[Respondent_Id] [int] NULL,
 CONSTRAINT [PK_TR_Responses] PRIMARY KEY CLUSTERED 
(
	[Response_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TR_Responses]  WITH CHECK ADD  CONSTRAINT [FK_TR_Responses_MS_Respondent] FOREIGN KEY([Response_Id])
REFERENCES [dbo].[MS_Respondent] ([Respondent_Id])
GO
ALTER TABLE [dbo].[TR_Responses] CHECK CONSTRAINT [FK_TR_Responses_MS_Respondent]
GO
ALTER TABLE [dbo].[TR_Responses]  WITH CHECK ADD  CONSTRAINT [FK_TR_Responses_TR_Survey_Answers] FOREIGN KEY([Answer_Id])
REFERENCES [dbo].[TR_Survey_Answers] ([Answer_Id])
GO
ALTER TABLE [dbo].[TR_Responses] CHECK CONSTRAINT [FK_TR_Responses_TR_Survey_Answers]
GO
ALTER TABLE [dbo].[TR_Responses]  WITH CHECK ADD  CONSTRAINT [FK_TR_Responses_TR_Survey_Questions] FOREIGN KEY([Question_Id])
REFERENCES [dbo].[TR_Survey_Questions] ([Question_Id])
GO
ALTER TABLE [dbo].[TR_Responses] CHECK CONSTRAINT [FK_TR_Responses_TR_Survey_Questions]
GO
