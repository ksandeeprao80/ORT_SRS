TRUNCATE TABLE DBO.MS_QuestionTags

GO
SET IDENTITY_INSERT MS_QuestionTags ON

INSERT INTO MS_QuestionTags 
(QuestionTagId,TagName)
SELECT 1,'Age' UNION
SELECT 2,'DateOfBirth' UNION
SELECT 3,'Gender' UNION
SELECT 4,'FirstName' UNION
SELECT 5,'LastName' UNION
SELECT 6,'EmailId' UNION
SELECT 7,'Ethnicity' UNION
SELECT 8,'City' UNION
SELECT 9,'Region' UNION
SELECT 10,'Country'  

SET IDENTITY_INSERT MS_QuestionTags OFF
