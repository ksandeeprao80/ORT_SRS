IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TR_RespondentReferrels_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TR_RespondentReferrels] DROP CONSTRAINT [DF_TR_RespondentReferrels_CreatedDate]
END

GO

/****** Object:  Table [dbo].[TR_RespondentReferrels]    Script Date: 04/23/2013 18:56:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_RespondentReferrels]') AND type in (N'U'))
DROP TABLE [dbo].[TR_RespondentReferrels]
GO

/****** Object:  Table [dbo].[TR_RespondentReferrels]    Script Date: 04/23/2013 18:56:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TR_RespondentReferrels](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[RespondentId] [int] NOT NULL,
	[SurveyId][int] NULL,
	[RefName] [varchar](100) NULL,
	[RefMail] [varchar](100) NULL,
	[RefPhoneNo] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TR_RespondentReferrels] PRIMARY KEY CLUSTERED 
(
	[RowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TR_RespondentReferrels] ADD  CONSTRAINT [DF_TR_RespondentReferrels_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


