IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteTempRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteTempRespondent]
GO

--EXEC UspDeleteTempRespondent

CREATE PROCEDURE DBO.UspDeleteTempRespondent
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	TRUNCATE TABLE DBO.TempRespondent

	SELECT 1 AS RetValue, 'Truncate Transaction Completed' AS Remark

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

