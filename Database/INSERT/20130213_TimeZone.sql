-- Backup 
SELECT * INTO DBO.MS_TimeZone_Backup_20130213 FROM MS_TimeZone
SELECT * INTO DBO.MS_Users_Backup_20130213 FROM MS_Users
-------------------------------------------------------------
-- Data inserted in Temp Table
CREATE TABLE #TimeZone
(TimeZone VARCHAR(20), LocationName VARCHAR(150))
INSERT INTO #TimeZone
(LocationName)
SELECT '(GMT -12:00) Eniwetok, Kwajalein' UNION
SELECT '(GMT -11:00) Midway Island, Samoa' UNION
SELECT '(GMT -10:00) Hawaii' UNION
SELECT '(GMT -9:00) Alaska' UNION
SELECT '(GMT -8:00) Pacific Time (US & Canada)' UNION
SELECT '(GMT -7:00) Mountain Time (US & Canada)' UNION
SELECT '(GMT -6:00) Central Time (US & Canada), Mexico City' UNION
SELECT '(GMT -5:00) Eastern Time (US & Canada), Bogota, Lima' UNION
SELECT '(GMT -4:00) Atlantic Time (Canada), Caracas, La Paz' UNION
SELECT '(GMT -3:30) Newfoundland' UNION
SELECT '(GMT -3:00) Brazil, Buenos Aires, Georgetown' UNION
SELECT '(GMT -2:00) Mid-Atlantic' UNION
SELECT '(GMT -1:00 hour) Azores, Cape Verde Islands' UNION
SELECT '(GMT) Western Europe Time, London, Lisbon, Casablanca' UNION
SELECT '(GMT +1:00 hour) Brussels, Copenhagen, Madrid, Paris' UNION
SELECT '(GMT +2:00) Kaliningrad, South Africa' UNION
SELECT '(GMT +3:00) Baghdad, Riyadh, Moscow, St. Petersburg' UNION
SELECT '(GMT +3:30) Tehran' UNION
SELECT '(GMT +4:00) Abu Dhabi, Muscat, Baku, Tbilisi' UNION
SELECT '(GMT +4:30) Kabul' UNION
SELECT '(GMT +5:00) Ekaterinburg, Islamabad, Karachi, Tashkent' UNION
SELECT '(GMT +5:30) Bombay, Calcutta, Madras, New Delhi' UNION
SELECT '(GMT +5:45) Kathmandu' UNION
SELECT '(GMT +6:00) Almaty, Dhaka, Colombo' UNION
SELECT '(GMT +7:00) Bangkok, Hanoi, Jakarta' UNION
SELECT '(GMT +8:00) Beijing, Perth, Singapore, Hong Kong' UNION
SELECT '(GMT +9:00) Tokyo, Seoul, Osaka, Sapporo, Yakutsk' UNION
SELECT '(GMT +9:30) Adelaide, Darwin' UNION
SELECT '(GMT +10:00) Eastern Australia, Guam, Vladivostok' UNION
SELECT '(GMT +11:00) Magadan, Solomon Islands, New Caledonia' UNION
SELECT '(GMT +12:00) Auckland, Wellington, Fiji, Kamchatka'  

UPDATE #TimeZone
SET TimeZone = REPLACE(REPLACE(SUBSTRING(LocationName,1,CHARINDEX(')',LocationName)),'(',''),')','') 

--SELECT * FROM #TimeZone
-- Main table trucated

TRUNCATE TABLE MS_TimeZone

-- Table Inserted in Main Table
INSERT INTO DBO.MS_TimeZone
(TimeZone, LocationName)
SELECT TimeZone, LocationName FROM #TimeZone

--SELECT * FROM MS_TimeZone where locationname like '%eastern%'

------------END OF TIME ZONE--------------------------------------------------

UPDATE DBO.MS_Users SET TimeZone = NULL

ALTER TABLE DBO.MS_Users ALTER COLUMN TimeZone INT NULL

DECLARE @TimeZoneId INT
SELECT @TimeZoneId = TimeZoneId FROM MS_TimeZone WHERE LTRIM(RTRIM(LocationName)) = '(GMT -5:00) Eastern Time (US & Canada), Bogota, Lima'

UPDATE DBO.MS_Users SET TimeZone = @TimeZoneId -- (GMT -5:00) Eastern Time (US & Canada), Bogota, Lima



 
 
