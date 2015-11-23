USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[TR_Survey]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TR_Survey](
	[Survey_Id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_Name] [varchar](50) NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Star_Marked] [int] NULL,
	[Reward_Enabled] [int] NOT NULL,
	[Created_By] [int] NULL,
	[Created_Date] [datetime] NOT NULL,
	[Modified_By] [int] NULL,
	[Modified_Date] [datetime] NULL,
	[Is_Active] [bit] NOT NULL,
 CONSTRAINT [PK_TR_Survey] PRIMARY KEY CLUSTERED 
(
	[Survey_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TR_Survey]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[TR_Survey] CHECK CONSTRAINT [FK_TR_Survey_MS_Customers]
GO
ALTER TABLE [dbo].[TR_Survey]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_MS_Users] FOREIGN KEY([Modified_By])
REFERENCES [dbo].[MS_Users] ([UserId])
GO
ALTER TABLE [dbo].[TR_Survey] CHECK CONSTRAINT [FK_TR_Survey_MS_Users]
GO
ALTER TABLE [dbo].[TR_Survey]  WITH CHECK ADD  CONSTRAINT [FK_TR_Survey_MS_Users1] FOREIGN KEY([Created_By])
REFERENCES [dbo].[MS_Users] ([UserId])
GO
ALTER TABLE [dbo].[TR_Survey] CHECK CONSTRAINT [FK_TR_Survey_MS_Users1]
GO
