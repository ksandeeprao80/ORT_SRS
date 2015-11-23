IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspUpdateReferalCount]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].UspUpdateReferalCount

-- EXEC UspUpdateReferalCount 1346,23

GO
CREATE PROCEDURE DBO.UspUpdateReferalCount
	@SurveyId INT,
	@RefereeId INT,
	@Channel VARCHAR(100)	 
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	BEGIN TRAN
	
	DECLARE @Count INT
	SET @Count = 0

	IF EXISTS
	(	
		SELECT 1 FROM DBO.TR_RespondentReferalCount 
		WHERE SurveyId = @SurveyId AND RespondentId = @RefereeId AND LTRIM(RTRIM(Channel)) = LTRIM(RTRIM(@Channel))
	)
	BEGIN
		UPDATE DBO.TR_RespondentReferalCount
		SET ReferalCount =  ReferalCount+1
		WHERE SurveyId = @SurveyId AND RespondentId = @RefereeId
			AND LTRIM(RTRIM(Channel)) = LTRIM(RTRIM(@Channel))
		
		SELECT 1 AS RetValue, 'Successfully Updated' AS Remark
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TR_RespondentReferalCount
		(SurveyId, RespondentId, Channel, ReferalCount)
		VALUES(@SurveyId, @RefereeId, @Channel, 1)
		
		SET @Count = @@ROWCOUNT
		
		SELECT CASE WHEN ISNULL(@Count,0) = 0 THEN 0 ELSE 1 END AS RetValue, 
			CASE WHEN ISNULL(@Count,0) = 0 THEN 'Insert Failed' ELSE 'Successfully Inserted' END AS Remark
	END

	COMMIT TRAN  
  
END TRY    
    
BEGIN CATCH  
	ROLLBACK TRAN  
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark  
END CATCH   
  
SET NOCOUNT OFF  
END 






