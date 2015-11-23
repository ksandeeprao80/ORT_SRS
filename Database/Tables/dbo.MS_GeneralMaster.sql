/****** Object:  Table [dbo].[MS_GeneralMaster]    Script Date: 06/19/2013 15:35:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_GeneralMaster]') AND type in (N'U'))
DROP TABLE [dbo].[MS_GeneralMaster]
GO
/****** Object:  Table [dbo].[MS_GeneralMaster]    Script Date: 06/19/2013 15:35:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_GeneralMaster](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[GeneralDescription] [varchar](500) NULL,
	[TrailDays] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


