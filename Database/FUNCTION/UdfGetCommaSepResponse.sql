/****** Object:  UserDefinedFunction [dbo].[UdfGetCommaSepResponse]    Script Date: 04/12/2013 10:02:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UdfGetCommaSepResponse]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[UdfGetCommaSepResponse]
GO
/****** Object:  UserDefinedFunction [dbo].[UdfGetCommaSepResponse]    Script Date: 04/12/2013 10:02:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SELECT DBO.[UdfGetCommaSepResponse] ('3njk3pmb3hsvdc45tdbidc55',1507,'C',3265)
-- SELECT DBO.[UdfGetCommaSepResponse] ('0cshk2452cvsne55gd1cud45',1397,'C',5710)

CREATE FUNCTION [dbo].[UdfGetCommaSepResponse]
(
	@SessionId VARCHAR(100),
	@SurveyId INT,
	@Status CHAR(1),
	@RespondentId INT,
	@RespondentSongs SurveySongs READONLY
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @AnswerId NVARCHAR(MAX)
	
	DECLARE @Questions TABLE 
	(QuestionId INT)
	INSERT INTO @Questions
	(QuestionId)
	SELECT TQS.QuestionId FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
	INNER JOIN DBO.TR_QuestionSettings TQS WITH(NOLOCK)
		ON TQS.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
		AND TQS.SettingId = 4 AND TQS.Value = 'False'
	
	DECLARE @MultiChoicQuestions TABLE
	(RowId INT IDENTITY(1,1), ResAns INT, AnswerId INT, QuestionNo INT, QuestionId INT)

	DECLARE @Test TABLE
	(TXT NVARCHAR(MAX),QuestionNo INT, SongId INT)

	IF ISNULL(@RespondentId,0) = 0 -- Anonymous
	BEGIN
		INSERT INTO @MultiChoicQuestions
		(ResAns, AnswerId, QuestionNo, QuestionId)	
		SELECT 
			TR.AnswerId, TR.AnswerId, TSQ.QuestionNo, TSQ.QuestionId
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK) 
		INNER JOIN DBO.TR_Responses TR  WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TSQ.SurveyId = @SurveyId AND TSQ.QuestionTypeId = 2
		WHERE TR.SessionId = @SessionId AND TR.RespondentId = @RespondentId
			AND TR.[Status] = CASE WHEN @Status = 'A' THEN TR.[Status] ELSE @Status END

		INSERT INTO @Test
		(TXT,QuestionNo, SongId)
		SELECT TXT, QuestionNo, SongId
		FROM 
		(
			SELECT A.TXT, A.QuestionNo, 0 AS SongId 
			FROM 
			(
				SELECT 
					'Q'+ CONVERT(VARCHAR(12),TSQ.QuestionNo)+'_'+CONVERT(VARCHAR(12),ROW_NUMBER() OVER (ORDER BY TSA.AnswerId))
					+CASE WHEN ResAns IS NULL THEN '~#|' ELSE '~"1"|' END AS TXT, TSQ.QuestionNo, MCQ.ResAns
				FROM DBO.TR_SurveyAnswers TSA WITH(NOLOCK)
				INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
					ON TSQ.QuestionId = TSA.QuestionId AND TSQ.SurveyId = @SurveyId AND TSQ.QuestionTypeId = 2
				LEFT JOIN @MultiChoicQuestions MCQ ON TSA.QuestionId = MCQ.QuestionId AND TSA.AnswerId = MCQ.AnswerId
			) A 
			WHERE A.ResAns IS NOT NULL
		
			UNION ALL
		 
			SELECT 
				CASE WHEN TR.QuestionId IS NULL THEN 'Q'+CONVERT(VARCHAR(12),TSQ.QuestionNo)+'~#|' 
					 ELSE 'Q'+CONVERT(VARCHAR(12),TsQ.QuestionNo)+'~'+
						CASE WHEN CONVERT(VARCHAR(12),TR.AnswerId) = 0 THEN '"' + TR.AnswerText+ '"' + '|' 
							 ELSE CONVERT(VARCHAR(12),TR.SrNo)+'|' 
						END
					END AS TXT, TsQ.QuestionNo, 0 AS SongId
			FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
			INNER JOIN DBO.MS_QuestionTypes MQT WITH(NOLOCK)
				ON TSQ.QuestionTypeId = MQT.QuestionTypeId AND TSQ.SurveyId = @SurveyId
				AND MQT.QuestionCode NOT IN('PageBreak','EndOfBlock') 
				AND TSQ.QuestionNo <> 0 AND TSQ.QuestionTypeId <> 2
			INNER JOIN
			(
				SELECT Q.QuestionId FROM @Questions Q
				INNER JOIN DBO.TR_QuestionSettings TQS WITH(NOLOCK)
					ON Q.QuestionId = TQS.QuestionId AND TQS.SettingId = 21 AND Value <> 'True'
			) TSS
				ON TSQ.QuestionId = TSS.QuestionId 	
			LEFT JOIN 
			(
				SELECT 
					TA.SrNo, ISNULL(TA.AnswerId,T.AnswerId) AS AnswerId, ISNULL(TA.QuestionId,T.QuestionId) AS QuestionId, 
					T.SessionId, T.[Status], T.AnswerText, T.RespondentId  
				FROM 
				(
					SELECT TR.* FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK) 
					INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
						ON TR.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
						AND TR.SessionId = @SessionId AND TR.RespondentId = @RespondentId
				) T
				LEFT JOIN 
				(
					SELECT TA.*, ROW_NUMBER() OVER(PARTITION BY TA.QuestionId ORDER BY AnswerId) AS SrNo 
					FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK) 
					INNER JOIN DBO.TR_SurveyAnswers TA WITH(NOLOCK) 
						ON TSQ.QuestionId = TA.QuestionId AND TSQ.SurveyId = @SurveyId
				) TA
					ON T.QuestionId = TA.QuestionId  AND TA.AnswerId = T.AnswerId
			) TR 
				ON TSQ.QuestionId = TR.QuestionId 
			WHERE TR.[Status] = CASE WHEN @Status = 'A' THEN TR.[Status] ELSE @Status END
				AND TR.SessionId = @SessionId AND TR.RespondentId = @RespondentId
				
			UNION ALL
			
			SELECT 
				'Q'+ CONVERT(VARCHAR(12),TSQ.QuestionNo)+ '_'
				+ CONVERT(VARCHAR(12),(ROW_NUMBER() OVER (PARTITION BY TSQ.QuestionNo,TSS.IsFollowup ORDER BY tr.FileLibId)))
				+ CASE WHEN (TR.SongId IS NULL OR TR.SongId = 0) THEN '_1~#|' ELSE 
				+ CASE WHEN TSS.IsFollowup = 'True' THEN '_1' ELSE '' END +'~' 
				+ CONVERT(VARCHAR(12),CASE WHEN TR.AnswerId NOT IN(1,2,3,4,5,6) THEN TR.SrNo ELSE TR.AnswerId END)+'|' END AS TXT, 			
				TSQ.QuestionNo, Tr.FileLibId AS SongId
			FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
			INNER JOIN
			(
				SELECT TSS.QuestionId,'False' AS IsFollowup
				FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
				INNER JOIN DBO.TR_QuestionSettings TSS WITH(NOLOCK)
					ON TSS.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
					AND TSS.SettingId = 4 AND TSS.Value = 'True'
					 	
				UNION
				
				SELECT TSS.QuestionId,'True' AS IsFollowup
				FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
				INNER JOIN DBO.TR_QuestionSettings TSS WITH(NOLOCK)
					ON TSS.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
					AND TSS.SettingId = 21 AND TSS.Value = 'True'
			) TSS 
				ON TSQ.QuestionId = TSS.QuestionId
			LEFT OUTER JOIN
			(
				SELECT 
					TA.SrNo, ISNULL(TA.AnswerId,T.AnswerId) AS AnswerId, T.SongId,
					ISNULL(TA.QuestionId,T.QuestionId) AS QuestionId, T.SessionId, T.[Status], T.AnswerText,
					T.RespondentId,T.FileLibId
				FROM 
				(
					SELECT 
						TR.SongId, RS.QuestionId, TR.RespondentId, TR.[Status], TR.AnswerText, TR.SessionId,
						TR.AnswerId, RS.SongId AS FileLibId
					FROM @RespondentSongs RS 
					LEFT JOIN 
					(
						SELECT * FROM DBO.TR_Responses WITH(NOLOCK) WHERE SessionId = @SessionId 
					) TR 
						ON RS.QuestionId = TR.QuestionId 
					AND TR.SongId = RS.SongId
				) T
				LEFT JOIN 
				(
					SELECT TA.*, ROW_NUMBER() OVER(PARTITION BY TA.QuestionId ORDER BY AnswerId) AS SrNo 
					FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
					INNER JOIN DBO.TR_SurveyAnswers TA WITH(NOLOCK) 
						ON TSQ.QuestionId = TA.QuestionId AND TSQ.SurveyId = @SurveyId
				) TA
					ON T.QuestionId = TA.QuestionId  AND TA.AnswerId = T.AnswerId
			) TR
				ON TSQ.QuestionId = TR.QuestionId		
		) A
		ORDER BY QuestionNo ASC, SongId ASC
	END
	ELSE
	BEGIN -- Respondent from Master 
		INSERT INTO @MultiChoicQuestions
		(ResAns, AnswerId, QuestionNo, QuestionId)
		SELECT 
			TR.AnswerId, TR.AnswerId, TSQ.QuestionNo, TSQ.QuestionId
		FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK) 
		INNER JOIN DBO.TR_Responses TR  WITH(NOLOCK)
			ON TSQ.QuestionId = TR.QuestionId AND TSQ.SurveyId = @SurveyId AND TSQ.QuestionTypeId = 2
		WHERE TR.RespondentId = @RespondentId
			AND TR.[Status] = CASE WHEN @Status = 'A' THEN TR.[Status] ELSE @Status END
		
		INSERT INTO @Test
		(TXT,QuestionNo, SongId)
		SELECT TXT, QuestionNo, SongId
		FROM 
		(
			SELECT A.TXT, A.QuestionNo, 0 AS SongId 
			FROM 
			(
				SELECT 
					'Q'+ CONVERT(VARCHAR(12),TSQ.QuestionNo)+'_'+CONVERT(VARCHAR(12),ROW_NUMBER() OVER (ORDER BY TSA.AnswerId))
					+CASE WHEN ResAns IS NULL THEN '~#|' ELSE '~"1"|' END AS TXT, TSQ.QuestionNo, MCQ.ResAns
				FROM DBO.TR_SurveyAnswers TSA WITH(NOLOCK)
				INNER JOIN DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
					ON TSQ.QuestionId = TSA.QuestionId AND TSQ.SurveyId = @SurveyId AND TSQ.QuestionTypeId = 2
				LEFT JOIN @MultiChoicQuestions MCQ ON TSA.QuestionId = MCQ.QuestionId AND TSA.AnswerId = MCQ.AnswerId
			) A 
			WHERE A.ResAns IS NOT NULL
		
			UNION ALL
		 
			SELECT 
				CASE WHEN TR.QuestionId IS NULL THEN 'Q'+CONVERT(VARCHAR(12),TsQ.QuestionNo)+'~#|' 
					 ELSE 'Q'+CONVERT(VARCHAR(12),TsQ.QuestionNo)+'~'+
						CASE WHEN CONVERT(VARCHAR(12),TR.AnswerId) = 0 THEN '"' + TR.AnswerText+ '"' + '|' 
							 ELSE CONVERT(VARCHAR(12),TR.SrNo)+'|' 
						END
					END AS TXT, TsQ.QuestionNo, 0 AS SongId
			FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
			INNER JOIN DBO.MS_QuestionTypes MQT WITH(NOLOCK)
				ON TSQ.QuestionTypeId = MQT.QuestionTypeId AND TSQ.SurveyId = @SurveyId
				AND MQT.QuestionCode NOT IN('PageBreak','EndOfBlock') 
				AND TSQ.QuestionNo <> 0 AND TSQ.QuestionTypeId <> 2
			INNER JOIN
			(
				SELECT Q.QuestionId FROM @Questions Q
				INNER JOIN TR_QuestionSettings TQS WITH(NOLOCK)
					ON Q.QuestionId = TQS.QuestionId AND TQS.SettingId = 21 AND Value <> 'True'
			) TSS
				ON TSQ.QuestionId = TSS.QuestionId 	
			LEFT JOIN 
			(
				SELECT 
					TA.SrNo, ISNULL(TA.AnswerId,T.AnswerId) AS AnswerId, ISNULL(TA.QuestionId,T.QuestionId) AS QuestionId, 
					T.SessionId, T.[Status], T.AnswerText, T.RespondentId  
				FROM 
				(
					SELECT TR.* FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK) 
					INNER JOIN DBO.TR_Responses TR WITH(NOLOCK)
						ON TR.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
						AND TR.RespondentId = @RespondentId
				) T
				LEFT JOIN 
				(
					SELECT TA.*, ROW_NUMBER() OVER(PARTITION BY TA.QuestionId ORDER BY AnswerId) SrNo 
					FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK) 
					INNER JOIN DBO.TR_SurveyAnswers TA WITH(NOLOCK) 
						ON TSQ.QuestionId = TA.QuestionId AND TSQ.SurveyId = @SurveyId
				) TA
					ON T.QuestionId = TA.QuestionId  AND TA.AnswerId = T.AnswerId
			) TR 
				ON TSQ.QuestionId = TR.QuestionId 
			WHERE TR.[Status] = CASE WHEN @Status = 'A' THEN TR.[Status] ELSE @Status END
				AND TR.RespondentId = @RespondentId
				
			UNION ALL
			
			SELECT 
				'Q'+ CONVERT(VARCHAR(12),TSQ.QuestionNo)+ '_'
				+ CONVERT(VARCHAR(12),(ROW_NUMBER() OVER (PARTITION BY TSQ.QuestionNo,TSS.IsFollowup ORDER BY tr.FileLibId)))
				+ CASE WHEN (TR.SongId IS NULL OR TR.SongId = 0) THEN '_1~#|' ELSE 
				+ CASE WHEN TSS.IsFollowup = 'True' THEN '_1' ELSE '' END +'~' 
				+ CONVERT(VARCHAR(12),CASE WHEN TR.AnswerId NOT IN(1,2,3,4,5,6) THEN TR.SrNo ELSE TR.AnswerId END)+'|' END AS TXT, 			
				TSQ.QuestionNo, Tr.FileLibId AS SongId
			FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
			INNER JOIN
			(
				SELECT TSS.QuestionId,'False' AS IsFollowup
				FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
				INNER JOIN DBO.TR_QuestionSettings TSS WITH(NOLOCK)
					ON TSS.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
					AND TSS.SettingId = 4 AND TSS.Value = 'True'
					 	
				UNION
				
				SELECT TSS.QuestionId,'True' AS IsFollowup
				FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
				INNER JOIN DBO.TR_QuestionSettings TSS WITH(NOLOCK)
					ON TSS.QuestionId = TSQ.QuestionId AND TSQ.SurveyId = @SurveyId
					AND TSS.SettingId = 21 AND TSS.Value = 'True'
			) TSS 
				ON TSQ.QuestionId = TSS.QuestionId
			LEFT OUTER JOIN
			(
				SELECT 
					TA.SrNo, ISNULL(TA.AnswerId,T.AnswerId) AS AnswerId, T.SongId,
					ISNULL(TA.QuestionId,T.QuestionId) AS QuestionId, T.SessionId, T.[Status], T.AnswerText,
					T.RespondentId,T.FileLibId
				FROM 
				(
					SELECT 
						TR.SongId, RS.QuestionId, TR.RespondentId, TR.[Status], TR.AnswerText, TR.SessionId,
						TR.AnswerId, RS.SongId AS FileLibId
					FROM @RespondentSongs RS 
					LEFT JOIN 
					(
						SELECT * FROM DBO.TR_Responses WITH(NOLOCK) WHERE RespondentId = @RespondentId
					) TR 
						ON RS.QuestionId = TR.QuestionId AND TR.SongId = RS.SongId
				) T
				LEFT JOIN 
				(
					SELECT TA.*, ROW_NUMBER() OVER(PARTITION BY TA.QuestionId ORDER BY AnswerId) AS SrNo 
					FROM DBO.TR_SurveyQuestions TSQ WITH(NOLOCK)  
					INNER JOIN DBO.TR_SurveyAnswers TA WITH(NOLOCK) 
						ON TSQ.QuestionId = TA.QuestionId AND TSQ.SurveyId = @SurveyId
				) TA
					ON T.QuestionId = TA.QuestionId  AND TA.AnswerId = T.AnswerId
			) TR
				ON TSQ.QuestionId = TR.QuestionId		
		) A
		ORDER BY QuestionNo ASC, SongId ASC
	END
	 
	SELECT @AnswerId = COALESCE(@AnswerId,'','') +Txt FROM @Test  

	RETURN LEFT(@AnswerId,LEN(@AnswerId)-1)
END


