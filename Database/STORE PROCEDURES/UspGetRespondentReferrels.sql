IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetRespondentReferrels]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetRespondentReferrels]

GO
/*
-- EXEC UspGetRespondentReferrels 1
*/
CREATE PROCEDURE DBO.UspGetRespondentReferrels
	@CustomerId INT 
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT  
		TRR.RowId, TRR.RespondentId, TRR.SurveyId, TRR.RefName, TRR.RefMail, TRR.RefPhoneNo, TRR.CreatedDate
	FROM DBO.TR_RespondentReferrels TRR
	INNER JOIN dbo.MS_Respondent MR
		ON TRR.RespondentId = MR.RespondentId
		AND MR.CustomerId = @CustomerId
	
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END 
	
	