 UPDATE MS_Respondent
 SET Gender = CASE WHEN LEFT(Gender,1)='M' THEN 'male'
				   WHEN LEFT(Gender,1)='F' THEN 'female' ELSE Gender END 