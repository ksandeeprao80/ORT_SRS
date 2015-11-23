DECLARE @CanadaId INT
SET @CanadaId = 0

-- Country -- CANADA
	INSERT INTO DBO.MS_Country
	(CountryCode,CountryName)
	VALUES ('CA','CANADA')
	
	SET @CanadaId = @@IDENTITY
--State :
	INSERT INTO DBO.MS_State
	(StateCode,StateName,CountryId)
	SELECT 'AB','Alberta',@CanadaId UNION 
	SELECT 'BC','British Columbia',@CanadaId UNION  
	SELECT 'MB','Manitoba',@CanadaId UNION 
	SELECT 'NB','New Brunswick',@CanadaId UNION  
	SELECT 'NF','Newfoundland',@CanadaId UNION  
	SELECT 'NT','Northwest Territory',@CanadaId UNION 
	SELECT 'NS','Nova Scotia',@CanadaId UNION 
	SELECT 'ON','Ontario',@CanadaId UNION 
	SELECT 'PE','Prince Edwards Island',@CanadaId UNION 
	SELECT 'PO','Quebec',@CanadaId UNION 
	SELECT 'SK','Saskatchewan',@CanadaId UNION 
	SELECT 'YT','Yukon',@CanadaId 

-- City

	--AB-Alberta
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Airdrie',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Brooks',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Camrose',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Cold Lake',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Edmonton',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Fort Saskatchewan',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Grande Prairie',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Lacombe',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Leduc',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Lethbridge',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Lloydminster',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Medicine Hat',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Red Deer',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Spruce Grove',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','St. Albert',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'AB','Wetaskiwin',StateId FROM MS_State WHERE StateCode = 'AB' AND StateName = 'Alberta' AND CountryId = @CanadaId

--BC-British Columbia 

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Abbotsford',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Armstrong',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Burnaby',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Campbell River',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Castlegar',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Chilliwack',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Colwood',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Coquitlam',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Courtenay',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Cranbrook',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Dawson Creek',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Duncan',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Enderby',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Fernie',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Fort St. John',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Grand Forks',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Greenwood',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Kamloops',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Kelowna',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Kimberley',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Kitimat',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Langford',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Langley',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Merritt',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Nanaimo',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Nelson',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','New Westminster',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','North Vancouver',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Parksville',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Penticton',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Pitt Meadows',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Port Alberni',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Port Coquitlam',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Port Moody',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Powell River',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Prince George',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Prince Rupert',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Quesnel',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Revelstoke',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Richmond',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Rossland',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Salmon Arm',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Surrey',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Terrace',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Trail',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Vancouver',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Vernon',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Victoria',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','White Rock',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'BC','Williams Lake',StateId FROM MS_State WHERE StateCode = 'BC' AND StateName = 'British Columbia' AND CountryId = @CanadaId
	
	--MB-Manitoba

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Brandon',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Dauphin',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Flin Flon',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Portage la Prairie',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Selkirk',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Steinbach',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Thompson',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Winkler',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'MB','Winnipeg',StateId FROM MS_State WHERE StateCode = 'MB' AND StateName = 'Manitoba' AND CountryId = @CanadaId 
	
	--MB-New Brunswick

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NB','Bathurst',StateId FROM MS_State WHERE StateCode = 'NB' AND StateName = 'New Brunswick' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NB','Campbellton',StateId FROM MS_State WHERE StateCode = 'NB' AND StateName = 'New Brunswick' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NB','Dieppe',StateId FROM MS_State WHERE StateCode = 'NB' AND StateName = 'New Brunswick' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NB','Edmundston',StateId FROM MS_State WHERE StateCode = 'NB' AND StateName = 'New Brunswick' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NB','Fredericton',StateId FROM MS_State WHERE StateCode = 'NB' AND StateName = 'New Brunswick' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NB','Miramichi',StateId FROM MS_State WHERE StateCode = 'NB' AND StateName = 'New Brunswick' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NB','Moncton',StateId FROM MS_State WHERE StateCode = 'NB' AND StateName = 'New Brunswick' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NB','Saint John',StateId FROM MS_State WHERE StateCode = 'NB' AND StateName = 'New Brunswick' AND CountryId = @CanadaId 
	
	--NF-Newfoundland and Labrador

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NF','Corner Brook',StateId FROM MS_State WHERE StateCode = 'NF' AND StateName = 'Newfoundland and Labrador' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NF','Mount Pearl',StateId FROM MS_State WHERE StateCode = 'NF' AND StateName = 'Newfoundland and Labrador' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NF','St. John''s',StateId FROM MS_State WHERE StateCode = 'NF' AND StateName = 'Newfoundland and Labrador' AND CountryId = @CanadaId 

	--NT-Northwest Territory

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NT','Yellowknife',StateId FROM MS_State WHERE StateCode = 'NT' AND StateName = 'Northwest Territory' AND CountryId = @CanadaId 
	
	--NS-Nova Scotia

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'NS','Halifax',StateId FROM MS_State WHERE StateCode = 'NS' AND StateName = 'Nova Scotia' AND CountryId = @CanadaId 
	
	--ON-Ontario

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Barrie',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Belleville',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Brampton',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Brant',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Brantford',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Brockville',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Burlington',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Cambridge',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Chatham-Kent',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Clarence-Rockland',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Cornwall',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Dryden',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Elliot Lake',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Greater Sudbury',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Guelph',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Haldimand County',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Hamilton',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Kawartha Lakes',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Kenora',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Kingston',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Kitchener',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','London',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Markham',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Mississauga',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Niagara Falls',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Norfolk County',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','North Bay',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Orillia',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Oshawa',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Ottawa',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Owen Sound',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Pembroke',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Peterborough',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Pickering',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Prince Edward County',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Port Colborne',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Quinte West',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Sarnia',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Sault Ste. Marie',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','St. Catharines',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','St. Thomas',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Stratford',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Temiskaming Shores',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Thorold',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Thunder Bay',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Timmins',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Toronto',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Vaughan',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Waterloo',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Welland',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Windsor',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'ON','Woodstock',StateId FROM MS_State WHERE StateCode = 'ON' AND StateName = 'Ontario' AND CountryId = @CanadaId 


	--PE-Prince Edwards Island

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PE','Charlottetown',StateId FROM MS_State WHERE StateCode = 'PE' AND StateName = 'Prince Edwards Island' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PE','Summerside',StateId FROM MS_State WHERE StateCode = 'PE' AND StateName = 'Prince Edwards Island' AND CountryId = @CanadaId 

	--PO-Quebec
	
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Acton Vale',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Alma',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Amos',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Amqui',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Asbestos',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Baie-Comeau',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Baie-d''Urfé',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Baie-Saint-Paul',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Barkmere',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Beaconsfield',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Beauceville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Beauharnois',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Beaupré',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Bécancour',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Bedford',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Belleterre',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Beloeil',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Berthierville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Blainville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Bois-des-Filion',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Boisbriand',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Bonaventure',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Boucherville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Brome Lake (Lac-Brome)',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Bromont',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Brossard',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Brownsburg-Chatham',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Candiac',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Cap-Chat',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Cap-Santé',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Carignan',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Carleton-sur-Mer',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Causapscal',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Chambly',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Chandler',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Chapais',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Charlemagne',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Châteauguay',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Château-Richer',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Chibougamau',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Clermont',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Coaticook',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Contrecoeur',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Cookshire-Eaton',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Côte Saint-Luc (Côte-Saint-Luc)',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Coteau-du-Lac',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Cowansville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Danville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Daveluyville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Dégelis',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Delson',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Desbiens',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Deux-Montagnes',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Disraeli',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Dolbeau-Mistassini',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Dollard-des-Ormeaux',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Donnacona',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Dorval',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Drummondville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Dunham',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Duparquet',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','East Angus',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Estérel',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Farnham',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Fermont',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Forestville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Fossambault-sur-le-Lac',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Gaspé',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Gatineau',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Gracefield',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Granby',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Grande-Rivière',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Hampstead',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Hudson',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Huntingdon',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Joliette',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Kingsey Falls',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Kirkland',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','L''Ancienne-Lorette',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','L''Assomption',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','L''Épiphanie',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','L''Île-Cadieux',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','L''Île-Dorval',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','L''Île-Perrot',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','La Malbaie',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','La Pocatière',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','La Prairie',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','La Sarre',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','La Tuque',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lac-Delage',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lac-Mégantic',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lac-Saint-Joseph',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lac-Sergent',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lachute',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Laval',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lavaltrie',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lebel-sur-Quévillon',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Léry',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lévis',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Longueuil',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Lorraine',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Louiseville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Macamic',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Magog',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Malartic',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Maniwaki',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Marieville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Mascouche',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Matagami',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Matane',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Mercier',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Métabetchouan–Lac-à-la-Croix',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Métis-sur-Mer',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Mirabel',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Mont-Joli',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Mont-Laurier',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Mont-Saint-Hilaire',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Mont-Tremblant',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Montmagny',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Montreal',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Montréal-Est',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Montreal West (Montréal-Ouest)',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Mount Royal (Mont-Royal)',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Murdochville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Neuville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','New Richmond',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Nicolet',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Normandin',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Notre-Dame-de-l''Île-Perrot',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Notre-Dame-des-Prairies',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Otterburn Park',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Paspébiac',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Percé',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Pincourt',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Plessisville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Pohénégamook',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Pointe-Claire',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Pont-Rouge',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Port-Cartier',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Portneuf',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Princeville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Prévost',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Quebec City',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Repentigny',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Richelieu',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Richmond',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Rimouski',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Rivière-du-Loup',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Rivière-Rouge',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Roberval',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Rosemère',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Rouyn-Noranda',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saguenay',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Adèle',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Agathe-des-Monts',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Anne-de-Beaupré',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Anne-de-Bellevue',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Anne-des-Monts',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Anne-des-Plaines',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Augustin-de-Desmaures',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Basile',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Basile-le-Grand',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Bruno-de-Montarville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Catherine',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Catherine-de-la-Jacques-Cartier',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Césaire',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Colomban',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Constant',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Eustache',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Félicien',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Gabriel',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Georges',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Hyacinthe',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Jean-sur-Richelieu',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Jérôme',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Joseph-de-Beauce',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Joseph-de-Sorel',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Julie',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Lambert',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Lazare',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Lin–Laurentides',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Marc-des-Carrières',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Marguerite-du-Lac-Masson',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Marie',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Marthe-sur-le-Lac',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Ours',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Pamphile',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Pascal',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Pie',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Raymond',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Rémi',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Sauveur',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sainte-Thérèse',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Saint-Tite',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Salaberry-de-Valleyfield',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Schefferville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Scotstown',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Senneterre',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sept-Îles',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Shawinigan',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sherbrooke',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sorel-Tracy',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Stanstead',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Sutton',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Témiscaming',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Témiscouata-sur-le-Lac',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Terrebonne',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Thetford Mines',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Thurso',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Trois-Pistoles',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Trois-Rivières',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Val-d''Or',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Valcourt',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Varennes',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Vaudreuil-Dorion',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Victoriaville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Ville-Marie',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Warwick',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Waterloo',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Waterville',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Westmount',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'PO','Windsor',StateId FROM MS_State WHERE StateCode = 'PO' AND StateName = 'Quebec' AND CountryId = @CanadaId


	--SK-Saskatchewan
	
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Estevan',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Flin Flon',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Humboldt',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Lloydminster',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Martensville',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Meadow Lake',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Melfort',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Melville',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Moose Jaw',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','North Battleford',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Prince Albert',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Regina',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Saskatoon',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Swift Current',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Weyburn',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'SK','Yorkton',StateId FROM MS_State WHERE StateCode = 'SK' AND StateName = 'Saskatchewan' AND CountryId = @CanadaId 
	
	--YT- Yukon

	INSERT INTO DBO.MS_City (CityCode, CityName, StateId) SELECT 'YT','Whitehorse',StateId FROM MS_State WHERE StateCode = 'YT' AND StateName = 'Yukon' AND CountryId = @CanadaId 
