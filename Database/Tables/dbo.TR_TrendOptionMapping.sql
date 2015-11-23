
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TR_TrendOptionMapping_TR_Trends]') AND parent_object_id = OBJECT_ID(N'[dbo].[TR_TrendOptionMapping]'))
ALTER TABLE [dbo].[TR_TrendOptionMapping] DROP CONSTRAINT [FK_TR_TrendOptionMapping_TR_Trends]
GO

/****** Object:  Table [dbo].[TR_TrendOptionMapping]    Script Date: 01/07/2013 10:05:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_TrendOptionMapping]') AND type in (N'U'))
DROP TABLE [dbo].[TR_TrendOptionMapping]
GO


/****** Object:  Table [dbo].[TR_TrendOptionMapping]    Script Date: 01/07/2013 10:05:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_TrendOptionMapping](
	[TOMId] [int] IDENTITY(1,1) NOT NULL,
	[TrendId] [int] NOT NULL,
	[OptionId] [int] NULL,
	[OptionName] [varchar](150) NULL,
	[BaseOptionId] [int] NULL,
	[BaseOptionName] [varchar](150) NULL,
	[StatusId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_TR_TrendOptionMapping] PRIMARY KEY CLUSTERED 
(
	[TOMId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_TrendOptionMapping]  WITH CHECK ADD  CONSTRAINT [FK_TR_TrendOptionMapping_TR_Trends] FOREIGN KEY([TrendId])
REFERENCES [dbo].[TR_Trends] ([TrendId])
GO

ALTER TABLE [dbo].[TR_TrendOptionMapping] CHECK CONSTRAINT [FK_TR_TrendOptionMapping_TR_Trends]
GO


