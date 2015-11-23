IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveCustomers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveCustomers]
GO
/*
EXEC UspSaveCustomers '<?xml version="1.0" encoding="utf-16"?>
<Customer>
	<CustomerId></CustomerId>
	<CustomerName>Star Movies</CustomerName>
	<Abbreviation>120</Abbreviation>
	<ContactPerson>SRS AWS TEST</ContactPerson>
	<Address1>Banglore</Address1>
	<Address2>Hubli</Address2>
	<ZipCode>215025213</ZipCode>
	<CityCode>2</CityCode>
	<StateCode>2</StateCode>
	<CountryCode>6</CountryCode>
	<Phone1>02152336447</Phone1>
	<Phone2 />
	<Email />
	<WebSite>http://www.google.com</WebSite>
	<IsActive>false</IsActive>
	<CreatedBy>
		<UserId>5</UserId>
	</CreatedBy>
	<ModifiedBy>
		<UserId>5</UserId>
	</ModifiedBy>
	<ModifiedOn>2012-09-24 13:36:26.160</ModifiedOn>
</Customer>'
*/
--select * from MS_Customers
CREATE PROCEDURE DBO.UspSaveCustomers
	@XmlData AS NTEXT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @input XML = @XmlData
	-------------------------------------------------------------------------

	CREATE TABLE #Customers
	(
		CustomerId VARCHAR(20), CustomerName VARCHAR(150), Abbreviation VARCHAR(20),
		ContactPerson VARCHAR(150), Address1 VARCHAR(150), Address2 VARCHAR(150),
		ZipCode VARCHAR(20), CityId VARCHAR(10), StateId VARCHAR(10), CountryId VARCHAR(10),
		Phone1 VARCHAR(20), Phone2 VARCHAR(20), Email VARCHAR(150), WebSite VARCHAR(150),
		IsActive VARCHAR(20), CreatedBy VARCHAR(20), ModifiedBy VARCHAR(20), ModifiedOn VARCHAR(25)
	)
	INSERT INTO #Customers
	(
		CustomerId, CustomerName, Abbreviation, ContactPerson, Address1, Address2,
		ZipCode, CityId, StateId, CountryId, Phone1, Phone2, Email, WebSite,
		IsActive, CreatedBy, ModifiedBy, ModifiedOn
	)
	SELECT
		Parent.Elm.value('(CustomerId)[1]','VARCHAR(20)') AS CustomerId,
		Parent.Elm.value('(CustomerName)[1]','VARCHAR(150)') AS CustomerName,
		Parent.Elm.value('(Abbreviation)[1]','VARCHAR(20)') AS Abbreviation,
		Parent.Elm.value('(ContactPerson)[1]','VARCHAR(150)') AS ContactPerson,
		Parent.Elm.value('(Address1)[1]','VARCHAR(150)') AS Address1,
		Parent.Elm.value('(Address2)[1]','VARCHAR(150)') AS Address2,
		Parent.Elm.value('(ZipCode)[1]','VARCHAR(20)') AS ZipCode,
		Parent.Elm.value('(CityCode)[1]','VARCHAR(10)') AS CityId,
		Parent.Elm.value('(StateCode)[1]','VARCHAR(10)') AS StateId,
		Parent.Elm.value('(CountryCode)[1]','VARCHAR(10)') AS CountryId,
		Parent.Elm.value('(Phone1)[1]','VARCHAR(20)') AS Phone1,
		Parent.Elm.value('(Phone2)[1]','VARCHAR(20)') AS Phone2,
		Parent.Elm.value('(Email)[1]','VARCHAR(150)') AS Email,
		Parent.Elm.value('(WebSite)[1]','VARCHAR(150)') AS WebSite,
		Parent.Elm.value('(IsActive)[1]','VARCHAR(20)') AS IsActive,
		Child.Elm.value('(UserId)[1]','VARCHAR(20)') AS CreatedBy,
		Child2.Elm.value('(UserId)[1]','VARCHAR(20)') AS ModifiedBy,
		Parent.Elm.value('(ModifiedOn)[1]','VARCHAR(25)') AS ModifiedOn
	--INTO #Customers
	FROM @input.nodes('/Customer') AS Parent(Elm)
	CROSS APPLY
		Parent.Elm.nodes('CreatedBy') AS Child(Elm)
	CROSS APPLY
		Parent.Elm.nodes('ModifiedBy') AS Child2(Elm)

	DECLARE @NewCustomerId INT, 
		@Count INT,
		@Remark VARCHAR(150),
		@RetValue INT
	SET @NewCustomerId = 0
	SET @Count = 0
	SET @Remark = ''
	SET @RetValue = 0

	SELECT @Count = COUNT(1) FROM #Customers WHERE ISNULL(CustomerId,'') <> ''

	IF @Count <> 0 
	BEGIN
		DECLARE @Count1 INT, 
			@ModifiedOn VARCHAR(25)
		SET @Count1 = 0

		SELECT @ModifiedOn = CONVERT(VARCHAR(25),MC.ModifiedOn,121) FROM DBO.MS_Customers MC 
			INNER JOIN #Customers C ON MC.CustomerId = CONVERT(INT,C.CustomerId)

		SELECT @Count1 = COUNT(1) FROM #Customers WHERE LTRIM(RTRIM(ModifiedOn)) = LTRIM(RTRIM(@ModifiedOn))
		IF @Count1 = 0 
		--Checking for concurrency issue
		BEGIN
			SET @Remark = 'Kindly capture the latest data'  
		END
		ELSE
		BEGIN
			UPDATE MC
			SET MC.ContactPerson = CASE WHEN ISNULL(C.ContactPerson,'') = '' THEN MC.ContactPerson ELSE LTRIM(RTRIM(C.ContactPerson)) END,
			    MC.Address1 = CASE WHEN ISNULL(C.Address1,'') = '' THEN MC.Address1 ELSE LTRIM(RTRIM(C.Address1)) END,
			    MC.Address2 = CASE WHEN ISNULL(C.Address2,'') = '' THEN MC.Address2 ELSE LTRIM(RTRIM(C.Address2)) END,
			    MC.ZipCode = CASE WHEN ISNULL(C.ZipCode,'') = '' THEN MC.ZipCode ELSE LTRIM(RTRIM(C.ZipCode)) END,
			    MC.City = CASE WHEN ISNULL(C.CityId,'') = '' THEN MC.City ELSE MCY.CityId END,
			    MC.[State] = CASE WHEN ISNULL(C.StateId,'') = '' THEN MC.[State] ELSE MS.StateId END,
			    MC.Country = CASE WHEN ISNULL(C.CountryId,'') = '' THEN MC.Country ELSE MCR.CountryId END,
			    MC.Phone1 = LTRIM(RTRIM(C.Phone1)),
			    MC.Phone2 = LTRIM(RTRIM(C.Phone2)),
			    MC.Email = CASE WHEN ISNULL(C.Email,'') = '' THEN MC.Email ELSE LTRIM(RTRIM(C.Email)) END,
			    MC.Website = CASE WHEN ISNULL(C.Website,'') = '' THEN MC.Website ELSE LTRIM(RTRIM(C.Website)) END,
			    MC.IsActive = CASE WHEN LTRIM(RTRIM(C.IsActive)) = 'FALSE' THEN 0 ELSE 1 END,
			    MC.ModifiedBy = CONVERT(INT,C.ModifiedBy),
			    MC.ModifiedOn = GETDATE() 
			FROM DBO.MS_Customers MC
			INNER JOIN #Customers C
				ON MC.CustomerId = CONVERT(INT,C.CustomerId)
			LEFT OUTER JOIN DBO.MS_Country MCR
				ON CONVERT(INT,C.CountryId) = MCR.CountryId
			LEFT OUTER JOIN DBO.MS_State MS
				ON CONVERT(INT,C.StateId) = MS.StateId
			LEFT OUTER JOIN DBO.MS_City MCY
				ON CONVERT(INT,C.CityId) = MCY.CityId
	
			SET @Remark = 'Successfully Updated'
			SET @RetValue = 1
		END
	END
	ELSE
	BEGIN
		DECLARE @Error INT
		SET @Error = 0
		
		SELECT @Error = COUNT(1) FROM DBO.MS_Customers MC 
		INNER JOIN #Customers C 
			ON LTRIM(RTRIM(MC.CustomerName)) = LTRIM(RTRIM(C.CustomerName))
			AND LTRIM(RTRIM(MC.Abbreviation)) = LTRIM(RTRIM(C.Abbreviation))
		WHERE ISNULL(C.CustomerId,'') = ''
	
		IF @Error = 0
		BEGIN
			INSERT INTO DBO.MS_Customers
			(
				CustomerName, Abbreviation, ContactPerson, Address1, Address2, ZipCode, City, [State], Country, 
				Phone1, Phone2, Email, Website, IsActive, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn
			)
			SELECT 
				LTRIM(RTRIM(C.CustomerName)) AS CustomerName, 
				LTRIM(RTRIM(C.Abbreviation)) AS Abbreviation, 
				LTRIM(RTRIM(C.ContactPerson)) AS ContactPerson, 
				LTRIM(RTRIM(C.Address1)) AS Address1, 
				LTRIM(RTRIM(C.Address2)) AS Address2, 
				LTRIM(RTRIM(C.ZipCode)) AS ZipCode, 
				MCY.CityId, MS.StateId, MCR.CountryId, 
				LTRIM(RTRIM(C.Phone1)) AS Phone1, 
				LTRIM(RTRIM(C.Phone2)) AS Phone2, 
				LTRIM(RTRIM(C.Email)) AS Email, 
				LTRIM(RTRIM(C.Website)) AS Website, 
				CASE WHEN LTRIM(RTRIM(C.IsActive)) = 'FALSE' THEN 0 ELSE 1 END,
				CONVERT(INT,C.CreatedBy), GETDATE(), CONVERT(INT,C.CreatedBy), GETDATE()
			FROM #Customers C
			INNER JOIN DBO.MS_Country MCR
				ON CONVERT(INT,C.CountryId) = MCR.CountryId
			INNER JOIN DBO.MS_State MS
				ON CONVERT(INT,C.StateId) = MS.StateId
			INNER JOIN DBO.MS_City MCY
				ON CONVERT(INT,C.CityId) = MCY.CityId
			LEFT OUTER JOIN DBO.MS_Customers MC
				ON LTRIM(RTRIM(C.CustomerName)) = LTRIM(RTRIM(MC.CustomerName))
				AND LTRIM(RTRIM(C.Abbreviation)) = LTRIM(RTRIM(MC.Abbreviation)) 
			WHERE (ISNULL(C.CustomerName,'') <> '' OR ISNULL(C.Abbreviation,'') <> '')
				AND ISNULL(MC.CustomerName,'') = ''
				AND ISNULL(MC.Abbreviation,'') = ''
		
			SET @NewCustomerId = @@IDENTITY
			SET @Remark = CASE WHEN @NewCustomerId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END
			SET @RetValue = CASE WHEN @NewCustomerId = 0 THEN 0 ELSE 1 END			
		END
		ELSE
		BEGIN
			SET @Remark = 'Same Company Name Exist, Kindly Provide Different Company Name'
		END
	END

	SELECT 
		@RetValue AS RetValue, @Remark AS Remark, 
		CASE WHEN @NewCustomerId = 0 THEN CONVERT(VARCHAR(20),CustomerId) ELSE CONVERT(VARCHAR(20),@NewCustomerId) END AS CustomerId 
	FROM #Customers 

	DROP TABLE #Customers
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END




