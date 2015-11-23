CREATE TYPE [dbo].[SongScoreTable] AS TABLE(
	[SongSrno] [int] NOT NULL,
	[SongId] [int] not NULL,
	[MtbText] [varchar] (50),
	[SurveyId] [int] not NULL,
	[Count] [INT] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[SongSrno] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
