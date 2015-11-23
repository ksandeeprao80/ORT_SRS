-- NOTE : After Country,State,City Inserted following script has to check and run step by step 
-- No Direct execution

SELECT * INTO DBO.MS_Country_Backup_20130214 FROM MS_Country
SELECT * INTO DBO.MS_State_Backup_20130214 FROM MS_State
SELECT * INTO DBO.MS_City_Backup_20130214 FROM MS_City
SELECT * INTO DBO.MS_Customers_Backup_20130214 FROM MS_Customers

UPDATE MS_Customers SET Country = NULL,State = NULL, City = NULL

ALTER TABLE MS_City DROP CONSTRAINT FK_MS_City_MS_State
TRUNCATE TABLE MS_City
ALTER TABLE MS_State DROP CONSTRAINT FK_MS_State_MS_Country
TRUNCATE TABLE MS_State
TRUNCATE TABLE MS_Country


SET IDENTITY_INSERT MS_Country ON
INSERT INTO MS_Country
(CountryId, CountryCode, CountryName)
SELECT CountryId, CountryCode, CountryName FROM TempCountry
SET IDENTITY_INSERT MS_Country OFF

SET IDENTITY_INSERT MS_State ON
INSERT INTO MS_State
(StateId, StateCode, StateName, CountryId)
SELECT StateId, StateCode, StateName, CountryId FROM TempState
SET IDENTITY_INSERT MS_State OFF

SET IDENTITY_INSERT MS_City ON
INSERT INTO MS_City
(CityId, CityCode, CityName, StateId)
SELECT CityId, CityCode, CityName, StateId FROM TempCity
SET IDENTITY_INSERT MS_City OFF


--SELECT 
--	DISTINCT MCC.Country,mcb.CountryName, MCC.State, MSB.StateName, MCC.City, mcbc.CityName,
--	CASE WHEN mcb.CountryName = 'India' THEN 113 
--				   WHEN mcb.CountryName IN('UNITED STATES OF AMERICA','U.S.') THEN 254
--				   ELSE 43 END CountryId,
--	CASE WHEN mcb.CountryName = 'India' THEN 2182 
--				   WHEN mcb.CountryName IN('UNITED STATES OF AMERICA','U.S.') THEN 122
--				   ELSE 35 END StateId,
--	CASE WHEN mcb.CountryName = 'India' THEN 6457 
--				   WHEN mcb.CountryName IN('UNITED STATES OF AMERICA','U.S.') THEN 6836
--				   ELSE 41794 END CityId
UPDATE MC
SET MC.Country = CASE WHEN mcb.CountryName = 'India' THEN 113 
				   WHEN mcb.CountryName IN('UNITED STATES OF AMERICA','U.S.') THEN 254
				   ELSE 43 END,
	MC.State = 	CASE WHEN mcb.CountryName = 'India' THEN 2182 
				   WHEN mcb.CountryName IN('UNITED STATES OF AMERICA','U.S.') THEN 122
				   ELSE 35 END,	
	MC.City = 	CASE WHEN mcb.CountryName = 'India' THEN 6457 
				   WHEN mcb.CountryName IN('UNITED STATES OF AMERICA','U.S.') THEN 6836
				   ELSE 41794 END
FROM MS_Customers MC
INNER JOIN MS_Customers_Backup_20130214 MCC
ON MC.CustomerId = MCC.CustomerId
INNER JOIN MS_Country_Backup_20130214 MCB
ON MCC.Country = MCB.CountryId 
INNER JOIN MS_State_Backup_20130214 MSB
ON MCC.State = MSB.StateId 
INNER JOIN MS_City_Backup_20130214 MCBC
ON MCC.City = MCBC.CityId 

--'India'
--CountryId = 113, StateId=2182, CityId = 6457
--'United States'
--CountryId = 254, StateId=122, CityId = 6836
--'Canada'
--CountryId = 43, StateId=35, CityId = 41794
 
--select  * from TempCity WHERE cityId in(6457,6836,41794)
 
ALTER TABLE MS_State ADD CONSTRAINT FK_MS_State_MS_Country FOREIGN KEY (CountryId) REFERENCES MS_Country(CountryId) 
ALTER TABLE MS_City ADD CONSTRAINT FK_MS_City_MS_State FOREIGN KEY (StateId) REFERENCES MS_State(StateId)  

--ALTER TABLE MS_State ADD DROP CONSTRAINT FK_MS_State_MS_Country
--ALTER TABLE MS_City DROP CONSTRAINT FK_MS_City_MS_State
 