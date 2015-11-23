USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[MS_Respondent]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MS_Respondent](
	[Respondent_Id] [int] IDENTITY(1,1) NOT NULL,
	[Respondent_Name] [varchar](150) NOT NULL,
	[Customer_Id] [int] NOT NULL,
 CONSTRAINT [PK_MS_Respondent] PRIMARY KEY CLUSTERED 
(
	[Respondent_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[MS_Respondent]  WITH CHECK ADD  CONSTRAINT [FK_MS_Respondent_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[MS_Respondent] CHECK CONSTRAINT [FK_MS_Respondent_MS_Customers]
GO
