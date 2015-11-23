IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveMediaInfo]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveMediaInfo]

GO
-- EXEC UspSaveMediaInfo 
CREATE PROCEDURE DBO.UspSaveMediaInfo
	@QuestionId INT,
	@FileLibId INT,
	@CustomerId INT,
	@Randomize BIT,
	@AutoAdvance BIT,
	@ShowTitle BIT,
	@Autoplay BIT,
	@HideForSeconds INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	INSERT INTO DBO.TR_MediaInfo
	(		
		QuestionId, FileLibId, CustomerId, Randomize, AutoAdvance, ShowTitle, Autoplay, HideForSeconds
	)
	VALUES
	(
		@QuestionId, @FileLibId, @CustomerId, @Randomize, @AutoAdvance, @ShowTitle, @Autoplay, @HideForSeconds
 	)

	SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark 
	
	RETURN

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END