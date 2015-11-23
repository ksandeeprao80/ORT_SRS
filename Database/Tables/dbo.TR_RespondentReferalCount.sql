/****** Object:  Table [dbo].[TR_RespondentReferalCount]    Script Date: 06/21/2013 12:50:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_RespondentReferalCount]') AND type in (N'U'))
DROP TABLE [dbo].[TR_RespondentReferalCount]
GO

/****** Object:  Table [dbo].[TR_RespondentReferalCount]    Script Date: 06/21/2013 12:50:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_RespondentReferalCount](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [int] NOT NULL,
	[RespondentId] [int] NOT NULL,
	[Channel] [varchar](100) NULL,
	[ReferalCount] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


