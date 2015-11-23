/****** Object:  UserDefinedFunction [dbo].[FN_CheckRespoSurveyDayDiff]    Script Date: 06/24/2013 11:10:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_CheckRespoSurveyDayDiff]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FN_CheckRespoSurveyDayDiff]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CheckRespoSurveyDayDiff]    Script Date: 11/29/2012 11:10:03 ******/

-- SELECT DBO.FN_CheckRespoSurveyDayDiff(1444,4622) -- True
-- SELECT DBO.FN_CheckRespoSurveyDayDiff(1988,4622) -- False

CREATE FUNCTION DBO.FN_CheckRespoSurveyDayDiff(@SurveyId INT, @RespondentId INT)
RETURNS VARCHAR(5)
AS 
BEGIN
	DECLARE @Value VARCHAR(500)
	DECLARE @NoSurveyDays INT
	DECLARE @LastResponseDays INT
	
	SET @Value = ''
	SELECT @NoSurveyDays = ISNULL(CONVERT(INT,Value),0) FROM DBO.TR_SurveySettings WITH(NOLOCK)
	WHERE SurveyId = @SurveyId AND SettingId = 68 --AND Value <> ''

	SELECT @LastResponseDays = ISNULL(DATEDIFF(DD,MAX(ResponseDate),GETDATE()),0)
	FROM DBO.TR_Responses WITH(NOLOCK) WHERE RespondentId = @RespondentId

	SET @Value = CASE WHEN ISNULL(@LastResponseDays,0) >= @NoSurveyDays THEN 'True' ELSE 'False' END
	
	RETURN @Value 
END	

 


