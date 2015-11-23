IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_PanelCategory_TR_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_PanelCategory]'))
ALTER TABLE [dbo].[TR_PanelCategory] DROP CONSTRAINT [FK_TR_PanelCategory_TR_Library]
GO

/****** Object:  Table [dbo].[TR_PanelCategory]    Script Date: 10/01/2012 13:22:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_PanelCategory]') AND type in (N'U'))
DROP TABLE [dbo].[TR_PanelCategory]
GO

/****** Object:  Table [dbo].[TR_PanelCategory]    Script Date: 10/01/2012 13:22:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_PanelCategory](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](100) NOT NULL,
	[LibId] [int] NOT NULL,
 CONSTRAINT [PK_TR_PanelCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_PanelCategory]  WITH CHECK ADD  CONSTRAINT [FK_TR_PanelCategory_TR_Library] FOREIGN KEY([LibId])
REFERENCES [dbo].[TR_Library] ([LibId])
GO

ALTER TABLE [dbo].[TR_PanelCategory] CHECK CONSTRAINT [FK_TR_PanelCategory_TR_Library]
GO


