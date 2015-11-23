/****** Object:  Table [dbo].[PB_TR_Survey]    Script Date: 11/27/2012 15:11:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PB_TR_Survey]') AND type in (N'U'))
DROP TABLE [dbo].[PB_TR_Survey]
GO

/****** Object:  Table [dbo].[PB_TR_Survey]    Script Date: 11/27/2012 15:11:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PB_TR_Survey](
	[SurveyId] [int] NOT NULL,
	[SurveyName] [varchar](50) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[StarMarked] [int] NULL,
	[RewardEnabled] [int] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[StatusId] [int] NOT NULL,
	[CategoryId] [int] NULL,
	[LanguageId] [int] NULL,
	[SurveyEndDate] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


