IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspClearPlayList]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspClearPlayList]

GO
-- EXEC UspClearPlayList '02olv0mljk5l3xfxeznbedqf'
CREATE PROCEDURE DBO.UspClearPlayList
	@SessionId VARCHAR(100),
	@SurveyId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

    DELETE FROM DBO.TR_Respondent_Playlist WHERE SessionId = @SessionId AND SurveyId = @SurveyId
    
    SELECT 1 AS RetValue, 'Successfully cleared Playlist' AS Remark 

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
