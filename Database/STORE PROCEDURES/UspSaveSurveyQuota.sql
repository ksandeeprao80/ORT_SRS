IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveSurveyQuota]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveSurveyQuota]
GO
-- EXEC UspSaveSurveyQuota 
CREATE PROCEDURE DBO.UspSaveSurveyQuota
	@SurveyId INT,
	@QuotaId INT,
	@Limit CHAR(10)
AS
SET NOCOUNT ON
BEGIN
BEGIN TRY

	IF EXISTS
	(
		SELECT 1 FROM DBO.TR_SurveyQuota WITH(NOLOCK)
		WHERE SurveyId = @SurveyId AND QuotaId = @QuotaId
	) 
	BEGIN
		SELECT 1 AS RetValue, 'Already Exist In The System' AS Remark 
		
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO DBO.TR_SurveyQuota
		(		
			SurveyId, QuotaId, Limit
		)
		VALUES
		(
			@SurveyId, @QuotaId, LTRIM(RTRIM(@Limit))
	 	)
	
		SELECT 1 AS RetValue, 'Successfully Inserted' AS Remark
		
		RETURN
	END
END TRY  
  
BEGIN CATCH
	SELECT Error_Number() AS RetValue, Error_Message() AS Remark
END CATCH 

SET NOCOUNT OFF
END