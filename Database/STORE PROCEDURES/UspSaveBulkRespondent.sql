IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveBulkRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveBulkRespondent
GO
CREATE PROCEDURE DBO.UspSaveBulkRespondent
	@SessionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	INSERT INTO DBO.TR_RespondentException
	(
		CustomerId, EmailId, PanelistId, FirstName, LastName, Age, BirthDate, Gender, Town, 
		UDF1, UDF2, UDF3, UDF4, UDF5, [Status], StatusMessage, SessionId, UserId
	)
	SELECT 
		CustomerId, EmailId, PanelistId, FirstName, LastName, Age, BirthDate, Gender, Town, 
		UDF1, UDF2, UDF3, UDF4, UDF5, [Status], StatusMessage, SessionId, UserId
	FROM DBO.TempRespondent
	WHERE SessionId = @SessionId
		AND [Status] = 'E'

	INSERT INTO DBO.MS_Respondent
	(
		CustomerId, EmailId, PanelistId, IsActive, IsDeleted, FirstName, LastName, Age, BirthDate, 
		Gender, Town, UDF1, UDF2, UDF3, UDF4, UDF5, CreatedBy, CreatedOn
	)
	SELECT 
		CONVERT(INT,CustomerId), EmailId, CONVERT(INT,PanelistId), 1 AS IsActive, 1 AS IsDeleted, 
		FirstName, LastName, CONVERT(INT,Age), BirthDate , 
		Gender, Town, UDF1, UDF2, UDF3, UDF4, UDF5, CONVERT(INT,UserId), GETDATE()
	FROM DBO.TempRespondent
	WHERE SessionId = @SessionId
		AND [Status] = 'O'	 

	UPDATE MR
	SET MR.RespondentCode = 'Res'+CONVERT(VARCHAR(12),MR.RespondentId)
	FROM DBO.MS_Respondent MR
	INNER JOIN DBO.TempRespondent TR
		ON MR.EmailId = TR.EmailId
	WHERE TR.SessionId = @SessionId

	DELETE FROM TempRespondent WHERE SessionId = @SessionId

	SELECT 1 AS RetValue, 'Successfully Inserted/Updated' AS Remark

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END
