IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptTrendWizardDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptTrendWizardDetails]

GO
-- EXEC UspRptTrendWizardDetails 122 

CREATE PROCEDURE DBO.UspRptTrendWizardDetails
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
					TT.BaseSurveyId, TT.BaseSurveyName AS SurveyName, 
					TT.ReportId, TT.IsBaseSurvey, TT.IsCompareSurvey
					FOR XML PATH(''), TYPE 
			),
			(
				SELECT
				(
					SELECT 
					(
						SELECT 
							TT.SurveyId, TOM.OptionName AS [Text], 0 AS BaseSurveyId, TOM.BaseOptionName AS BaseText
							FOR XML PATH(''), TYPE
						),
						(
							SELECT 
								TTCT.MTBId AS Id, TTCT.MTBText AS [Text], LOWER(TTCT.TrendType) AS TrendType
							FOR XML PATH('MtbOption'), TYPE
						),
						(
							SELECT 
								TTCT.MTBOptionName AS MtbOptionName 
							FOR XML PATH(''), TYPE
						)
						FOR XML PATH('Option'), TYPE 
					)
				FOR XML PATH('Options'), TYPE 	
			)
			FOR XML PATH('SurveySelection'), TYPE 
		) 
		FROM DBO.TR_Trends TT
		LEFT OUTER JOIN DBO.TR_TrendOptionMapping TOM
			ON TT.TrendId = TOM.TrendId
			AND TT.ReportId = @ReportId
		LEFT OUTER JOIN DBO.TR_TrendCrossTabs TTCT
			ON TT.ReportId = TTCT.ReportId
		GROUP BY TT.BaseSurveyId, TT.BaseSurveyName, TT.ReportId, TT.IsBaseSurvey, TT.IsCompareSurvey,
		TT.SurveyId, TOM.OptionName, TOM.BaseOptionName, TTCT.MTBId, TTCT.MTBText, TTCT.MTBOptionName, 
		TTCT.TrendType
		FOR XML PATH(''), ROOT('ArrayOfSurveySelection')
	)
	
	SELECT @XmlResult AS XmlResult
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END