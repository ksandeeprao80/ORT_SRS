/****** Object:  Table [dbo].[MS_QuestionBranches]    Script Date: 03/12/2013 17:44:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_QuestionBranches]') AND type in (N'U'))
DROP TABLE [dbo].[MS_QuestionBranches]
GO

/****** Object:  Table [dbo].[MS_QuestionBranches]    Script Date: 03/12/2013 17:44:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_QuestionBranches](
	[BranchId] [int] IDENTITY(1,1) NOT NULL,
	[BranchType] [varchar](30) NOT NULL,
	[BranchName]  AS ([BranchType]+CONVERT([varchar](12),[BranchId],0)),
	[TrueAction] [varchar](150) NULL,
	[FalseAction] [varchar](150) NULL,
	[SurveyId] [int] NULL,
	[QuestionId] [int] NULL,
	[SendAtEnd] [bit] NULL,
	[MessageLibId] [int] NULL,
	[EmailDetailId] [int] NULL,
	[OldBranchId] [int] NULL,
 CONSTRAINT [PK_MS_QuestionBranches] PRIMARY KEY CLUSTERED 
(
	[BranchId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


