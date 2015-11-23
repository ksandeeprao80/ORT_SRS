IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetMessageType]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetMessageType]

GO

-- EXEC UspGetMessageType 4
-- EXEC UspGetMessageType 
CREATE PROCEDURE DBO.UspGetMessageType
	@MessageTypeId INT = NULL
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT  
		MessageTypeId, ISNULL(MessageTypeName,'') AS MessageTypeName
	FROM DBO.MS_MessageType WITH(NOLOCK)
	WHERE MessageTypeId = ISNULL(@MessageTypeId,MessageTypeId)

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
