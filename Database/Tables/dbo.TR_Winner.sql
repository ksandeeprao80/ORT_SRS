/****** Object:  Table [dbo].[TR_Winner]    Script Date: 04/04/2013 12:54:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Winner]') AND type in (N'U'))
DROP TABLE [dbo].[TR_Winner]
GO

/****** Object:  Table [dbo].[TR_Winner]    Script Date: 04/04/2013 12:54:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_Winner](
	[TW_Id] [int] IDENTITY(1,1) NOT NULL,
	[SurveyId] [int] NOT NULL,
	[RespondentIdentity] [varchar](100) NOT NULL,
	[RespondentRef] [varchar](100) NOT NULL,
	[RespondentType] [varchar](1) NOT NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_TR_Winner] PRIMARY KEY CLUSTERED 
(
	[TW_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


