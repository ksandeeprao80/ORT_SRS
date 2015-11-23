IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetWinnerDetails]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspGetWinnerDetails

GO

-- EXEC UspGetWinnerDetails 22, NULL 
CREATE PROCEDURE DBO.UspGetWinnerDetails
	@DrawId INT,
	@EmailId VARCHAR(100) = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	SELECT 
		MR.RespondentId, MR.CustomerId, LTRIM(RTRIM(MR.RespondentCode)) AS RespondentCode, 
		MR.EmailId, MR.PanelistId, MR.IsActive, MR.IsDeleted, MR.FirstName, MR.LastName,
		MR.BirthDate, MR.Gender, MR.Town, MR.UDF1, MR.UDF2, MR.UDF3, MR.UDF4, MR.UDF5,
		MR.CreatedBy, MR.CreatedOn, MR.ModifiedBy, MR.ModifiedOn, ISNULL(MR.Age,0) AS Age,
		MPM.PanelistName
	FROM DBO.TR_Winner TW
	INNER JOIN DBO.MS_Respondent MR
		ON TW.RespondentId = MR.RespondentId
		AND TW.TW_Id = @DrawId
	INNER JOIN DBO.MS_PanelMembers MPM
		ON MR.PanelistId = MPM.PanelistId
		
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

