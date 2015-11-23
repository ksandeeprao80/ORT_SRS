IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspCopyPlayList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspCopyPlayList

GO

--EXEC UspCopyPlayList 

CREATE PROCEDURE DBO.UspCopyPlayList
	@PlayListId INT,
	@PlayListName VARCHAR(150)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @NewPlayListId INT
	SET @NewPlayListId = 0
	
	INSERT INTO dbo.MS_PlayList
	(PlayListName, IsActive, CustomerId, CreatedBy, CreatedOn)
	SELECT 
		@PlayListName, 1, CustomerId, CreatedBy, GETDATE()
	FROM dbo.MS_PlayList WHERE PlayListId = @PlayListId 	

	SET @NewPlayListId = @@IDENTITY
	
	INSERT INTO DBO.TR_PlayList
	(PlayListId, FileLibId)
	SELECT 
		@NewPlayListId, FileLibId
	FROM DBO.TR_PlayList WHERE PlayListId = @PlayListId 
		
	SELECT CASE WHEN @NewPlayListId = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN @NewPlayListId = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark,
			@NewPlayListId AS PlayListId

	COMMIT TRAN
	
END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END



