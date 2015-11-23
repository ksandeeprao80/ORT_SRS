/****** Object:  UserDefinedTableType [dbo].[SurveySongs]    Script Date: 3/24/2014 5:58:09 AM ******/
DROP TYPE [dbo].[SurveySongs]
GO

/****** Object:  UserDefinedTableType [dbo].[SurveySongs]    Script Date: 3/24/2014 5:58:09 AM ******/
CREATE TYPE [dbo].[SurveySongs] AS TABLE(
	[SongSrno] [int] NOT NULL,
	[SongId] [int] NULL,
	[QuestionId] [int] NULL,
	[RespondentId] [int] NULL,
	[SessionId] [varchar](100) NULL,
	PRIMARY KEY CLUSTERED 
(
	[SongSrno] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO


