USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Email_Details]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Email_Details](
	[Email_Detail_Id] [int] IDENTITY(1,1) NOT NULL,
	[Question_Id] [int] NOT NULL,
	[From_Email_Id] [varchar](150) NOT NULL,
	[To_Email_Id] [varchar](150) NOT NULL,
	[Send_Immediate] [bit] NULL,
	[Delay_In_Time] [varchar](10) NULL,
	[Mail_Sent] [char](1) NULL,
	[Sent_Date] [datetime] NULL,
 CONSTRAINT [PK_TR_Email_Details] PRIMARY KEY CLUSTERED 
(
	[Email_Detail_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Email_Details]  WITH CHECK ADD  CONSTRAINT [FK_TR_Email_Details_TR_Survey_Questions] FOREIGN KEY([Question_Id])
REFERENCES [dbo].[TR_Survey_Questions] ([Question_Id])
GO
ALTER TABLE [dbo].[TR_Email_Details] CHECK CONSTRAINT [FK_TR_Email_Details_TR_Survey_Questions]
GO
