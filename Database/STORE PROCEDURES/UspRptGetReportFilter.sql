IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptGetReportFilter]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptGetReportFilter]

GO

--EXEC UspRptGetReportFilter 1158 
CREATE PROCEDURE DBO.UspRptGetReportFilter
	@SurveyId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @xmlResult XML

	SET @XmlResult =
	(
		SELECT
		(
			SELECT
			(
				SELECT 
				(
					SELECT MRF.FilterId, MRF.FilterName
					FOR XML PATH(''), TYPE
				),
				(
					SELECT
					( 
						SELECT TRF.QuestionId 


						FOR XML PATH('Question'), TYPE
					),
					(	
						SELECT
							TRF.Operator AS AppliedDbMap, TRF.AnswerId AS SelectedAnswerId, 
							ISNULL(TRF.AnswerText,'') AS SelectedAnswerText, 
							ISNULL(TRF.FilterOperator,'') AS InterExpressionOperator
						FOR XML PATH(''), TYPE
					)

					FOR XML PATH('Expressions'), TYPE
				)
				FOR XML PATH(''), TYPE
			)

			FOR XML PATH('FilterViewModel'), TYPE
		)
		FROM DBO.MS_ReportFilter MRF
		INNER JOIN DBO.TR_ReportFilter TRF
			ON MRF.FilterId = TRF.FilterId
			AND MRF.SurveyId = @SurveyId
		FOR XML PATH(''), ROOT('ArrayOfFilterViewModel')
	)
	
	SELECT @XmlResult AS XmlResult
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 
 
