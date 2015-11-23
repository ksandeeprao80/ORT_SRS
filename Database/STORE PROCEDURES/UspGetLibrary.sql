IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetLibrary]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetLibrary]

GO

-- EXEC UspGetLibrary 
CREATE PROCEDURE DBO.UspGetLibrary
	@LibId INT = NULL,
	@CustomerId INT,
	@XmlUserInfo AS NTEXT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	DECLARE @UserInfo TABLE
	(UserId VARCHAR(20), CustomerId VARCHAR(20), RoleId VARCHAR(20), RoleDesc VARCHAR(150), Hierarchy VARCHAR(20))
	INSERT INTO @UserInfo
	(UserId, CustomerId, RoleId, RoleDesc, Hierarchy)
	EXEC DBO.UspGetLogedInUserData @XmlUserInfo

	SELECT  
		TL.LibId, TL.LibTypeId, TL.LibName, TL.CustomerId, TL.IsActive, 
		TL.CreatedBy, TL.CreatedOn, TL.ModifiedBy, TL.ModifiedOn
	FROM DBO.TR_Library TL
	INNER JOIN @UserInfo UI
		ON TL.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TL.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
	WHERE TL.LibId = ISNULL(@LibId,TL.LibId)
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END