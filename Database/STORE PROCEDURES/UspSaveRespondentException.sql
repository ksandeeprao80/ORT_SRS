IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveRespondentException]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspSaveRespondentException
GO
CREATE PROCEDURE DBO.UspSaveRespondentException
	@SessionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	DECLARE @RowCount INT
	SET @RowCount = 0

	INSERT INTO DBO.TR_RespondentException
	(
		CustomerId, EmailId, PanelistId, FirstName, LastName, Age, BirthDate, Gender, Town, 
		UDF1, UDF2, UDF3, UDF4, UDF5, Status, StatusMessage, SessionId, UserId, SrNo
	)
	SELECT 
		CustomerId, EmailId, PanelistId, FirstName, LastName, Age, BirthDate, Gender, Town, 
		UDF1, UDF2, UDF3, UDF4, UDF5, Status, StatusMessage, SessionId, UserId, SrNo
	FROM DBO.TempRespondent
	WHERE [Status] = 'E'
	AND SessionId = @SessionId 
	
	SET @RowCount = @@ROWCOUNT

	IF @RowCount > 0
	BEGIN 
		DELETE FROM DBO.TempRespondent WHERE Status = 'E' AND SessionId = @SessionId  
	END
	
	SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark, ISNULL(@RowCount,0) AS ExceptionCount

	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END