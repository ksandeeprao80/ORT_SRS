ALTER TABLE DBO.MS_PanelMembers DROP FK_MS_Panel_Members_MS_Respondent
GO
ALTER TABLE DBO.MS_PanelMembers DROP COLUMN RespondentId
GO
ALTER TABLE DBO.MS_PanelMembers ADD Category VARCHAR(50), LastUsed DATETIME, IsActive INT
GO
ALTER TABLE DBO.MS_Respondent ADD RespondentCode VARCHAR(20), EmailId VARCHAR(50), PanelistId INT, IsActive INT, IsDeleted INT
