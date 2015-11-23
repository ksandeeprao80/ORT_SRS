IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetTempRespondent]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetTempRespondent]

GO

--EXEC UspGetTempRespondent 
CREATE PROCEDURE DBO.UspGetTempRespondent
	@SessionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		TempId, ISNULL(CustomerId,0) AS CustomerId, ISNULL(EmailId,'') AS EmailId, ISNULL(PanelistId,0) AS PanelistId, 
		ISNULL(FirstName,'') AS FirstName, ISNULL(LastName,'') AS LastName, ISNULL(Age,'') AS Age, BirthDate, 
		ISNULL(Gender,'') AS Gender, ISNULL(Town,'') AS Town, ISNULL(UDF1,'') AS UDF1, ISNULL(UDF2,'') AS UDF2, 
		ISNULL(UDF3,'') AS UDF3, ISNULL(UDF4,'') AS UDF4, ISNULL(UDF5,'') AS UDF5, ISNULL([Status],'') AS [Status], 
		ISNULL(StatusMessage,'') AS StatusMessage, ISNULL(SessionId,0) AS SessionId, ISNULL(UserId,'') AS UserId
	FROM DBO.TempRespondent WITH(NOLOCK)
	WHERE SessionId = @SessionId 

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS ErrorNumber, Error_Message() AS ErrorMessage
END CATCH 

SET NOCOUNT OFF
END

