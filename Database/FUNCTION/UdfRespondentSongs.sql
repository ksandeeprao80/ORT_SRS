/****** Object:  UserDefinedFunction [dbo].[UdfRespondentSongs]    Script Date: 06/24/2013 11:10:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UdfRespondentSongs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[UdfRespondentSongs]
GO
/****** Object:  UserDefinedFunction [dbo].[UdfRespondentSongs]    Script Date: 11/29/2012 11:10:03 ******/


CREATE FUNCTION DBO.UdfRespondentSongs(@SurveyId INT)
RETURNS @RespondentSongs TABLE
(
   SongId INT,
   QuestionId INT
)
AS
BEGIN
      DECLARE @MTBQuestions TABLE
      (QuestionId INT)
      
      DECLARE @MTBPODS TABLE
      (QuestionId INT, PlayListId INT)
      
      INSERT INTO @MTBQuestions
      (QuestionId)
      SELECT QuestionId FROM DBO.TR_SurveyQuestions WITH(NOLOCK) 
      WHERE SurveyId = @SurveyId AND UPPER(dbo.FN_QuestionSettingValue(QuestionId,'IsMTBQuestion')) = 'TRUE'
      
      INSERT INTO @MTBPODS
      (QuestionId, PlayListId)
      SELECT QuestionId,dbo.FN_QuestionSettingValue(QuestionId,'PlayListId')
      FROM @MTBQuestions
      
      INSERT INTO @RespondentSongs
      SELECT FileLibId,QuestionId
      FROM @MTBPODS MP
      INNER JOIN DBO.TR_PlayList TP WITH(NOLOCK) 
		ON MP.PlayListId = TP.PlayListId
      
      RETURN     
END


