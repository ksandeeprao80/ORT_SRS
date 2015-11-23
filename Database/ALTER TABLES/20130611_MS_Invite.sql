ALTER TABLE DBO.MS_Invite ADD CreatedOn DATETIME

UPDATE MS_Invite SET CreatedOn = ToBeSentDate
