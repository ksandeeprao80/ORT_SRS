IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetCompanyMaster]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetCompanyMaster]

GO

--EXEC UspGetCompanyMaster  
CREATE PROCEDURE DBO.UspGetCompanyMaster
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		MC.CustomerId, ISNULL(MC.CustomerName,'') AS CustomerName,
		ISNULL(MC.Abbreviation,'') AS Abbreviation,
		ISNULL(MC.ContactPerson,'') AS ContactPerson,
		ISNULL(MC.Address1,'') AS Address1,
		ISNULL(MC.Address2,'') AS Address2,
		ISNULL(MC.ZipCode,'') AS ZipCode,
		ISNULL(MC.City,'') AS City,
		ISNULL(MCT.CityName,'') AS CityName,
		ISNULL(MC.[State],'') AS [State],
		ISNULL(MC.Country,'') AS Country,
		ISNULL(MC.Phone1,'') AS Phone1,
		ISNULL(MC.Phone2,'') AS Phone2,
		ISNULL(MC.Email,'') AS Email,
		ISNULL(MC.Website,'') AS Website,
		CASE WHEN MC.IsActive = 1 THEN 'True' ELSE 'False' END AS [Status],
		MC.CreatedBy, CONVERT(VARCHAR(10),MC.CreatedOn,121) AS CreatedOn,  
		ISNULL(MC.ModifiedBy,0) AS ModifiedBy,
		CASE WHEN ISNULL(MC.ModifiedOn,'') <> '' THEN CONVERT(VARCHAR(10),MC.ModifiedOn,121) ELSE '' END AS ModifiedOn
 	FROM DBO.MS_Customers MC 
 	LEFT OUTER JOIN DBO.MS_City MCT
 		ON MC.City = MCT.CityId
	WHERE MC.IsActive = 1
	ORDER BY MC.CustomerName

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END



