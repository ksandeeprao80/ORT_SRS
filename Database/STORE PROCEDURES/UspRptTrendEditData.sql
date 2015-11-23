IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspRptTrendEditData]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspRptTrendEditData]

GO
-- EXEC UspRptTrendEditData 255

CREATE PROCEDURE [dbo].UspRptTrendEditData 
	@ReportId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @BaseSurveyName NVARCHAR(50) 
	DECLARE @BaseSurveyId INT
	SELECT @BaseSurveyName = BaseSurveyName, @BaseSurveyId = BaseSurveyId FROM TR_Trends  WHERE ReportId = @ReportId

	CREATE TABLE #TR_Trends
	(
		SurveyName NVARCHAR(50), SurveyId INT, ReportId INT, IsBaseSurvey VARCHAR(5), IsCompareSurvey VARCHAR(5), 
		Options VARCHAR(50), TotalResponse VARCHAR(5), TrendId INT, SortOrder INT
	)
	INSERT INTO #TR_Trends
	(SurveyName, SurveyId,ReportId, IsBaseSurvey,IsCompareSurvey,Options,TotalResponse, TrendId, SortOrder)
	SELECT 
		DISTINCT @BaseSurveyName AS SurveyName, @BaseSurveyId AS SurveyId, @ReportId AS ReportId, 'true' AS IsBaseSurvey, 
		'false' AS IsCompareSurvey,' ' AS Options, '0' AS TotalResponse, 0, SortOrder
	FROM DBO.TR_Trends WHERE ReportId = @ReportId	

	INSERT INTO #TR_Trends
	(SurveyName, SurveyId,ReportId, IsBaseSurvey,IsCompareSurvey,Options,TotalResponse, TrendId, SortOrder)
	SELECT 
		SurveyName, SurveyId, ReportId, 'false' AS IsBaseSurvey, 'true' AS IsCompareSurvey,' ' AS Options, 
		'0' AS TotalResponse, TrendId, SortOrder
	FROM DBO.TR_Trends WHERE ReportId = @ReportId AND SurveyId IS NOT NULL
	
	-----------------------
	
	CREATE TABLE #TR_TrendOptionMapping
	(
		TrendId INT, SurveyId INT, OptionName NVARCHAR(150), BaseOptionName NVARCHAR(150),
		OptionQuestionId INT, OptionQuestionNo INT, OptionQuestionText NVARCHAR(2000),
		BaseQuestionId INT
	)
	INSERT INTO #TR_TrendOptionMapping
	(
		TrendId, SurveyId, OptionName, BaseOptionName, OptionQuestionId, OptionQuestionNo, 
		OptionQuestionText, BaseQuestionId
	)
	SELECT 
		DISTINCT
		TT.TrendId, TT.SurveyId, TOM.OptionName AS [Text], TOM.BaseOptionName AS BaseText,
		TSQ.QuestionId, TSQ.QuestionNo, TSQ.QuestionText, TSQ1.QuestionId
	FROM DBO.TR_TrendOptionMapping TOM
	INNER JOIN #TR_Trends TT
		ON TT.TrendId = TOM.TrendId AND TT.ReportId = @ReportId
	LEFT JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)
		ON TOM.OptionQuestionId = TSQ.QuestionId
	LEFT JOIN DBO.TR_SurveyQuestions TSQ1 WITH(NOLOCK)
		ON TOM.BaseQuestionId = TSQ1.QuestionId		
	WHERE TT.TrendId <> 0	
	
	INSERT INTO #TR_TrendOptionMapping
	(
		TrendId, SurveyId, OptionName, BaseOptionName, OptionQuestionId, OptionQuestionNo, 
		OptionQuestionText, BaseQuestionId
	)
	SELECT 
		TrendId, SurveyId, OptionName, BaseOptionName, QuestionId, QuestionNo, QuestionText,
		QuestionId AS BaseQuestionId
	FROM
	(
		SELECT 
			0 AS TrendId, TSQ.SurveyId, TSA.AnswerText AS OptionName, TSA.AnswerText AS BaseOptionName,
			TSQ.QuestionId, TSQ.QuestionNo, TSQ.QuestionText, TSQ.QuestionId AS BaseQuestionId
		FROM DBO.TR_SurveyAnswers TSA
		INNER JOIN 
		(
			SELECT 
				TSQ.SurveyId, TSQ.QuestionId, TSQ.QuestionNo, TSQ.QuestionText 
			FROM DBO.TR_SurveyQuestions TSQ
			INNER JOIN DBO.TR_QuestionSettings TQS
				ON TSQ.QuestionId = TQS.QuestionId AND TSQ.SurveyId = @BaseSurveyId 
			WHERE TQS.SettingId = 4 -- IsMTBQuestion
				AND TQS.Value = 'False' 
		) TSQ
		ON TSA.QuestionId = TSQ.QuestionId
		
		UNION	
		
		SELECT 
			0 AS TrendId, TSQ.SurveyId, LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TR.AnswerText AS OptionName,
			LEFT(TSQ.QuestionText,10)+CASE WHEN LEN(TSQ.QuestionText)>10 THEN '...:' ELSE ':' END+TR.AnswerText AS BaseOptionName,
			TSQ.QuestionId, TSQ.QuestionNo, TSQ.QuestionText, TSQ.QuestionId AS BaseQuestionId
		FROM DBO.TR_Responses TR
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TR.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @BaseSurveyId AND TSQ.QuestionTypeId = 3

		UNION
		
		SELECT 
			DISTINCT 
			0 AS TrendId, @BaseSurveyId AS  SurveyId, MTPF.FilterName  AS OptionName, MTPF.FilterName  AS BaseOptionName,
			0 AS QuestionId, 0 AS QuestionNo, '' AS QuestionText, 0 AS BaseQuestionId
		FROM DBO.MS_TrendPerceptFilter MTPF
		INNER JOIN DBO.TR_TrendPerceptFilter TTPF
			ON MTPF.FilterId = TTPF.FilterId AND MTPF.ReportId = @ReportId AND MTPF.SurveyId = @BaseSurveyId
	) A

	CREATE TABLE #TR_TrendCrossTabs
	(
		ReportId INT, BaseSurveyId INT, MTBId INT, MTBText VARCHAR(100), MTBOptionName VARCHAR(150), 
		BaseOptionName VARCHAR(150), TrendType VARCHAR(10)
	)
	INSERT INTO #TR_TrendCrossTabs
	(ReportId, BaseSurveyId, MTBId, MTBText, MTBOptionName, BaseOptionName, TrendType)
	SELECT 
		ReportId, BaseSurveyId, MTBId, MTBText, MTBOptionName, BaseOptionName, TrendType 
	FROM DBO.TR_TrendCrossTabs WHERE ReportId = @ReportId
	
	-------------------------------------------------------------------

	DECLARE @xmlResult XML
	
	SET @XmlResult =
	(
		SELECT 
		(
			SELECT
			(
				SELECT 
				(
					SELECT  
						 TT.SurveyName, TT.SurveyId, TT.ReportId, TT.IsBaseSurvey, TT.IsCompareSurvey, TT.SortOrder,  
					(
						SELECT
						(
							SELECT 
							(
								SELECT
								(
									SELECT 
										TT.SurveyId, TOM.OptionName AS [Text], @BaseSurveyId AS BaseSurveyId, 
										TOM.BaseOptionName AS BaseText,
										ISNULL(TOM.OptionQuestionId,'') AS OptionQuestionId, 
										ISNULL(TOM.BaseQuestionId,'') AS BaseQuestionId,
										ISNULL(TOM.OptionQuestionNo,'0') AS OptionQuestionNo, 
										ISNULL(TOM.OptionQuestionText,'') AS OptionQuestionText,
									(
										SELECT 
										(
											SELECT 
											(
												SELECT 
												(
													SELECT TTCT.MTBId AS Id, TTCT.MTBText AS [Text],TTCT.MTBOptionName AS MtbOptionName, 
													LOWER(TTCT.TrendType) AS TrendType 
													FOR XML PATH('MtbOption'), TYPE
												)
												FOR XML PATH(''), TYPE 
											)
											FROM #TR_TrendCrossTabs TTCT
											WHERE TOM.BaseOptionName = TTCT.BaseOptionName
											FOR XML PATH(''), TYPE 
										)
										FOR XML PATH('MtbOptions'), TYPE 
									)
									FOR XML PATH(''), TYPE 
								)	   
								FOR XML PATH('Option'), TYPE
							)	
							FROM #TR_TrendOptionMapping TOM
							WHERE TT.TrendId = TOM.TrendId
							ORDER BY TOM.OptionQuestionNo
							FOR XML PATH(''), TYPE 
						 )
						 FOR XML PATH('Options'), TYPE 
					),
						 TT.TotalResponse  
					FROM #TR_Trends TT
					FOR XML PATH('SurveySelection'), TYPE
				) 
				FOR XML PATH(''), TYPE 
			)
			FOR XML PATH(''), TYPE	
		)
		FOR XML PATH(''), ROOT('ArrayOfSurveySelection')
	)

	SELECT @XmlResult AS XmlResult
	
	DROP TABLE #TR_Trends
	DROP TABLE #TR_TrendOptionMapping
	DROP TABLE #TR_TrendCrossTabs

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END