-- Check Foreing Key Name that apply -- only questionid constraint will remain as it is
ALTER TABLE TR_EmailTrigger DROP FK_TR_Email_Trigger_TR_Message_Library
GO
ALTER TABLE TR_EmailTrigger DROP FK_TR_Email_Trigger_TR_Email_Details
GO
ALTER TABLE TR_EmailTrigger ALTER COLUMN FalseAction VARCHAR(250) NULL