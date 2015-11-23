/****** Object:  Table [dbo].[MS_QuestionTags]    Script Date: 10/31/2012 10:40:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_QuestionTags]') AND type in (N'U'))
DROP TABLE [dbo].[MS_QuestionTags]
GO

/****** Object:  Table [dbo].[MS_QuestionTags]    Script Date: 10/31/2012 10:40:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_QuestionTags](
	[QuestionTagId] [int] IDENTITY(1,1) NOT NULL,
	[TagName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MS_QuestionTags] PRIMARY KEY CLUSTERED 
(
	[QuestionTagId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


