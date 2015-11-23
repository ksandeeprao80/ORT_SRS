USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Survey_Questions]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Survey_Questions](
	[Question_Id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_Id] [int] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Question_Type_Id] [int] NOT NULL,
	[Question_Text] [varchar](1000) NOT NULL,
	[Force_Response] [bit] NULL,
	[Has_Skip_Logic] [bit] NULL,
	[Has_Email_Trigger] [bit] NULL,
	[Has_Media] [bit] NULL,
	[Is_Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_TR_Survey_Questions] PRIMARY KEY CLUSTERED 
(
	[Question_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Survey_Questions]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Questions_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Questions] CHECK CONSTRAINT [FK_TR_Survey_Questions_MS_Customers]
GO
ALTER TABLE [dbo].[TR_Survey_Questions]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Questions_TR_Survey] FOREIGN KEY([Question_Type_Id])
REFERENCES [dbo].[MS_QuestionTypes] ([Question_Type_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Questions] CHECK CONSTRAINT [FK_TR_Survey_Questions_TR_Survey]
GO
ALTER TABLE [dbo].[TR_Survey_Questions]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_Questions_TR_Survey1] FOREIGN KEY([Survey_Id])
REFERENCES [dbo].[TR_Survey] ([Survey_Id])
GO
ALTER TABLE [dbo].[TR_Survey_Questions] CHECK CONSTRAINT [FK_TR_Survey_Questions_TR_Survey1]
GO
