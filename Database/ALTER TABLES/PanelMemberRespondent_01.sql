UPDATE MS_PanelMembers SET Category = 'Quick Send', LastUsed = GETDATE(), IsActive = 1
GO
UPDATE MS_Respondent 
SET RespondentCode = 'Res'+CONVERT(VARCHAR(12),RespondentId),
    EmailId = LOWER(RespondentName)+'@gmail.com',
    PanelistId = CASE WHEN RespondentId IN(1,2,3,4) THEN 1
				  WHEN RespondentId IN(5,6,7) THEN 2 
				  WHEN RespondentId IN(8,9,10) THEN 3
				  WHEN RespondentId IN(11) THEN 4 ELSE 1 END,
    IsActive = CASE WHEN RespondentId IN(1,2,3,4,5,6,7,8,9,10,11) THEN 1 ELSE 0 END,
    IsDeleted = CASE WHEN RespondentId IN(1,2,3,4,5,6,7,8,9,10,11) THEN 1 ELSE 0 END