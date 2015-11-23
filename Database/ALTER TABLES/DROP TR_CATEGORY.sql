IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_Category_TR_Library]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_Category]'))
ALTER TABLE [dbo].[TR_Category] DROP CONSTRAINT [FK_TR_Category_TR_Library]
GO

/****** Object:  Table [dbo].[TR_Category]    Script Date: 10/05/2012 14:02:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Category]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Category]
GO


