IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteTempSoundClipInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteTempSoundClipInfo]
GO

--EXEC UspDeleteTempSoundClipInfo

CREATE PROCEDURE DBO.UspDeleteTempSoundClipInfo
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	TRUNCATE TABLE DBO.TempSoundClipInfo

	SELECT 1 AS RetValue, 'Truncate Transaction Completed' AS Remark

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

