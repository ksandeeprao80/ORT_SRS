ALTER TABLE DBO.MS_Users ADD PasswordRequested CHAR(1), LinkKey VARCHAR(100)

GO

UPDATE DBO.MS_Users SET PasswordRequested = 'N'

 