IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Templates_MS_Attributes]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Templates]'))
ALTER TABLE [dbo].[TR_Templates] DROP CONSTRAINT [FK_TR_Templates_MS_Attributes]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Templates_MS_Templates]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Templates]'))
ALTER TABLE [dbo].[TR_Templates] DROP CONSTRAINT [FK_TR_Templates_MS_Templates]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Templates_MS_TemplatesItems]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Templates]'))
ALTER TABLE [dbo].[TR_Templates] DROP CONSTRAINT [FK_TR_Templates_MS_TemplatesItems]
GO

/****** Object:  Table [dbo].[TR_Templates]    Script Date: 11/23/2012 12:53:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Templates]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Templates]
GO

/****** Object:  Table [dbo].[TR_Templates]    Script Date: 11/23/2012 12:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Templates](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[AttributeId] [int] NOT NULL,
	[Value] [varchar](150) NULL,
 CONSTRAINT [PK_TR_Templates] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_Templates]  WITH CHECK ADD  CONSTRAINT [FK_TR_Templates_MS_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[MS_Attributes] ([AttributeId])
GO

ALTER TABLE [dbo].[TR_Templates] CHECK CONSTRAINT [FK_TR_Templates_MS_Attributes]
GO

ALTER TABLE [dbo].[TR_Templates]  WITH CHECK ADD  CONSTRAINT [FK_TR_Templates_MS_Templates] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[MS_Templates] ([TemplateId])
GO

ALTER TABLE [dbo].[TR_Templates] CHECK CONSTRAINT [FK_TR_Templates_MS_Templates]
GO

ALTER TABLE [dbo].[TR_Templates]  WITH CHECK ADD  CONSTRAINT [FK_TR_Templates_MS_TemplatesItems] FOREIGN KEY([ItemId])
REFERENCES [dbo].[MS_TemplatesItems] ([ItemId])
GO

ALTER TABLE [dbo].[TR_Templates] CHECK CONSTRAINT [FK_TR_Templates_MS_TemplatesItems]
GO


