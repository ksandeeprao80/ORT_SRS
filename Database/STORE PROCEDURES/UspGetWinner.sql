IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetWinner]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetWinner]

GO
-- EXEC UspGetWinner 1158 
CREATE PROCEDURE DBO.UspGetWinner
	@SurveyId INT
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		TW_Id, SurveyId, RespondentIdentity, RespondentRef, RespondentType, CreatedDate 
	FROM DBO.TR_Winner
 	WHERE SurveyId = @SurveyId
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END