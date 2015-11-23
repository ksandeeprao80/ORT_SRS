/****** Object:  UserDefinedFunction [dbo].[FN_GetNextQuestionNo]    Script Date: 04/12/2013 10:02:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_GetNextQuestionNo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[FN_GetNextQuestionNo]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetNextQuestionNo]    Script Date: 04/12/2013 10:02:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SELECT DBO.[FN_GetNextQuestionNo] (1098,8947)

CREATE FUNCTION [dbo].[FN_GetNextQuestionNo]
(
	@SurveyId INT,
	@QuestionId INT
)
RETURNS VARCHAR(30)
AS
BEGIN
	DECLARE @QueRowId INT
	DECLARE @NextQueNo INT
		
	DECLARE @Questions TABLE
	(RowId INT IDENTITY(1,1), SurveyId INT, QuestionId INT, QuestionNo INT)
	INSERT INTO @Questions
	(SurveyId, QuestionId, QuestionNo)
	SELECT 
		SurveyId, QuestionId, QuestionNo
	FROM DBO.TR_SurveyQuestions 
	WHERE SurveyId = @SurveyId AND QuestionTypeId <> 4
	ORDER BY QuestionNo 
	
	SELECT @QueRowId = RowId FROM @Questions WHERE QuestionId = @QuestionId
	
	SELECT @NextQueNo = QuestionNo FROM @Questions WHERE RowId = @QueRowId+1
	 
	RETURN @NextQueNo
END