IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptGetMappedFilter]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptGetMappedFilter]

GO

--EXEC UspRptGetMappedFilter 590 
CREATE PROCEDURE DBO.UspRptGetMappedFilter
	@ReportId INT 
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
					SELECT MRF.FilterId, MRF.FilterName, TRFM.Conjuction
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
		INNER JOIN DBO.TR_ReportFilterMapping TRFM	 
			ON TRF.FilterId = TRFM.FilterId
		WHERE TRFM.ReportId = @ReportId
		ORDER BY TRFM.Mapid
		FOR XML PATH(''), ROOT('ArrayOfFilterViewModel')
	)
	
	SELECT @XmlResult AS XmlResult
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 
 
