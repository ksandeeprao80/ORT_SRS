--SELECT * FROM TR_InviteDetails 
UPDATE TR_InviteDetails 
SET ReminderSentDate = GETDATE() 
WHERE CONVERT(VARCHAR(10),SentDate,121) <= CONVERT(VARCHAR(10),GETDATE(),121) 