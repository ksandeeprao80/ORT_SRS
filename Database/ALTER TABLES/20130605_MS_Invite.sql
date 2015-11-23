--SELECT * FROM DBO.MS_Invite
ALTER TABLE DBO.MS_Invite ADD ReminderSendDate DATETIME, ReminderSentTime VARCHAR(10), SendRemindedNow INT
