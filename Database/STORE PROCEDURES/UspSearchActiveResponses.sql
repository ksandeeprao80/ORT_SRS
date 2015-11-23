IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchActiveResponses]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchActiveResponses]

GO
-- EXEC UspSearchActiveResponses 1158,'Paresh','P',NULL
-- EXEC UspSearchActiveResponses 1516,NULL,NULL,NULL
CREATE PROCEDURE DBO.UspSearchActiveResponses
	@SurveyId INT,
	@FirstName VARCHAR(50),
	@LastName VARCHAR(50),
	@EmailId VARCHAR(50)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @xmlResult XML
	
	SELECT 
			TR.SessionId, MIN(MR.FirstName) AS FirstName, MIN(MR.LastName) AS LastName,
			CONVERT(VARCHAR(10),CAST(MIN(TR.ResponseDate) AS DATE),103) +' '+ CONVERT(VARCHAR(10),CAST(MIN(TR.ResponseDate) AS TIME(0))) AS Start,
			CONVERT(VARCHAR(10),CAST(MAX(TR.ResponseDate) AS DATE),103) +' '+ CONVERT(VARCHAR(10),CAST(MAX(TR.ResponseDate) AS TIME(0))) AS LastActivity, 
			CASE WHEN CONVERT(VARCHAR(10),MIN(TS.SurveyEndDate),101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(10),MIN(TS.SurveyEndDate),121) END AS Expired,
			'' AS LastQuestionTime, '' AS Progress, MIN(MR.EmailId) AS RespondentEmailAddress, TR.RespondentId  
	INTO #ActiveResponses
	FROM DBO.TR_Responses TR
	INNER JOIN DBO.TR_SurveyQuestions TSQ
		ON TR.QuestionId = TSQ.QuestionId
		AND TR.[Status] = 'I'
		AND TSQ.IsDeleted = 1
		AND TSQ.SurveyId = @SurveyId
	INNER JOIN DBO.TR_Survey TS
		ON TSQ.SurveyId = TS.SurveyId
	LEFT OUTER JOIN MS_Respondent MR
		ON TR.RespondentId = MR.RespondentId
	WHERE (MR.FirstName LIKE '%'+@FirstName+'%' OR ISNULL(@FirstName,'')='')
		AND (MR.LastName LIKE '%'+@LastName+'%' OR ISNULL(@LastName,'')='')
		AND (MR.EmailId LIKE '%'+@EmailId+'%' OR ISNULL(@EmailId,'')='')
	GROUP BY TSQ.SurveyId, TSQ.CustomerId, TR.RespondentId, TR.SessionId
	ORDER BY MIN(TR.ResponseDate) DESC 
	
	SET @XmlResult =
	(
		SELECT 
		(
			SELECT
			(
				SELECT 
					SessionId, FirstName, LastName, Start, LastActivity, Expired,
					LastQuestionTime, Progress, RespondentEmailAddress, RespondentId  
				FOR XML PATH(''), TYPE 
			) FOR XML PATH('Responses'), TYPE 
		) 
		FROM #ActiveResponses
		--ORDER BY Start DESC, LastActivity DESC
		FOR XML PATH(''), ROOT('XmlResult')
	)
	
	SELECT @XmlResult AS XmlResult
	

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END 