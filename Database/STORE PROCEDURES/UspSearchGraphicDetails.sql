IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchGraphicDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchGraphicDetails]

GO
-- EXEC UspSearchGraphicDetails 12,3
 
CREATE PROCEDURE DBO.UspSearchGraphicDetails
	@LibId INT,
	@CategoryId INT = NULL,
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
	
	IF EXISTS(SELECT 1 FROM @UserInfo WHERE RoleDesc IN('SU','GU','SA'))
	BEGIN
		SELECT 
			TGF.GraphicFileId, TGF.LibId, TGF.CategoryId, TGF.GraphicFileName, TGF.Extension,
			TGF.FilePath, TGF.CustomerId, ISNULL(COUNT(1),0) AS NoOfFiles
		FROM dbo.TR_GraphicFiles TGF
		INNER JOIN DBO.TR_Library TL 
			ON TGF.LibId = TL.LibId
 		INNER JOIN @UserInfo UI
			ON TL.CustomerId = (CASE WHEN UI.RoleDesc = 'SA' THEN TL.CustomerId ELSE CONVERT(INT,UI.CustomerId) END)
			AND TGF.LibId = @LibId
			AND TGF.CategoryId = ISNULL(@CategoryId,TGF.CategoryId)
		GROUP BY TGF.GraphicFileId,TGF.LibId, TGF.CategoryId, TGF.GraphicFileName, TGF.Extension, TGF.FilePath, TGF.CustomerId
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



