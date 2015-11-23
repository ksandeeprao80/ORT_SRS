/****** Object:  Table [dbo].[TR_QuestionFollowUpMap]    Script Date: 04/19/2013 10:12:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_QuestionFollowUpMap]') AND type in (N'U'))
DROP TABLE [dbo].[TR_QuestionFollowUpMap]
GO

/****** Object:  Table [dbo].[TR_QuestionFollowUpMap]    Script Date: 04/19/2013 10:12:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TR_QuestionFollowUpMap](
	[QuestionId] [int] NOT NULL,
	[FollowUpQuestionId] [int] NOT NULL
) ON [PRIMARY]

GO


