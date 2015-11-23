IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetGraphicCategory]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetGraphicCategory]

GO
/*
EXEC UspGetGraphicCategory @LibId='307',@TypeName='Graphic',@CustomerId='1',@XmlUserInfo='<?xml version="1.0" encoding="utf-16"?>
<User>
  <UserId>5</UserId>
  <UserName>Nilesh More</UserName>
  <UserDetails>
    <IsActive>false</IsActive>
    <Customer>
      <CustomerId>1</CustomerId>
      <IsActive>false</IsActive>
    </Customer>
    <UserRole>
      <RoleId>2</RoleId>
      <RoleDesc>SRS Admin</RoleDesc>
      <Hierarchy>1</Hierarchy>
    </UserRole>
  </UserDetails>
</User>'

*/
CREATE PROCEDURE DBO.UspGetGraphicCategory
	@LibId INT = NULL,
	@TypeName VARCHAR(100),
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

	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SA','GU','SU'))
	BEGIN
 		SELECT 
			TLC.CategoryId, TLC.CategoryName, TLC.LibId, ISNULL(TLC.CategoryDescription,'') AS  CategoryDescription, 
			ISNULL(TGF.NoOfFiles,0) AS NoOfFiles, TLC.CreatedBy, TLC.CreatedOn, TLC.ModifiedBy, TLC.ModifiedOn
		FROM DBO.TR_LibraryCategory TLC  
		INNER JOIN DBO.TR_Library TL
			ON TLC.LibId = TL.LibId
 			AND TLC.LibId = ISNULL(@LibId,TLC.LibId)
 		INNER JOIN @UserInfo UI
			ON TL.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TL.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
		INNER JOIN DBO.MS_LibraryType MLT
			ON TL.LibTypeId = MLT.LibTypeId
			AND LTRIM(RTRIM(MLT.TypeName)) = LTRIM(RTRIM(@TypeName))
		LEFT OUTER JOIN
		(
			SELECT 
				TGF1.CategoryId, TGF1.CustomerId, TGF1.LibId, ISNULL(COUNT(1),0) AS NoOfFiles
			FROM dbo.TR_GraphicFiles TGF1
			INNER JOIN @UserInfo UI
				ON TGF1.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TGF1.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
	 		WHERE TGF1.LibId = ISNULL(@LibId,TGF1.LibId) 
			GROUP BY TGF1.LibId, TGF1.CategoryId, TGF1.CustomerId
		) TGF
			ON TLC.LibId = TGF.LibId
			AND TL.CustomerId = TGF.CustomerId
			AND TLC.CategoryId = TGF.CategoryId
	END
	ELSE
	BEGIN
		SELECT 0 AS RetValue, 'Access Denied' AS Remark
	END
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END