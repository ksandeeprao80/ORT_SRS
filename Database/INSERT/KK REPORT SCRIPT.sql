--IF EXISTS 
--(
--	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[]') 
--	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
--)
--DROP PROCEDURE [dbo].[ ]

--GO
DECLARE @Answer VARCHAR(150), @SurveyName VARCHAR(150), @CustomerName VARCHAR(150), @Artist VARCHAR(150),
		@FileLibYear VARCHAR(10)
SET @Answer= NULL --'Hate It'--'Like It'--'Love It'--'I don''t know this song' 
SET @SurveyName = NULL--'PipingAndPipingOutTest'--'Seattle KLCK – Survey September 2012'--NULL
SET @CustomerName = NULL--'RED FM'
SET @Artist = NULL--'Hemant'--'MJ'
SET @FileLibYear = NULL--'2012'--'1987'
---- EXEC  
--CREATE PROCEDURE DBO.Usp 
--AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		 TSQ.CustomerId, MC.CustomerName, TSQ.SurveyId, TS.SurveyName, TSCI.Title, TSCI.Artist, TFL.[FileName], 
		 TSCI.FileLibYear, TR.SongId, TSA.Answer, CONVERT(VARCHAR(10),TR.ResponseDate,103) AS ResponseDate, 
		 COUNT(1) TotalCount
	FROM TR_Responses TR
	INNER JOIN TR_SurveyAnswers TSA
		ON TR.AnswerId = TSA.AnswerId
	INNER JOIN TR_SurveyQuestions TSQ
		ON TSA.QuestionId = TSQ.QuestionId
		AND TSQ.QuestionTypeId = 1 
	INNER JOIN TR_Survey TS
		ON TSQ.SurveyId = TS.SurveyId
	INNER JOIN MS_Customers MC
		ON TS.CustomerId = MC.CustomerId
	INNER JOIN TR_SoundClipInfo TSCI
		ON TR.SongId = TSCI.FileLibId
	INNER JOIN TR_FileLibrary TFL
		ON TSCI.FileLibId = TFL.FileLibId
	WHERE ISNULL(TR.SongId,0)<> 0
		AND LTRIM(RTRIM(TSA.Answer)) = LTRIM(RTRIM(ISNULL(@Answer,TSA.Answer))) 
		AND LTRIM(RTRIM(TS.SurveyName)) = LTRIM(RTRIM(ISNULL(@SurveyName,TS.SurveyName)))
		AND LTRIM(RTRIM(MC.CustomerName)) = LTRIM(RTRIM(ISNULL(@CustomerName,MC.CustomerName)))
		AND LTRIM(RTRIM(TSCI.Artist)) = LTRIM(RTRIM(ISNULL(@Artist,TSCI.Artist)))
		AND LTRIM(RTRIM(TSCI.FileLibYear)) = LTRIM(RTRIM(ISNULL(@FileLibYear,TSCI.FileLibYear)))
	GROUP BY TSQ.CustomerId, MC.CustomerName, TSQ.SurveyId, TS.SurveyName, TSCI.Title, TSCI.Artist, 
		 TFL.[FileName], TSCI.FileLibYear, TR.SongId, TSA.Answer, CONVERT(VARCHAR(10),TR.ResponseDate,103)
	ORDER BY TSQ.SurveyId DESC

	--SELECT * FROM TR_SoundClipInfo
	--SELECT * FROM MS_PlayList

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
