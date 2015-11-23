USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[MS_Panel_Members]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MS_Panel_Members](
	[Panelist_Id] [int] IDENTITY(1,1) NOT NULL,
	[Panelist_Name] [varchar](150) NOT NULL,
	[Respondent_Id] [int] NULL,
	[Customer_Id] [int] NOT NULL,
 CONSTRAINT [PK_MS_Panel_Members] PRIMARY KEY CLUSTERED 
(
	[Panelist_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[MS_Panel_Members]  WITH CHECK ADD  CONSTRAINT [FK_MS_Panel_Members_MS_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[MS_Customers] ([Customer_Id])
GO
ALTER TABLE [dbo].[MS_Panel_Members] CHECK CONSTRAINT [FK_MS_Panel_Members_MS_Customers]
GO
ALTER TABLE [dbo].[MS_Panel_Members]  WITH CHECK ADD  CONSTRAINT [FK_MS_Panel_Members_MS_Respondent] FOREIGN KEY([Respondent_Id])
REFERENCES [dbo].[MS_Respondent] ([Respondent_Id])
GO
ALTER TABLE [dbo].[MS_Panel_Members] CHECK CONSTRAINT [FK_MS_Panel_Members_MS_Respondent]
GO
