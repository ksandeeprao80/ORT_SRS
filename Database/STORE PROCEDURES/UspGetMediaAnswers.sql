IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetMediaAnswers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetMediaAnswers

GO
-- EXEC UspGetMediaAnswers NULL

CREATE PROCEDURE DBO.UspGetMediaAnswers
	@AnswerId INT = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

    SELECT  
	   AnswerId, Answer, AnswerText 
    FROM DBO.TR_MediaAnswers 
    WHERE AnswerId = ISNULL(@AnswerId,AnswerId)
    ORDER BY AnswerId

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END