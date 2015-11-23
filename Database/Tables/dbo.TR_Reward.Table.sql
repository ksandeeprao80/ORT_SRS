USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Reward]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Reward](
	[Reward_Id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_Id] [int] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Fees] [decimal](18, 2) NOT NULL,
	[Reward_Name] [varchar](150) NOT NULL,
	[Reward_Description] [varchar](150) NOT NULL,
	[Approx_Value] [decimal](18, 2) NOT NULL,
	[End_Date] [datetime] NULL,
 CONSTRAINT [PK_TR_Reward] PRIMARY KEY CLUSTERED 
(
	[Reward_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Reward]  WITH CHECK ADD  CONSTRAINT [FK_TR_Reward_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[TR_Reward] CHECK CONSTRAINT [FK_TR_Reward_MS_Customers]
GO
ALTER TABLE [dbo].[TR_Reward]  WITH CHECK ADD  CONSTRAINT [FK_TR_Reward_TR_Survey] FOREIGN KEY([Survey_Id])
REFERENCES [dbo].[TR_Survey] ([Survey_Id])
GO
ALTER TABLE [dbo].[TR_Reward] CHECK CONSTRAINT [FK_TR_Reward_TR_Survey]
GO
