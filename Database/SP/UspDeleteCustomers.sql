IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspDeleteCustomers]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspDeleteCustomers]
GO

--EXEC UspDeleteCustomers 

CREATE PROCEDURE DBO.UspDeleteCustomers
	@CustomerName VARCHAR(150),
	@Abbreviation VARCHAR(20)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN

	UPDATE DBO.MS_Customers
	SET IsActive = 0
	WHERE LTRIM(RTRIM(CustomerName)) = LTRIM(RTRIM(@CustomerName))
		AND LTRIM(RTRIM(Abbreviation)) = LTRIM(RTRIM(@Abbreviation))

	SELECT 1 AS RetValue, 'Successfully Deleted' AS Remark
	
	COMMIT TRAN

END TRY  
  
BEGIN CATCH
	ROLLBACK TRAN
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END

