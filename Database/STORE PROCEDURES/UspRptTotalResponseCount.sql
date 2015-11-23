IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptTotalResponseCount]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptTotalResponseCount]

GO

-- EXEC UspRptTotalResponseCount 185

CREATE PROCEDURE DBO.UspRptTotalResponseCount 
	@ReportId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY
	
	DECLARE @Survey TABLE
	(SurveyId INT)
	INSERT INTO @Survey
	SELECT 
		DISTINCT SurveyId
	FROM 
	(
		SELECT BaseSurveyId AS SurveyId FROM DBO.TR_Trends WHERE ReportId = @ReportId
		UNION
		SELECT SurveyId FROM DBO.TR_Trends WHERE ReportId = @ReportId
	) A
	
	SELECT 
		COUNT(1) AS TotalRespondent
	FROM
	(
		SELECT 
			TR.SessionId
		FROM TR_Responses TR
		INNER JOIN TR_SurveyQuestions TSQ
			ON TR.QuestionId = TSQ.QuestionId
			AND TR.Status = 'C'
		INNER JOIN @Survey S
			ON TSQ.SurveyId = S.SurveyId
		GROUP BY TR.SessionId,TR.RespondentId	
	)A
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END 
	
	

