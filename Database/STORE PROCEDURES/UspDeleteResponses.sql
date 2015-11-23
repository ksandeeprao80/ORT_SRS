IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteResponses]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteResponses]
GO
-- SELECT * FROM DBO.TR_Responses WHERE RespondentId = 0 AND sessionid = 'abc'
-- EXEC UspDeleteResponses 0,'abc'
CREATE PROCEDURE DBO.UspDeleteResponses
	@RespondentId INT,
	@SessionId VARCHAR(100)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DELETE FROM DBO.TR_Responses WHERE RespondentId = @RespondentId AND LTRIM(RTRIM(SessionId)) = LTRIM(RTRIM(@SessionId))
	
	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
