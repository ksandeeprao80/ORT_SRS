IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetQuotaType]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetQuotaType]

GO
--EXEC UspGetQuotaType 2
--EXEC UspGetQuotaType 
CREATE PROCEDURE DBO.UspGetQuotaType
	@QuotaId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT  
		QuotaId, ISNULL(QuotaName,'') AS QuotaName
	FROM DBO.MS_QuotaType WITH(NOLOCK)
	WHERE QuotaId = ISNULL(@QuotaId,QuotaId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END