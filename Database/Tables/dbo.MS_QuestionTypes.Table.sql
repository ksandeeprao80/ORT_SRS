USE [ORT_SRS]
GO
/****** Object:  Table [dbo].[MS_QuestionTypes]    Script Date: 06/22/2012 10:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MS_QuestionTypes](
	[Question_Type_Id] [int] IDENTITY(1,1) NOT NULL,
	[Question_Code] [varchar](100) NOT NULL,
	[Question_Name] [varchar](100) NOT NULL,
	[Sample_Template] [varchar](100) NOT NULL,
	[Blank_Template] [varchar](100) NOT NULL,
 CONSTRAINT [PK_MS_QuestionTypes] PRIMARY KEY CLUSTERED 
(
	[Question_Type_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
