IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchClosedResponses]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchClosedResponses]

GO
/*
-- EXEC UspSearchClosedResponses 1158,'','21-11-2012','21-11-2012'
-- EXEC UspSearchClosedResponses 1158,'','21-11-2012',' '
-- EXEC UspSearchClosedResponses 1516,'R','',''
-- EXEC UspSearchClosedResponses 1158,'O','',''
-- EXEC UspSearchClosedResponses 1098,'O,R','',''
*/
CREATE PROCEDURE DBO.UspSearchClosedResponses
	@SurveyId INT,
	@RespondentType VARCHAR(10),-- O-Open, R-Respondent(Panelist)
	@FromDate VARCHAR(10),--DATETIME,
	@ToDate VARCHAR(10)--DATETIME
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	IF (@FromDate <> '' OR @FromDate <> ' ')
	BEGIN
		SET @FromDate = CONVERT(VARCHAR(10),CONVERT(DATETIME,@FromDate,103),121)
	END
	
	IF (@ToDate <> '' OR @ToDate <> ' ')
	BEGIN
		SET @ToDate = CONVERT(VARCHAR(10),CONVERT(DATETIME,@ToDate,103),121)
	END

	IF ISNULL(@FromDate,'') = ''
	BEGIN
		SET @FromDate = '1900-01-01'
	END

	IF ISNULL(@ToDate,'') = ''
	BEGIN
		SET @ToDate = '2050-01-01'
	END
	
	---------------------------------------------------------------------
	SELECT * INTO #RespondentType FROM [dbo].[Split] (',',@RespondentType)

	DECLARE @O VARCHAR(1) 
	DECLARE @R VARCHAR(1) 
	
	SELECT @O = Value FROM #RespondentType WHERE Value = 'O' 
	SELECT @R = Value FROM #RespondentType WHERE Value = 'R'
	---------------------------------------------------------------------

	DECLARE @xmlResult XML
	
	SELECT 
		TR.SessionId AS ResponseId, ISNULL(MIN(MR.FirstName+' '+MR.LastName),'') AS Respondent, 
		CASE WHEN TR.RespondentId = 0 THEN 'Any'
			 WHEN TR.RespondentId <> 0 THEN 'Panel' END AS ResponseType,
		CONVERT(VARCHAR(10),CAST(MIN(ResponseDate) AS DATE),103) +' '+ CONVERT(VARCHAR(10),CAST(MIN(ResponseDate) AS TIME(0))) AS StartTime,
		CONVERT(VARCHAR(10),CAST(MAX(ResponseDate) AS DATE),103) +' '+ CONVERT(VARCHAR(10),CAST(MAX(ResponseDate) AS TIME(0))) AS EndTime, 
		CONVERT(VARCHAR(8),DATEADD(SECOND,DATEDIFF(SECOND,MIN(ResponseDate), MAX(ResponseDate)),0),108) AS Duration,
		TR.RespondentId 
	INTO #ClosedResponses		
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId
		AND TR.[Status] = 'C'
		AND TSQ.IsDeleted = 1
		AND TSQ.SurveyId = @SurveyId
	LEFT OUTER JOIN DBO.MS_Respondent MR
		ON TR.RespondentId = MR.RespondentId
	WHERE TR.RespondentId = CASE WHEN LTRIM(RTRIM(@O)) = 'O' AND ISNULL(@R,'') = '' THEN 0 
								 WHEN ISNULL(@O,'') = '' AND LTRIM(RTRIM(@R)) = 'R' THEN MR.RespondentId
								 ELSE TR.RespondentId END 
		AND CONVERT(VARCHAR(10),ResponseDate,121) BETWEEN CONVERT(VARCHAR(10),@FromDate,121) AND CONVERT(VARCHAR(10),@ToDate,121)
	GROUP BY TSQ.SurveyId, TR.SessionId, TR.RespondentId 
	ORDER BY MIN(ResponseDate) DESC
	
	SET @XmlResult =
	(
		SELECT 
		(
			SELECT
			(
				SELECT 
					ResponseId, Respondent, ResponseType, StartTime, EndTime, Duration, RespondentId 
				FOR XML PATH(''), TYPE 
			) FOR XML PATH('Responses'), TYPE 
		) 
		FROM #ClosedResponses
		FOR XML PATH(''), ROOT('XmlResult')
	)
	
	SELECT @XmlResult AS XmlResult
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END 