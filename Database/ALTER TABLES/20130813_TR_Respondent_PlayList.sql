ALTER TABLE DBO.TR_Respondent_PlayList ADD RespondentId INT

GO

UPDATE A
SET A.RespondentId = ISNULL(B.RespondentId,0)
FROM DBO.TR_Respondent_PlayList A
LEFT JOIN
(
	SELECT 
		DISTINCT A.SessionId, B.RespondentId 
	FROM DBO.TR_Respondent_PlayList A
	INNER JOIN DBO.TR_Responses B 
	ON A.SessionId = B.SessionId
) B
	ON A.SessionId = B.SessionId
	
 
 