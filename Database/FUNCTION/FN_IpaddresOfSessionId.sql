/****** Object:  UserDefinedFunction [dbo].[FN_IpaddresOfSessionId]    Script Date: 06/24/2013 11:10:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_IpaddresOfSessionId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FN_IpaddresOfSessionId]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_IpaddresOfSessionId]    Script Date: 11/29/2012 11:10:03 ******/

--SELECT DBO.FN_IpaddresOfSessionId(1632,'3tmytj55bw2cjj55h3uz4i55',0)

CREATE FUNCTION DBO.FN_IpaddresOfSessionId(@SurveyId INT, @SessionId VARCHAR(100), @RespondentId INT,@Status CHAR(1))
RETURNS VARCHAR(500)
AS 
BEGIN

	DECLARE @IpAddress VARCHAR(500)
	SET @IpAddress = ''

	IF ISNULL(@RespondentId,0) = 0
	BEGIN 
		SELECT @IpAddress = COALESCE(@IpAddress+'|','')+TR.IpAddress 
		FROM DBO.TR_Responses TR
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TR.QuestionId = TSQ.QuestionId
		WHERE TSQ.SurveyId = @SurveyId
		AND TR.SessionId = @SessionId
		AND TR.RespondentId = @RespondentId
		AND TR.[Status] = CASE WHEN @Status = 'A' THEN TR.[Status] ELSE @Status END
		GROUP BY TR.IpAddress 
	END
	ELSE
	BEGIN
		SELECT @IpAddress = COALESCE(@IpAddress+'|','')+TR.IpAddress 
		FROM DBO.TR_Responses TR
		INNER JOIN DBO.TR_SurveyQuestions TSQ
			ON TR.QuestionId = TSQ.QuestionId
		WHERE TSQ.SurveyId = @SurveyId
		AND TR.RespondentId = @RespondentId
		AND TR.[Status] = CASE WHEN @Status = 'A' THEN TR.[Status] ELSE @Status END
		GROUP BY TR.IpAddress 
	END
	
	RETURN SUBSTRING(@IpAddress,2,500) 
END	

 



 