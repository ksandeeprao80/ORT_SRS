IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSearchRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSearchRespondent]

GO
--EXEC UspSearchRespondent 1,NULL
--EXEC UspSearchRespondent NULL,'jhonny@gmail.com'
--EXEC UspSearchRespondent @PanelistId='80',@EmailId= ''
CREATE PROCEDURE DBO.UspSearchRespondent
	@PanelistId INT = NULL,
	@EmailId VARCHAR(50) = NULL
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
BEGIN TRY

	IF @EmailId = ''
	SET @EmailId = NULL

	SELECT 
		MR.RespondentId, MR.CustomerId, LTRIM(RTRIM(MR.RespondentCode)) AS RespondentCode, 
		MR.EmailId, MR.PanelistId, MR.IsActive, MR.IsDeleted, MR.FirstName, MR.LastName,
		CASE WHEN MR.BirthDate IN('1900-01-01','1-1-1990') THEN ''
			 WHEN ISNULL(MR.BirthDate,'') = '' THEN ''
			 WHEN ISDATE(MR.BirthDate) = 1 THEN CONVERT(VARCHAR(10),CONVERT(DATETIME,BirthDate),101)
			 ELSE MR.BirthDate END AS BirthDate,
		MR.Gender, MR.Town, MR.UDF1, MR.UDF2, MR.UDF3, MR.UDF4, MR.UDF5, MR.CreatedBy, MR.CreatedOn, 
		MR.ModifiedBy, MR.ModifiedOn, MR.Age, MPM.PanelistName
	FROM DBO.MS_Respondent MR
	INNER JOIN DBO.MS_PanelMembers MPM
		ON MR.PanelistId = MPM.PanelistId
	WHERE MR.PanelistId = ISNULL(@PanelistId,MR.PanelistId)
		AND MR.EmailId = ISNULL(@EmailId,MR.EmailId)
		AND MR.IsDeleted = 1

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END
