DECLARE @UserId INT
SELECT @UserId = (SELECT TOP 1 UserId FROM MS_Users WHERE IsActive = 1)

UPDATE DBO.TR_QuestionLibrary SET CreatedBy = @UserId WHERE ISNULL(CreatedBy,0)= 0 
GO

ALTER TABLE DBO.TR_QuestionLibrary ALTER COLUMN QuestionLibName VARCHAR(150) NULL
ALTER TABLE DBO.TR_QuestionLibrary ALTER COLUMN Category VARCHAR(150) NULL
ALTER TABLE DBO.TR_QuestionLibrary ALTER COLUMN CreatedBy INT NOT NULL
GO

ALTER TABLE DBO.TR_QuestionLibrary ADD CategoryId INT, QuestionTypeId INT, QuestionText VARCHAR(2000)