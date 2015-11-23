UPDATE DBO.MS_Respondent
SET FirstName = UPPER(LTRIM(RTRIM(REPLACE(EmailId,'@gmail.com','')))),
    LastName = UPPER(LEFT(EmailId,1)),
    BirthDate = GETDATE()-9125,
    Gender = CASE WHEN EmailId= 'sarika@gmail.com' THEN 'F' ELSE 'M' END,
    Town = 'New York'	

