IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTemplatesInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTemplatesInfo]

GO

-- EXEC UspGetTemplatesInfo 1 
-- EXEC UspGetTemplatesInfo 
CREATE PROCEDURE DBO.UspGetTemplatesInfo
	@TemplateId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT MT.TemplateId, MT.TemplateName, MT.TemplateType
	FROM DBO.MS_Templates MT
	WHERE MT.IsActive = 1
	AND MT.TemplateId = ISNULL(@TemplateId,MT.TemplateId)
	
	
    SELECT TT.ItemId,TT.ItemName
    FROM DBO.MS_TemplatesItems TT
    
	
	SELECT 
		MT.TemplateId, MTI.ItemId, MA.AttributeName, 
		CASE WHEN MA.AttributeName = 'Color' THEN REPLACE(TT.Value,'#','') 
			 WHEN MA.AttributeName = 'Size' THEN REPLACE(TT.Value,'Px','')
			 ELSE TT.Value END AS Value
	FROM DBO.TR_Templates TT
	INNER JOIN DBO.MS_Templates MT
		ON TT.TemplateId = MT.TemplateId 
		AND MT.IsActive = 1
		AND TT.TemplateId = ISNULL(@TemplateId,TT.TemplateId)
	INNER JOIN DBO.MS_TemplatesItems MTI
		ON TT.ItemId = MTI.ItemId 
	INNER JOIN DBO.MS_Attributes MA
		ON TT.AttributeId = MA.AttributeId
	 
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

 