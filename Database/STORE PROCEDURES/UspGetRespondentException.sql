IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspGetRespondentException]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspGetRespondentException]

GO

--EXEC UspGetRespondentException 
CREATE PROCEDURE DBO.UspGetRespondentException
	@SessionId INT
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	SELECT 
		ExceptionId, LTRIM(RTRIM(ISNULL(CustomerId,''))) AS CustomerId, 
		LTRIM(RTRIM(ISNULL(EmailId,''))) AS EmailId, LTRIM(RTRIM(ISNULL(PanelistId,''))) AS PanelistId, 
		LTRIM(RTRIM(ISNULL(FirstName,''))) AS FirstName, LTRIM(RTRIM(ISNULL(LastName,''))) AS LastName, 
		LTRIM(RTRIM(ISNULL(Age,''))) AS Age, LTRIM(RTRIM(ISNULL(BirthDate,''))) AS BirthDate, 
		LTRIM(RTRIM(ISNULL(Gender,''))) AS Gender, LTRIM(RTRIM(ISNULL(Town,''))) AS Town, 
		LTRIM(RTRIM(ISNULL(UDF1,''))) AS UDF1, LTRIM(RTRIM(ISNULL(UDF2,''))) AS UDF2, 
		LTRIM(RTRIM(ISNULL(UDF3,''))) AS UDF3, LTRIM(RTRIM(ISNULL(UDF4,''))) AS UDF4, 
		LTRIM(RTRIM(ISNULL(UDF5,''))) AS UDF5, LTRIM(RTRIM(ISNULL([Status],''))) AS [Status], 
		LTRIM(RTRIM(ISNULL(StatusMessage,''))) AS StatusMessage, SessionId, UserId,
		ISNULL(SrNo,'') AS SrNo
	FROM DBO.TR_RespondentException WITH(NOLOCK)
	WHERE SessionId = @SessionId
	ORDER BY ExceptionId ASC

END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

 