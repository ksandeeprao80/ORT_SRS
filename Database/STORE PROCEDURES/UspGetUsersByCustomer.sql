IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetUsersByCustomer]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetUsersByCustomer]

GO
-- EXEC UspGetUsersByCustomer 54
-- EXEC UspGetUsersByCustomer 1 
CREATE PROCEDURE DBO.UspGetUsersByCustomer
	@CustomerId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		MU.UserId, ISNULL(MU.UserName,'') AS UserName, ISNULL(MU.UserPassword,'') AS UserPassword, 
		ISNULL(MU.CustomerId,0) AS CustomerId, ISNULL(MU.EmailId,'') AS EmailId, ISNULL(MU.IsActive,0) AS IsActive, 
		MR.RoleId, ISNULL(MR.RoleDescription,'') AS UserType, ML.LanguageId, ISNULL(MU.LangauageName,'') AS LangauageName, 
		MTZ.TimeZoneId, ISNULL(MTZ.TimeZone,'') AS TimeZone, ISNULL(MU.Phone1,'') AS Phone1, 
		ISNULL(MU.Phone2,'') AS Phone2, ISNULL(MU.Phone3,'') AS Phone3, ISNULL(MU.UserCode,'') AS UserCode, 
		MU.LoginId, ISNULL(MU.Department,'') AS Department, MU.CreatedBy, CONVERT(VARCHAR(10),MU.CreatedOn,121) AS CreatedOn,
		ISNULL(MU.ModifiedBy,0) AS ModifiedBy, 
		CASE WHEN ISNULL(MU.ModifiedOn,'') <> '' THEN CONVERT(VARCHAR(25),MU.ModifiedOn,121) ELSE '' END AS ModifiedOn,
		MR.Hierarchy, MR.OpenAccess
	FROM DBO.MS_Users MU 
	INNER JOIN DBO.MS_Roles MR
		ON MU.UserType = MR.RoleType	
		AND MU.CustomerId = @CustomerId
		AND MU.IsActive = 1
	LEFT OUTER JOIN DBO.MS_Languages ML
		ON LTRIM(RTRIM(MU.LangauageName)) = LTRIM(RTRIM(ML.LangauageName)) 
	LEFT OUTER JOIN DBO.MS_TimeZone MTZ
		ON MU.TimeZone = MTZ.TimeZoneId
	ORDER BY MR.Hierarchy

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

